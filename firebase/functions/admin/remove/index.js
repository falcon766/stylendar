"use strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const database = admin.database();

const strings = require("../../codebase/strings");
const utils = require("../../codebase/utils");

// This function doesn't listen to database changes, it's simply activated by a browser request or a cron.
const user = functions.https.onRequest((req, res) => {
  if (!req.query || utils.verifyKey(req.query.key) === false) {
    return res.status(403).send(strings.keyInvalidMessage);
  }

  // From many reasons, the request could be called with an invalid `uid` parameter.
  const uid = req.query.uid;
  if (!uid) {
    console.log(`admin:${__filename}: the uid parameter is invalid`);
    res.status(400).send("The provided uid parameter is invalid.");
    return;
  }

  var promises = [];
  // Sends the request to delete the user from rd and updates the user's browser window to let him know the result.
  const update = { [uid]: null };
  const profilePromise = database.ref("/users").update(update);
  promises.push(profilePromise);

  // The idea is that we want to also remove the reports from the admin path because they are not redudant.
  const reportPromise = database.ref("/admin/report").orderByChild("reportedUid").equalTo(`${uid}`).once("value");
  reportPromise
    .then(snapshot => {
      var updates = {};
      snapshot.forEach(child => {
        updates[child.key] = null;
      });
      const reportRemovePromise = snapshot.ref.update(updates);
      promises.push(reportRemovePromise);
      return Promise.all(promises);
    })
    // We have to return the 200 status to let the browser know the outcome.
    .then(() => {
      res.status(200).send("You've successfully removed the user.");
      return;
    })
    // Some nasty stuff occurred.
    .catch(error => {
      console.log(`admin:remove:${__filename}: the promises system failed with the following error: `, error);
      res.status(400).send("Sadly, error occured.");
      return;
    });
});

module.exports = { user };
