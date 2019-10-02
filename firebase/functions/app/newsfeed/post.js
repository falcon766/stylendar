'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const _ = require('lodash');
const moment = require('moment');

const utils = require('../../codebase/utils');

// After the user's profile was pulled, go iterate over his followers and append the polaroid.
function push(data, user, followers) {
	// Verify the user has any follower at all.
	if (!followers) {
		console.log(`newsfeed:${__filename}: user doesn\'t have any follower`);
		return;
	}


	// This is finally the object which will be in the news feeds.
	//
	// We have to clearfix the `year`, `month` and `day` keys because they were all prefixed with `y`, `m`, and `d`, so that we don't store data
	// as arrays. Read more about it here: https://stackoverflow.com/questions/15534917/why-do-firebase-collections-seem-to-begin-with-a-null-row.
	//
	// We also wish to pad-zero the days and the month if they are lower than 0, so that the dates will be string-sortable when they are retrieved.
	var update = {
		uid: data.uid,
		imageUrl: data.imageUrl,
		date: utils.formatDate(data.year, data.month, data.day),
		createdAt: moment().format()
	};

	var promises = [];

	// Firstly, let's add the post the self user's feed.
	const promise = database.ref(`/veins/newsfeed/${data.uid}`).push().set(update);
	promises.push(promise);

	// It'd be a shame to store the self profile of the user.
	_.merge(update, {
		username: user.username,
		name: user.name.first,
		profileImageUrl: user.profileImageUrl,
	});
	// Then, iterate the followers.
	followers.forEach((child) => {
		const follower = child.val();

		// Generate the newsfeed push promise.
		// const uid = follower[Object.keys(follower)[0]];
		const promise = database.ref(`/veins/newsfeed/${follower.uid}`).push().set(update);
		promises.push(promise);
	});
	return Promise.all(promises);
}

// If the `onWrite` listener yielded some data which was removed, this means a post was removed.
function remove(data, user, followers) {
	const date = utils.formatDate(data.year, data.month, data.day);

	var promises = [];

	// Firstly, let's remove the post from the self user's feed.
	const promise = database.ref(`/veins/newsfeed/${data.uid}`).orderByChild('date').equalTo(`${date}`).once('value');
	promises.push(promise);

	// Then, iterate the followers.
	followers.forEach((child) => {
		const follower = child.val();

		if (!follower.uid) { return; }

		// Now, for each follower, we have to iterate the posts and set on null the `value` of the current `key` parsed as parameter.
		const promise = database.ref(`/veins/newsfeed/${follower.uid}`).orderByChild('date').equalTo(`${date}`).once('value');
		promises.push(promise);
	});

	return Promise.all(promises).then((snapshots) => {
		// Now, let's finally update the values on the children.
		var promises = [];
		snapshots.forEach((snapshot) => {

			var updates = {};
			snapshot.forEach((child) => {
				updates[child.key] = null; // child.key represents the id of the post.
			});
			const promise = snapshot.ref.update(updates);
			promises.push(promise);
		});
		return Promise.all(promises);
	});
}

// Listen for any polaroid which gets added.
const post = functions.database.ref('/veins/stylendar/{uid}/{year}/{month}/{day}').onWrite(event => {
	// Get the data from the event.
	const data = {
		uid: event.params.uid,
		year: event.params.year,
		month: event.params.month,
		day: event.params.day,
		imageUrl: event.data.val()
	};

	// We want to make sure no invalid write operation passed through.
	for (var property in data) {
		if (data.hasOwnProperty(property) && !data[property] && property != 'imageUrl') {
			console.log(`newsfeed:${__filename}: some information is missing. Verify the data is correct in the Realtime Database.`);
			return;
		}
	}

	// Let's get the user profile and append the appropiate information in the denormalized structure.
	const profilePromise = database.ref(`/users/${data.uid}`).once('value');
	const followersPromise = database.ref(`/veins/followers/${data.uid}`).once('value');

	return Promise.all([profilePromise, followersPromise]).then((snapshots) => {
		if (!snapshots[0].val()) {
			return Promise.reject('user is invalid');
		}
		const user = snapshots[0].val();
		const followers = snapshots[1];

		// The `onWrite` listener is for both creation and removal of data.
		if (event.data.val()) {
			return push(data, user, followers);
		} else {
			return remove(data, user, followers);
		}
	}).catch((error) => {
		console.log(`newsfeed:${__filename}: the promises system failed with the following error: `, error);
	});
});

module.exports = post;
