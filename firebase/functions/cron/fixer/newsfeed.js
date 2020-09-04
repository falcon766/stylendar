"use strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const database = admin.database();

const moment = require("moment");

const strings = require("../../codebase/strings");
const utils = require("../../codebase/utils");

function promisesForStylendarAndFollower(uid, stylendar, followerUid) {
  let promises = [];
  // Perform a depth-first search into the stylendar.
  Object.keys(stylendar).forEach(year => {
    const yearObj = stylendar[year];
    Object.keys(yearObj).forEach(month => {
      const monthObj = yearObj[month];
      Object.keys(monthObj).forEach(day => {
        // We also wish to pad-zero the days and the month if they are lower than 0,
        // so that the dates will be string-sortable when they are retrieved.
        const date = utils.formatDate(year, month, day);
        if (!date) {
          return;
        }

        // The path is `/veins/newsfeed/follower.uid` because the posts are for the new follower's news feed.
        const pushId = uid + date.replace(new RegExp("/", "g"), "");
        const verifyPromise = database.ref(`/veins/newsfeed/${followerUid}/${pushId}`).once("value");
        promises.push(verifyPromise);
      });
    });
  });

  return promises;
}

// This function doesn't listen to database changes, it's simply activated by a browser request or a cron.
const newsfeed = functions.https.onRequest((req, res) => {
  if (!req.query || utils.verifyKey(req.query.key) === false) {
    res.status(403).send(strings.keyInvalidMessage);
    return;
  }

  // We ensure the newsfeed works properly by verifying each user, each post and
  // each follower entry.
  const stylendarPromise = database.ref("/veins/stylendar").once("value");

  Promise.resolve(stylendarPromise)
    .then(snapshot => {
      let stylendars = [];

      snapshot.forEach(child => {
        const uid = child.key;
        const stylendar = child.val();
        if (!stylendar) {
          return;
        }
        stylendars[uid] = stylendar;
      });

      const followersPromise = database.ref("/veins/followers").once("value");
      return Promise.resolve(followersPromise).then(snapshot => {
        // Iterate over each follower and then over each stylendar post corresponding
        // to the current user being verified.
        let promises = [];
        snapshot.forEach(child => {
          const uid = child.key;
          const stylendar = stylendars[uid];
          const followers = child.val();

          Object.keys(followers).forEach(key => {
            const follower = followers[key];
            if (!follower || !follower.uid || !stylendar) {
              return;
            }

            promises = promises.concat(promisesForStylendarAndFollower(uid, stylendar, follower.uid));
          });

          // Let's not forget that the user should see his own posts.
          promises = promises.concat(promisesForStylendarAndFollower(uid, stylendar, uid));
        });

        return Promise.all(promises).then(snapshots => {
          // Check to see if there is any post missing.
          let promises = [],
            capsules = [];
          snapshots.forEach(snapshot => {
            if (snapshot.exists() || snapshot.ref.key.includes("-")) {
              return;
            }

            // The follower who doesn't have the post in his newsfeed.
            var capsule = {};
            capsule.followerUid = snapshot.ref.parent.key;

            // 21st century zero padedd dates have 8 digits, emember the pushId
            // contains the date at the end of the string
            capsule.pushId = snapshot.ref.key;
            capsule.uid = capsule.pushId.slice(0, -8);
            const date = capsule.pushId.slice(-8);
            capsule.date = {
              year: "y" + date.slice(0, -4),
              month: "m" + date.slice(0, -2).slice(-2),
              day: "d" + date.slice(-2),
            };

            // We need the capsules to have access to te uids, the pushId
            // and the dates after we have all the data.
            promises.push(database.ref(`/users/${capsule.uid}/username`).once("value"));
            promises.push(database.ref(`/users/${capsule.uid}/name/first`).once("value"));
            promises.push(database.ref(`/users/${capsule.uid}/profileImageUrl`).once("value"));
            promises.push(
              database
                .ref(`/veins/stylendar/${capsule.uid}/${capsule.date.year}/${capsule.date.month}/${capsule.date.day}`)
                .once("value"),
            );

            capsules.push(capsule);
          });

          return Promise.all(promises).then(snapshots => {
            // Finally wrap the missing post's data.
            let insertions = [];
            const length = capsules.length * 4;
            for (var i = 0; i < length; i += 4) {
              const capsule = capsules[i / 4];
              const username = snapshots[i].val();
              const name = snapshots[i + 1].val();
              const profileImageUrl = snapshots[i + 2].val();
              const imageUrl = snapshots[i + 3].val();

              if (!capsule || !username || !name || !profileImageUrl || !imageUrl) {
                continue;
              }

              // Aaand make the goddamn promise.
              const update = {
                uid: capsule.uid,
                imageUrl: imageUrl,
                date: utils.formatDate(capsule.date.year, capsule.date.month, capsule.date.day),
                createdAt: moment().format(),
                username: username,
                name: name,
                profileImageUrl: profileImageUrl,
              };
              const insertionPromise = database
                .ref(`/veins/newsfeed/${capsule.followerUid}/${capsule.pushId}`)
                .set(update);
              insertions.push(insertionPromise);
            }

            if (insertions.length) {
              return Promise.all(insertions).then(() => {
                res.status(200).send(`The cron job ran successfully, with ${insertions.length} fixes performed.`);
              });
            } else {
              res.status(200).send(`The cron job ran successfully and no operations were performed.`);
            }
          });
        });
      });
    })
    .catch(error => {
      console.trace(`cron:fixer:${__filename}: error occurred: ${error}, stack: ${error.stack}`);
      res.status(400).send(`Status 400. Error occurred.`);
    });
});

module.exports = newsfeed;
