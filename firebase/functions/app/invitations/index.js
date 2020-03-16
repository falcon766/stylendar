'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const database = admin.database();
const _ = require('lodash');

const constants = require('../../codebase/constants');
const strings = require('../../codebase/strings');

const nodemailer = require('nodemailer');

// Configure the email transport using the default SMTP transport and a GMail account.
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
//
// Observation: the gmail.email and gmail.password are environment variables set with the Firebase CLI.
const gmailEmail = encodeURIComponent(functions.config().gmail.email);
const gmailPassword = encodeURIComponent(functions.config().gmail.password);
const mailTransport = nodemailer.createTransport(`smtps://${gmailEmail}:${gmailPassword}@smtp.gmail.com`);

// Sends an email invitation when the data is changed in the Realtime database.
const invitations = functions.database.ref('/invitations/{uid}/deliver').onWrite((change, context) => {

	// If the "deliver" was set on "false", we don't wish to send any email. This might occur either when the account is barely created or when
	// someone changes the value by mistake on the Realtime Database.
	const deliver = change.after.val();
	if (deliver == false) { return; }


	//  However, if the "deliver" is set to "true", we send the invitation email by also catching any error might appear.
	const uid = context.params.uid;
	return database.ref(`/invitations/${uid}`).once('value').then(snapshot => {
		const invitee = snapshot.val();
		return sendInvitationEmail(invitee.email, invitee.name.full);
	})
	.catch(error => {
		console.log(`invitations:${__filename}: the promises system failed with the following error: `, error);
	});
});

// Sends the email to the user using nodemailer.
function sendInvitationEmail(email, name) {
	var options = {
		from: '"Stylendar" <razvanbirgaoanu10@gmail.com>',
		to: email
	};

	// Creates the email itself.
	var text = strings.invitationEmailContent;
	text= text.replace('%@', name);
	text = text.replace('%@@', constants.kSTInvitationURL);
	_.merge(options, {
		subject: strings.invitationEmailSubject,
		text: text
	});

	return mailTransport.sendMail(options).then(() => {
		console.log(`invitations:${__filename}: new invitation email sent to:`, email);
	});
}

module.exports = invitations;
