'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const elastic = require('../../codebase/elastic');

const deauthenticate = require('./deauthenticate');
// const storage = require('./storage');

// Traverses the database to get the newsfeed, the following of followers and the followers of following.
function traverse(uid, closure) {
	const veins = database.ref('/veins');
	const followersPromise = veins.child(`/followers/${uid}`).once('value');
	const followingPromise = veins.child(`/following/${uid}`).once('value');

	return Promise.all([followersPromise, followingPromise]).then((snapshots) => {
		if (!snapshots[0].exists() && !snapshots[1].exists()) {
			console.log(`profile:${__filename} user doesn\'t have any followers, nor doesn\'t follow anyone`);
			return true;
		}
		const followers = snapshots[0];
		const following = snapshots[1];

		// Now, let's retrieve the newsfeed of followers, the following of followers and the followers of following. See more: http://imgur.com/a/pzbtf
		var promises = [];
		followers.forEach((child) => {
			const follower = child.val();
			if (!follower.uid) { return; }

			const postsRef = veins.child(`/newsfeed/${follower.uid}`);
			const postsPromise = postsRef.orderByChild('uid').equalTo(`${uid}`).once('value');
			promises.push(postsPromise);

			const followingRef = veins.child(`/following/${follower.uid}`);
			const followingPromise = followingRef.orderByChild('uid').equalTo(`${uid}`).once('value');
			promises.push(followingPromise);
		});

		following.forEach((child) => {
			const following = child.val();
			if (!following.uid) { return; }

			const followerRef = veins.child(`/followers/${following.uid}`);
			const followerPromise = followerRef.orderByChild('uid').equalTo(`${uid}`).once('value');
			promises.push(followerPromise);
		});

		return Promise.all(promises).then((aggrSnapshots) => {

			//	We're finally making the updates.
			var promises = [];

			// These are aggregated snapshots (posts, following of followers, followers of following).
			aggrSnapshots.forEach((snapshot) => {
				closure(promises, snapshot);
			});

			return Promise.all(promises);
		});
	});
}

// Updates the tangential data of the user's profile (newsfeed, followers, following).
function update(data) {
	// We have to verify if this isn't a data leak and the value is null now. In that case, we stop here because this is not the intended purpose.
	for (var property in data) {
		if (data.hasOwnProperty(property) && !data[property]) {
			console.log(`profile:${__filename}:${data.key}: some information is missing, verify the data is correct in the Realtime Database.`);
			return;
		}
	}

	// Traverse the database to update the followers and following.
	const updateClosure = ((promises, snapshot) => {
		var updates = {};
		snapshot.forEach((child) => {
			updates[child.key] = child.val();
			for (var i = 0; i < data.keys.length; ++i) {
				const key = data.keys[i];

				// We have to check for the `name` because it's an object and the newsfeed, followers and following only store the light version of the user,
				// which stores only the first name.
				var value;
				if (key != 'name') {
					value = data.values[i];
				} else {
					value = data.values[i].first;
				}
				updates[child.key][key] = value;
			}
		});
		const promise = snapshot.ref.update(updates);
		promises.push(promise);
	});

	return traverse(data.uid, updateClosure);
}


// Removes the tangential data of the user's profile (newsfeed, followers, following).
function remove(uid) {
	// First off, we scan the database for entries in other users' newsfeed, followers or following.
	const updateClosure = ((promises, snapshot) => {
		var updates = {};
		snapshot.forEach((child) => {
			updates[child.key] = null;
		});
		const promise = snapshot.ref.update(updates);
		promises.push(promise);
	});

	var promises = [];
	promises = promises.concat(traverse(uid, updateClosure));


	// Highly important observation: we push the own promises after the traversed ones (relative to others) are resolved, because otherwise
	// the data will be deleted firsthand and there won't be any followers of following and following of followers to remove.
	return Promise.all(promises).then(() => {
		const update = { [uid]: null };
		const veins = database.ref('/veins');

		// We remove the deleted user's own entries in the veins.
		const stylendarPromise = veins.child('/stylendar').update(update);
		const newsfeedPromise = veins.child('/newsfeed').update(update);
		const ownFollowersPromise = veins.child('/followers').update(update);
		const ownFollowingPromise = veins.child('/following').update(update);

		promises.push(stylendarPromise, newsfeedPromise, ownFollowersPromise, ownFollowingPromise);
		return promises;
	});
}

//	#denormalizeddataproblems
//	The goal of these listeners is to always update the names, the usernames and the profile image urls throughout the Firebase Realtime database and
//	the elasticsearch when the user edits his profile. The places where changes have to be applied are:
//
//	1. The `newsfeed`. Each post has the name, the username and the profileImageUrl.
//	2. To be continued
const sync = functions.database.ref('/users/{uid}').onWrite((event) => {
	var data = {
		uid: event.params.uid,
		keys: [],
		values: []
	};

	// Define this here to keep the codebase DRY.
	const catchClosure = ((error) => {
		console.log(`profile:${__filename}: the promises system failed with the following error:`, error);
	});

	// The data was barely created. Only the elastic is triggered not because there's no other data to insert.
	if (!event.data.previous.exists()) {
		return elastic.create(data.uid, event.data.val());
	}

	// The data was deleted. We have to delete:
	//
	// 1. The database stylendar, newsfeed, followers and following entries.
	// 2. The stored files in the profile and stylendar buckets.
	// 3. The elastic search entries.
	if (!event.data.exists()) {
		const promises = [remove(data.uid), /*storage.remove(data.uid),*/ elastic.remove(data.uid)];
		return Promise.all(promises).then(() => {
			return deauthenticate(data.uid);
		}).catch(catchClosure);
	}

	// If we arrived here, the data was updated.
	// We check to see if it was updated something which requires a further edit in the database (`name`, `username` or `profileImageUrl`).
	const user = event.data.val();
	const previousUser = event.data.previous.val();

	// nameWasChanged
	if (user.name.full != previousUser.name.full) {
		data.keys.push('name');
		data.values.push(user.name);
	}

	// usernameWasChanged
	if (user.username != previousUser.username) {
		data.keys.push('username');
		data.values.push(user.username);
	}

	// profileImageUrlWasChanged
	if (user.profileImageUrl != previousUser.profileImageUrl) {
		data.keys.push('profileImageUrl');
		data.values.push(user.profileImageUrl);
	}

	// We finally return the promises here. Important to note that the elasticsearch doesn't need the `profileImageUrl` because it doesn't provide
	// a search scope for the user.
	if (data.keys.length > 0) {
		const firebasePromise = update(data);
		// const elasticPromise = elastic.update(data.uid, _.without(data.keys,'profileImageUrl'), data.values);
		const elasticPromise = elastic.update(data.uid, data.keys, data.values);
		return Promise.all([firebasePromise, elasticPromise]).catch(catchClosure);
	}
});

module.exports = sync;
