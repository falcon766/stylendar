'use strict';

 // We only initialize the app here because the modules are cached. So, when we'll do `require('firebase-admin')` somewhere else,
 // the Firebase app is already initalized.
const functions = require('firebase-functions');
const firebaseadmin = require('firebase-admin');
firebaseadmin.initializeApp(functions.config().firebase);


// App related functions.
const app = require('./app');

// Admin related functions.
const admin = require('./admin');

// Cool crons
const cron = require('./cron');

module.exports = { app, admin, cron };
