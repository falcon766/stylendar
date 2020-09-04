"use strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const database = admin.database();

const strings = require("../../codebase/strings");
const utils = require("../../codebase/utils");

// This function doesn't listen to database changes, it's simply activated by a browser request or a cron.
const follow = functions.https.onRequest((req, res) => {
  if (!req.query || utils.verifyKey(req.query.key) === false) {
    res.status(403).send(strings.keyInvalidMessage);
    return;
  }

  // We verify if the follow system works properly by wiping out cases such as when
  // a follow edge is only halfway through AKA when the entry is in the 'followers'
  // container but not in the 'following' or vice versa.
  const followingPromise = database.ref("/veins/following").once("value");
  const followersPromise = database.ref("/veins/followers").once("value");

  Promise.all([followingPromise, followersPromise])
    .then(snapshots => {
      let promises = [],
        deletes = [];
      var followingPairsKeys = [],
        followerPairsKeys = [];

      snapshots[0].forEach(child => {
        const following = child.val();
        var followingFrequency = {};

        Object.keys(following).forEach(key => {
          const user = following[key];
          if (!user || !user.uid) {
            return;
          }

          // Because of many reasons, the entry might exist already, so we smartly accommodate the case.
          if (!followingFrequency[user.uid]) {
            followingFrequency[user.uid] = true;
            followingPairsKeys.push({
              uid: child.key,
              pushId: key,
            });
            promises.push(
              database.ref(`/veins/followers/${user.uid}`).orderByChild("uid").equalTo(`${child.key}`).once("value"),
            );
          } else {
            const update = { [key]: null };
            deletes.push(database.ref(`/veins/following/${child.key}`).update(update));
          }
        });
      });

      // followers
      snapshots[1].forEach(child => {
        const follower = child.val();
        var followersFrequency = {};

        Object.keys(follower).forEach(key => {
          const user = follower[key];
          if (!user || !user.uid) {
            return;
          }

          // Because of many reasons, the entry might exist already, so we smartly accommodate this case.
          if (!followersFrequency[user.uid]) {
            followersFrequency[user.uid] = true;
            followerPairsKeys.push({
              uid: child.key,
              pushId: key,
            });
            promises.push(
              database.ref(`/veins/following/${user.uid}`).orderByChild("uid").equalTo(`${child.key}`).once("value"),
            );
          } else {
            const update = { [key]: null };
            deletes.push(database.ref(`/veins/followers/${child.key}`).update(update));
          }
        });
      });

      return Promise.all(promises).then(snapshots => {
        // following pairs checkers
        const followingPairsLength = followingPairsKeys.length;
        for (var i = 0; i < followingPairsLength; ++i) {
          const val = snapshots[i].val();
          // let's delete the entry if it's flawed
          if (!val) {
            const pair = followingPairsKeys[i];
            deletes.push(
              database.ref(`/veins/following/${pair.uid}`).update({
                [pair.pushId]: null,
              }),
            );
          }
        }

        // followers pairs checkers
        const followerPairsLength = followerPairsKeys.length;
        const totalLength = followingPairsLength + followerPairsLength;
        for (var j = followingPairsLength; j < totalLength; ++j) {
          const val = snapshots[j].val();
          const index = j - followerPairsLength;
          // let's delete the entry if it's flawed
          if (!val) {
            const pair = followerPairsKeys[index];
            deletes.push(
              database.ref(`/veins/followers/${pair.uid}`).update({
                [pair.pushId]: null,
              }),
            );
          }
        }

        if (deletes.length) {
          return Promise.all(deletes).then(() => {
            res.status(200).send(`The cron job ran successfully, with ${deletes.length} fixes performed.`);
          });
        } else {
          res.status(200).send(`The cron job ran successfully and no operations were performed.`);
        }
        return;
      });
    })
    .catch(error => {
      console.trace(`cron:fixer:${__filename}: error occurred: ${error}, stack: ${error.stack}`);
      res.status(400).send(`Status 400. Error occurred.`);
      return;
    });
});

module.exports = follow;
