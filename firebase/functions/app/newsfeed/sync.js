'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const moment = require('moment');

const utils = require('../../codebase/utils');

// If the `onWrite` listener yielded some data which was just created, this means we have a new follower.
// After the user's profile was pulled, go iterate over his posts and append them to the new follower's news feed.
// EG: A started to follow B, then B's posts has to be in A' news feed.
function push(data, user, stylendar) {
	var promises = [];
	var update = {
		uid: data.uid,
		name: user.name.first,
		username: user.username,
		profileImageUrl: user.profileImageUrl,
		date: undefined,
		imageUrl: undefined,
		createdAt: moment().format()
	};

	// Perform a depth-first search into the stylendar. For each polaroid found we create
	// a post in the follower's newsfeed.
	//
	// We have to clearfix the `year`, `month` and `day` keys because they were all
	// prefixed with `y`, `m`, and `d`, so that we don't store data as arrays.
	//
	// Read more about it here:
	// https://stackoverflow.com/questions/15534917/why-do-firebase-collections-seem-to-begin-with-a-null-row.
	Object.keys(stylendar).forEach((year) => {
		const yearObj = stylendar[year];
		Object.keys(yearObj).forEach((month) => {
			const monthObj = yearObj[month];
			Object.keys(monthObj).forEach((day) => {
				// We also wish to pad-zero the days and the month if they are lower than 0, so that the dates will be string-sortable when they are retrieved.
				update.date = utils.formatDate(year, month, day);
				update.imageUrl = monthObj[day];
				if (!update.date || !update.imageUrl) { return; }

				// The path is `/veins/newsfeed/follower.uid` because the posts are for the new follower's news feed.
				const pushId = update.uid + update.date.replace(new RegExp('/', 'g'),'');
				const promise = database.ref(`/veins/newsfeed/${data.follower.uid}/${pushId}`).set(update);
				promises.push(promise);
			});
		});
	});

	return Promise.all(promises);
}


// If the `onWrite` listener yielded some data which was removed, this means a follower was removed.
function remove(data) {
	const ref = database.ref(`/veins/newsfeed/${data.follower.uid}`);
	return ref.orderByChild('uid').equalTo(data.uid).once('value').then((snapshot) => {
		var updates = {};
		snapshot.forEach((child) => {
			updates[child.key] = null;
		});
		return snapshot.ref.update(updates);
	});
}


// Listen for any follower which gets added or removed, so that we'll update the denormalized data with the posts of the newly followed user.
const sync = functions.database.ref('/veins/followers/{uid}/{pushId}').onWrite(event => {
	// Get the data from the event.
	const follower = event.data.val();
	const data = {
		uid: event.params.uid,
		follower: follower
	};

	// Let's get the user profile and append the appropiate information in the denormalized structure.
	const profilePromise = database.ref(`/users/${data.uid}`).once('value');
	const stylendarPromise = database.ref(`/veins/stylendar/${data.uid}`).once('value');

	// We also want to make sure there is no other follower in the database anymore (this cloud
	// function might be the response of a deletion caused by the fixer, which furthermore performed
	// the operation because there were n-plicates of the same follower).
	const existencePromise = database.ref(`/veins/followers/${event.params.uid}/${event.params.pushId}`)
														.orderByChild('uid')
														.equalTo(event.data.previous.val() ? event.data.previous.val().uid : 0)
														.once('value');

	return Promise.all([profilePromise, stylendarPromise, existencePromise]).then((snapshots) => {
		if (!snapshots[0].val() || !snapshots[1].val()) {
			return Promise.reject('either the profile or the stylendar doesn\'t exist, so there aren\'t any modifications to make at all');
		}
		const user = snapshots[0].val();
		const stylendar = snapshots[1].val();

		// The `onWrite` listener is for both creation and removal of data.
		if (event.data.val()) {
			return push(data, user, stylendar);
		} else {
			if (!snapshots[2].exists()) {
				data.follower = {};
				data.follower.uid = event.data.previous.val().uid;
				return remove(data);
			}
		}
	}).catch(error => {
		console.log(`newfeed:${__filename}: the promises system failed with the following error: `, error);
	});

});

module.exports = sync;
