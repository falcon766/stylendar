// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const database = admin.database();
//
// const elastic = require('../codebase/elastic');
//
// // Traverses the database to get the newsfeed, the following of followers and the followers of following.
// function traverse(uid, closure) {
// 	const followersPromise = database.ref(`/veins/followers/${uid}`).once('value');
// 	const followingPromise = database.ref(`/veins/following/${uid}`).once('value');
//
// 	return Promise.all([followersPromise, followingPromise]).then((snapshots) => {
// 		if (!snapshots[0].val() || !snapshots[1].val()) {
// 			return Promise.reject('user doesn`t have any followers, nor doesn\' follow anyone');
// 		}
// 		const followers = snapshots[0].val();
// 		const following = snapshots[1].val();
//
// 		// Now, let's retrieve the followers newsfeed and following and the following followers. See more: http://imgur.com/a/pzbtf
// 		var postsPromises = [], followingPromises = [], followersPromises = [];
// 		followers.forEach((follower) => {
// 			if (!follower.uid) { return; }
//
// 			const postsRef = database.ref(`/veins/newsfeed/${follower.uid}`);
// 			const postsPromise = postsRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			postsPromises.push(postsPromise);
//
// 			const followingRef = database.ref(`/veins/following/${follower.uid}`);
// 			const followingPromise = followingRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			followingPromises.push(followingPromise);
// 		});
//
// 		following.forEach((following) => {
// 			if (!following.uid) { return; }
//
// 			const followerRef = database.ref(`/veins/followers/${following.uid}`);
// 			const followerPromise = followerRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			followersPromises.push(followerPromise);
// 		});
//
// 		return Promise.all([postsPromises, followingPromises, followersPromises]).then((aggrSnapshots) => {
//
// 			//	We're finally making the updates.
// 			var promises = [];
//
// 			// These are aggregated snapshots (posts, following of followers, followers of following), which means their children are actually the
// 			// snapshots arrays.
// 			aggrSnapshots.forEach((aggrSnapshot) => {
// 				aggrSnapshot.forEach((snapshot) => {
// 					closure(promises, snapshot);
// 				})
// 			});
//
// 			return Promise.all(promises);
// 		});
// 	});
// }
//
// //	Updates the tangential data of the user's profile (newsfeed, followers, following).
// function update(data) {
// 	//	We have to verify if this isn't a data leak and the value is null now. In that case, we stop here because this is not the intended purpose.
// 	for (var property in data) {
// 		if (data.hasOwnProperty(property) && !data[property]) {
// 			console.log(`profile:${data.key}: some information is missing. Verify the data is correct in the Realtime Database.`);
// 			return;
// 		}
// 	}
//
// 	// Retrieve the followers and the following.
// 	const followersPromise = database.ref(`/veins/followers/${data.uid}`).once('value');
// 	const followingPromise = database.ref(`/veins/following/${data.uid}`).once('value');
//
// 	return Promise.all([followersPromise, followingPromise]).then((snapshots) => {
// 		if (!snapshots[0].val() || !snapshots[1].val()) {
// 			return Promise.reject('user doesn`t have any followers, nor doesn\' follow anyone');
// 		}
// 		const followers = snapshots[0].val();
// 		const following = snapshots[1].val();
//
// 		// Now, let's retrieve the followers newsfeed and following and the following followers. See more: http://imgur.com/a/pzbtf
// 		var postsPromises = [], followingPromises = [], followersPromises = [];
// 		followers.forEach((follower) => {
// 			if (!follower.uid) { return; }
//
// 			const postsRef = database.ref(`/veins/newsfeed/${follower.uid}`);
// 			const postsPromise = postsRef.orderByChild('uid').equalTo(`${data.uid}`).once('value');
// 			postsPromises.push(postsPromise);
//
// 			const followingRef = database.ref(`/veins/following/${follower.uid}`);
// 			const followingPromise = followingRef.orderByChild('uid').equalTo(`${data.uid}`).once('value');
// 			followingPromises.push(followingPromise);
// 		});
//
// 		following.forEach((following) => {
// 			if (!following.uid) { return; }
//
// 			const followerRef = database.ref(`/veins/followers/${following.uid}`);
// 			const followerPromise = followerRef.orderByChild('uid').equalTo(`${data.uid}`).once('value');
// 			followersPromises.push(followerPromise);
// 		});
//
// 		return Promise.all([postsPromises, followingPromises, followersPromises]).then((aggrSnapshots) => {
//
// 			//	We're finally making the updates.
// 			var promises = [];
//
// 			//	Interesting to note that each child has the same layout ('name', 'username', 'profileImageUrl'), so we can safely write a closure
// 			//	to keep the code DRY.
// 			const updateClosure = ((promises, snapshot) => {
// 				var updates = {};
// 				snapshot.forEach((child) => {
// 					updates[child.key] = child.val();
// 					for (var i = 0; i < data.keys.length; ++i) {
// 						const key = data.keys[i];
// 						const value = data.values[i];
// 						updates[child.key][key] = value;
// 					}
// 				});
// 				const promise = snapshot.ref.update(updates);
// 				promises.push(promise);
// 			});
//
// 			// These are aggregated snapshots (posts, following of followers, followers of following), which means their children are actually the
// 			// snapshots arrays.
// 			aggrSnapshots.forEach((aggrSnapshot) => {
// 				aggrSnapshot.forEach((snapshot) => {
// 					updateClosure(snapshot);
// 				})
// 			});
//
// 			return Promise.all(promises);
// 	});
// });
// 	// // We smartly update only the user's followers posts (and of course the followers and the following themselves).
// 	// return database.ref(`/veins/followers/${data.uid}`).once('value').then((snapshot) => {
// 	// 	if (!snapshot.exists()) { return; }
// 	// 	var promises = [];
// 	// 	const followers = snapshot.val();
// 	//
// 	// 	// Iterate the followers.
// 	// 	var promises = [];
// 	// 	followers.forEach((follower) => {
// 	// 		if (!follower.uid) { return; }
// 	//
// 	// 		// Now, for each follower, we have to retrieve the `posts` and the `following` and change the `value` of the current `key` parsed as parameters.
// 	// 		const postsRef = database.ref(`/veins/newsfeed/${follower.uid}`);
// 	// 		const postsPromise = postsRef.orderByChild('uid').equalTo(`${data.uid}`).once('value');
// 	//
// 	// 		const followingRef = database.ref(`/veins/newsfeed/${follower.uid}`);
// 	// 		const followingPromise = postsRef.orderByChild('uid').equalTo(`${data.uid}`).once('value');
// 	// 		promises.push(promise);
// 	// 	});
// 	// 	// return Promise.all(promises);
// 	// }).then((snapshots) => {
// 	//
// 	// 	// Now, let's finally update the values on the children.
// 	// 	var promises = [];
// 	// 	snapshots.forEach((snapshot) => {
// 	//
// 	// 		var updates = {};
// 	// 		snapshot.forEach((child) => {
// 	// 			updates[child.key] = child.val();
// 	// 			for (var i = 0; i < data.keys.length; ++i) {
// 	// 				const key = data.keys[i];
// 	// 				const value = data.values[i];
// 	// 				updates[child.key][key] = value;
// 	// 			}
// 	// 		});
// 	// 		const promise = snapshot.ref.update(updates);
// 	// 		promises.push(promise);
// 	// 	});
// 	// 	return Promise.all(promises);
// 	// }).catch((error) => {
// 	// 	console.log(`profile:${data.key}: the promises system failed with the following error: `, error);
// 	// });
// }
//
//
// // Removes the tangential data of the user's profile (newsfeed, followers, following).
// function remove(uid) {
// 	var promises = [];
// 	const veins = database.ref('/veins');
//
// 	// First off, we removes the deleted user's own entries in the veins.
// 	const update = {
// 		[uid]: null
// 	};
// 	const newsfeedPromise = veins.ref('/newsfeed').update(update);
// 	const ownFollowersPromise = veins.ref('/followers').update(update);
// 	const ownFollowingPromise = veins.ref('/followers').update(update);
// 	promises.push(newsfeedPromise, ownFollowersPromise, ownFollowingPromise);
//
// 	// Then, we scan the database for entries in other users' newsfeed, followers or following.
//
// 	// Retrieve the followers and the following.
// 	const followersPromise = database.ref(`/veins/followers/${uid}`).once('value');
// 	const followingPromise = database.ref(`/veins/following/${uid}`).once('value');
//
// 	return Promise.all([followersPromise, followingPromise]).then((snapshots) => {
// 		if (!snapshots[0].val() || !snapshots[1].val()) {
// 			return Promise.reject('user doesn`t have any followers, nor doesn\' follow anyone');
// 		}
// 		const followers = snapshots[0].val();
// 		const following = snapshots[1].val();
//
// 		// Now, let's retrieve the followers newsfeed and following and the following followers. See more: http://imgur.com/a/pzbtf
// 		var postsPromises = [], followingPromises = [], followersPromises = [];
// 		followers.forEach((follower) => {
// 			if (!follower.uid) { return; }
//
// 			const postsRef = database.ref(`/veins/newsfeed/${follower.uid}`);
// 			const postsPromise = postsRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			postsPromises.push(postsPromise);
//
// 			const followingRef = database.ref(`/veins/following/${follower.uid}`);
// 			const followingPromise = followingRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			followingPromises.push(followingPromise);
// 		});
//
// 		following.forEach((following) => {
// 			if (!following.uid) { return; }
//
// 			const followerRef = database.ref(`/veins/followers/${following.uid}`);
// 			const followerPromise = followerRef.orderByChild('uid').equalTo(`${uid}`).once('value');
// 			followersPromises.push(followerPromise);
// 		});
//
// 		return Promise.all([postsPromises, followingPromises, followersPromises]).then((aggrSnapshots) => {
//
// 			//	We're finally making the updates.
// 			var promises = [];
//
// 			//	Interesting to note that each child has the same layout ('name', 'username', 'profileImageUrl'), so we can safely write a closure
// 			//	to keep the code DRY.
// 			const updateClosure = ((snapshot) => {
// 				var updates = {};
// 				snapshot.forEach((child) => {
// 					updates[child.key] = null;
// 				});
// 				const promise = snapshot.ref.update(updates);
// 				promises.push(promise);
// 			});
//
// 			// These are aggregated snapshots (posts, following of followers, followers of following), which means their children are actually the
// 			// snapshots arrays.
// 			aggrSnapshots.forEach((aggrSnapshot) => {
// 				aggrSnapshot.forEach((snapshot) => {
// 					updateClosure(snapshot);
// 				})
// 			});
// 	});
// }
//
// //	#denormalizeddataproblems
// //	The goal of these listeners is to always update the names, the usernames and the profile image urls throughout the Firebase Realtime database and
// //	the elasticsearch when the user edits his profile. The places where changes have to be applied are:
// //
// //	1. The `newsfeed`. Each post has the name, the username and the profileImageUrl.
// //	2. To be continued
// const sync = functions.database.ref('/users/{uid}').onWrite((event) => {
// 	var data = {
// 		uid: event.params.uid,
// 		keys: [],
// 		values: []
// 	};
//
// 	// Define this here to keep the code DRY.
// 	const catchClosure = ((error) => {
// 		console.log(`profile:${data.key}: the promises system failed with the following error: `, error);
// 	});
//
// 	// The data was barely created. Only the elastic is triggered not because there's no other data to insert.
// 	if (!event.data.previous.exists()) {
// 		const promises = [remove(data.uid), elastic.create(data.uid, event.data.val())];
// 		return Promise.all(promises).catch(catchClosure);
// 	}
// 	// The data was deleted. Not only the elastic is triggeded here, but we also have to delete the stylendar, newsfeed, followers and following entries.
// 	if (!event.data.exists()) {
// 		return elastic.remove(data.uid).catch(catchClosure);
// 	}
//
// 	// If we arrived here, the data was updated.
// 	// We check to see if it was updated something which requires a further edit in the database (`name`, `username` or `profileImageUrl`).
// 	const user = event.data.val();
// 	const previousUser = event.data.previous.val();
//
// 	// nameWasChanged
// 	if (user.name.first != previousUser.name.first) {
// 		data.keys.push('name');
// 		data.values.push(user.name.first);
// 	}
//
// 	// usernameWasChanged
// 	if (user.username != previousUser.username) {
// 		data.keys.push('username');
// 		data.values.push(user.username);
// 	}
//
// 	// profileImageUrlWasChanged
// 	if (user.profileImageUrl != previousUser.profileImageUrl) {
// 		data.keys.push('profileImageUrl');
// 		data.values.push(user.profileImageUrl);
// 	}
//
// 	if (data.keys.length > 0) {
// 		const promises = [update(data), elastic.update(data.uid, data.keys, data.values)];
// 		return Promise.all(promises).catch(catchClosure);
// 	}
// });
//
// module.exports = {sync};
