'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const constants = require('../../codebase/constants');
const strings = require('../../codebase/strings');

const handler = require('./handler');

function handle(event, metadata) {

	// Get the data from the event.
	const uid = metadata.uid;
	const user = metadata.user;

	// We have to retrieve the user's username, profileImageUrl and, the most crucial, the fcmToken. Without the latter, there's no push at all.
	return database.ref(`/users/${uid}/fcmToken`).once('value').then((snapshot) => {
		if (!snapshot.exists() || !snapshot.val()) { return; }

		const fcmToken = snapshot.val();
		// Some follower notification messages have an '%@', which has to be replaced with the username of the follower.
		metadata.message = metadata.message.replace('%@', user.username);

		// Wrap the information sent to the fcm handler into a nice object.
		const data = {
			fcmToken: fcmToken,
			title: metadata.title,
			message: metadata.message,
			type: metadata.type,
			user: {
				uid: user.uid,
				name: user.name,
				username: user.username,
				profileImageUrl: user.profileImageUrl
			}
		};

		// Use the handler to send it.
		return handler.generateModelAndDeliverPushNotification(data);
	}).catch((error) => {
		console.log(`notifications:${__filename}: the promises system failed with the following error: `, error);
	});
}

// Listen for any follower which gets added or removed.
const followers = functions.database.ref('/veins/followers/{uid}/{pushId}').onWrite(event => {
	// We stop here if the follower was removed. We don't want to anything in this case.
	if (!event.data.val()) { return; }

	return database.ref(`/users/${event.params.uid}`).once('value').then((snapshot) => {
		const user = snapshot.val();

		// We send different notifications based upon the privacy of the user:
		//
		// a public stylendar send the push directly to the owner that he has a new follower
		// a private stylendar means we have to alert the person who requested to follow that his request was accepted
		var metadata;
		if (user.privacy.isStylendarPublic) {
			metadata = {
				uid: event.params.uid,
				user: event.data.val(),
				type: constants.kSTNotificationFollower,
				title: strings.notificationFollowerTitle,
				message: strings.notificationFollowerMessage
			};
		} else {
			metadata = {
				uid: event.data.val().uid,
				user: {
					uid: event.params.uid,
					name: user.name.first,
					username: user.username,
					profileImageUrl: user.profileImageUrl
				},
				type: constants.kSTNotificationFollowerRequestAccepted,
				title: strings.notificationFollowerRequestAcceptedTitle,
				message: strings.notificationFollowerRequestAcceptedMessage
			};
		}

		handle(event, metadata);
	}).catch((error) => {
		console.trace(`notifications:${__filename}: the promises system failed with the following error: ${error}, stack: ${error.stack}`);
	});
});

const requests = functions.database.ref('/veins/requests/{uid}/{pushId}').onWrite(event => {
	// We stop here if the follower was removed. We don't want to do anything in this case.
	if (!event.data.val()) { return; }

	const metadata = {
		uid: event.params.uid,
		user: event.data.val(),
		type: constants.kSTNotificationFollowerRequest,
		title: strings.notificationFollowerRequestTitle,
		message: strings.notificationFollowerRequestMessage
	};

	handle(event, metadata);
});

module.exports = { followers, requests };

// 'use strict';
//
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const database = admin.database();
//
// const constants = require('../../codebase/constants');
// const strings = require('../../codebase/strings');
//
// const handler = require('./handler');
//
// // Listen for any follower which gets added or removed.
// const followers = functions.database.ref('/veins/followers/{uid}/{pushId}').onWrite(event => {
// 	// We stop here if the follower was removed. We don't want to anything in this case.
// 	if (!event.data.val()) { return; }
//
// 	// We have to know if this is a follow request accepted trigger.
// 	const acceptanceEvent = event.data.previous.val() ? (event.data.previous.val().accepted != event.data.val().accepted ? true : false) : false;
//
// 	// Get the data from the event.
// 	const uid = event.params.uid;
// 	const follower = event.data.val();
//
// 	// We have to retrieve the user's username, profileImageUrl and, the most crucial, the fcmToken. Without the latter, there's no push at all.
// 	return database.ref(`/users/${uid}/fcmToken`).once('value').then((snapshot) => {
// 		if (!snapshot.exists() || !snapshot.val()) { return; }
//
// 		const fcmToken = snapshot.val();
// 		var type = '', title = '', message = '';
//
// 		// We send a different notification title and message if the follower entry was an actual edge created or a request (this depends on the privacy
// 		// of the account, if it has the stylendar public or private).
// 		if (follower.accepted) {
// 			if (!acceptanceEvent) {
// 				type = constants.kSTNotificationFollower;
// 				title = strings.notificationFollowerTitle;
// 				message = strings.notificationFollowerMessage;
// 			} else {
// 				type = constants.kSTNotificationFollowerRequestAccepted;
// 				title = strings.notificationFollowerRequestAcceptedTitle;
// 				message = strings.notificationFollowerRequestAcceptedMessage;
// 			}
// 		} else {
// 			type = constants.kSTNotificationFollowerRequest;
// 			title = strings.notificationFollowerRequestTitle;
// 			message = strings.notificationFollowerRequestMessage;
// 		}
//
// 		// Some follower notification messages have an '%@', which has to be replaced with the username of the follower.
// 		message = message.replace('%@', follower.username);
//
// 		// Wrap the information sent to the fcm handler into a nice object.
// 		const data = {
// 			fcmToken: fcmToken,
// 			title: title,
// 			message: message,
// 			type: type,
// 			follower: {
// 				uid: follower.uid,
// 				name: follower.name,
// 				username: follower.username,
// 				profileImageUrl: follower.profileImageUrl
// 			}
// 		};
//
// 		// Use the handler to send it.
// 		return handler.generateModelAndDeliverPushNotification(data);
// 	}).catch((error) => {
// 		console.log(`notifications:${__filename}: the promises system failed with the following error: `, error);
// 	});
// });
//
// module.exports = { followers };
