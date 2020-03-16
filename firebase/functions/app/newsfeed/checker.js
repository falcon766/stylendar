'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();

const _ = require('lodash');
const moment = require('moment');

const strings = require('../../codebase/strings');
const utils = require('../../codebase/utils');

const checker = functions.https.onRequest((req, res) => {
	if (!req.query || utils.verifyKey(req.query.key) === false) {
		res.status(403).send(strings.keyInvalidMessage);
		return;
	}
	var output = '';
});

module.exports = checker;
