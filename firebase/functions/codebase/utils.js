const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Verifies if the supplied key matches with the one saved in the Firebase environment.
function verifyKey(key) {
  // Exit if the keys don't match
  const cronKey = functions.config().cron.key;
  if (!key || !cronKey || key !== cronKey) {
    console.log(
      "The key provided in the request does not match the key set in the environment. Check that",
      key,
      "matches the cron.key attribute in `firebase env:get`",
    );
    return false;
  }

  return true;
}

// Creates a formatted date, which:
// 1. Has the format YYYY/MM/DD
// 2. It doesn't contain any Firebase-imposing prefix ('y', 'm' or 'd').
// 3.it's zero-padded when the day or hte month is lower than 0.
function padZero(value) {
  return value.replace(/\b(\d{1})\b/g, "0$1");
}

function formatDate(year, month, day) {
  const formattedYear = year.replace("y", "");
  const formattedMonth = padZero(month.replace("m", ""));
  const formattedDay = padZero(day.replace("d", ""));

  return formattedYear + "/" + formattedMonth + "/" + formattedDay;
}

// Delivers a push notification using the FCM (Firebase Cloud Messaging).
function deliverPushNotification(fcmToken, payload, options) {
  // We can't send any push without a token and a proper payload.
  if (!fcmToken || !payload) {
    console.log("deliverPushNotification: make sure the fcmToken and the payload are valid", fcmToken, payload);
    return false;
  }

  // Using the admin to finally send it. Maybe we'll add a handler in the future which will delete the token from the Realtime Database where there
  // is a `messaging/invalid-registration-token` or a `messaging/registration-token-not-registered`.
  //
  // See more: https://github.com/firebase/functions-samples/blob/master/fcm-notifications/functions/index.js
  return admin
    .messaging()
    .sendToDevice(fcmToken, payload, options)
    .then(response => {
      console.log("utils:deliverPushNotification: successfully sent message:", response);
    });
}

module.exports = { verifyKey, padZero, formatDate, deliverPushNotification };
