'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const constants = require('../../codebase/constants');
const strings = require('../../codebase/strings');
const utils = require('../../codebase/utils');

const handler = require('./handler');

// This function doesn't listen to database changes, it's simply activated by a browser request or a cron.
const notifications = functions.https.onRequest((req, res) => {
	if (!req.query || utils.verifyKey(req.query.key) === false) {
		res.status(403).send(strings.keyInvalidMessage);
		return;
	}

	const today = new Date();
	database.ref('/users').once('value').then((snapshot) => {
		if (!snapshot.exists()) {
			res.status(200).send('No issues occurred, but there are no users to be sent notifications to.');
		}

		var promises = [], fcmTokens = [];
		snapshot.forEach((child) => {
			const user = child.val();
			if (!user || !user.utcOffset) { return; }

			// Before actually adding the stylendar promise into the array, let's check if the hours
			// indeed match for the user. The hours, obviously, are different across the globe and
			// we smartly store the utc offset just for these kind of cases.
			const userHour = today.getHours() + user.utcOffset;

			let shouldContinue = false;
			switch(userHour) {
			case constants.kSTNotificationReminderMorning:
				shouldContinue = true;
				break;
			case constants.kSTNotificationReminderEvening:
				shouldContinue = true;
				break;
			default:
				break;
			}
			if (shouldContinue) {
				fcmTokens.push(user.fcmToken);
				promises.push(database.ref(`/veins/stylendar/${child.key}`).once('value'));
			}
		});

		return Promise.all(promises).then((snapshots) => {
			var notificationPromises = [];

			for (var i = 0; i < fcmTokens.length; ++i) {
				const snapshot = snapshots[i];
				let shouldContinue = true;

				// If there's no stylendar at all, we'll of corso send the push.
				if (snapshot.exists()) {
					const stylendar = snapshot.val();

					// We check the stylendar to see if the user posted today.
					const yearKey = `y${today.getFullYear()}`;
					if (stylendar.hasOwnProperty(yearKey)) {
						const yearObj = stylendar[yearKey];
						const monthKey = `m${utils.padZero(today.getMonth() + 1 + '')}`;
						if (yearObj.hasOwnProperty(monthKey)) {
							const monthObj = yearObj[monthKey];
							const dayKey = `d${utils.padZero(today.getDate() + '')}`;
							if (monthObj.hasOwnProperty(dayKey)) {
								shouldContinue = false;
								break;
							}
						}
					}
				}
				if (!shouldContinue) { return; }

				// Wrap the information sent to the fcm handler into a nice object.
				const fcmToken = fcmTokens[i];
				const data = {
					fcmToken: fcmToken,
					title: strings.notificationReminderTitle,
					message: strings.notificationReminderMessage
				};
				notificationPromises.push(handler.generateModelAndDeliverPushNotification(data));
			}

			return Promise.all(notificationPromises).then(() => {
				res.status(200).send(`Sent ${notificationPromises.length} push notifications`);
			});
		});
	}).catch((error) => {
		console.trace(`cron:notifications:${__filename}: error occurred: ${error}, stack: ${error.stack}`);
		res.status(400).send(`Status 400. Error occurred.`);
	});
});

module.exports = notifications;
