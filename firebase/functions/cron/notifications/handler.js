"use strict";

const constants = require("../../codebase/constants");
const utils = require("../../codebase/utils");

// Generates the model using the give data and finally sends the push notification. We're also passing the
// Firebase Database Reference (`ref`) as a parameter because each type of notification has it's own dedicated
// place in the NoSQL JSON database.
//
// Observation: because it often happens the `imageUrl` to be empty, we place a default value here.
function generateModelAndDeliverPushNotification(data = {}) {
  // Generating the payload.
  const payloadData = {
    type: constants.kSTNotificationReminder,
  };

  const payload = {
    notification: {
      title: data.title,
      body: data.message,
      sound: "default",
    },
    data: payloadData,
  };

  const options = {
    priority: "high",
  };

  // Sending the actual push.
  const fcmPromise = utils.deliverPushNotification(data.fcmToken, payload, options);

  // return Promise.all([databasePromise, denormalizedPromise, fcmPromise]);
  return fcmPromise;
}

module.exports = { generateModelAndDeliverPushNotification };
