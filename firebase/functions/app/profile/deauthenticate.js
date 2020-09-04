"use strict";

const admin = require("firebase-admin");

function deauthenticate(uid) {
  return admin
    .auth()
    .deleteUser(uid)
    .then(() => {
      console.log(`profile:__filename: successfully removed deauthenticated user`);
    })
    .catch(error => {
      console.log(
        `profile:${__filename}: this might not be an actual error, because the admin auth interface doesn\'t have any checkUser() method, so the deleteUser() is always executed`,
        error,
      );
    });
}

module.exports = deauthenticate;
