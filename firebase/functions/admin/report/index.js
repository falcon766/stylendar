"use strict";

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const database = admin.database();
const _ = require("lodash");

const strings = require("../../codebase/strings");
const utils = require("../../codebase/utils");

const nodemailer = require("nodemailer");

// Configure the email transport using the default SMTP transport and a GMail account.
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
//
// Observation: the gmail.email and gmail.password are environment variables set with the Firebase CLI.
const adminRecipients = ["hello@paulrberg.com@gmail.com, mdfleming@gmail.com"];
const gmailEmail = encodeURIComponent(functions.config().gmail.email);
const gmailPassword = encodeURIComponent(functions.config().gmail.password);
const mailTransport = nodemailer.createTransport(`smtps://${gmailEmail}:${gmailPassword}@smtp.gmail.com`);

// Sends an email invitation when a report is is changed in the Realtime database.
const report = functions.database.ref("/admin/report/{pushId}").onCreate((snapshot, context) => {
  if (!snapshot.val()) {
    return false;
  }
  const report = snapshot.val();
  const uid = report.user.uid;

  // Let's get the user's profile, the stylendar and then send the email.
  const profilePromise = database.ref(`/users/${uid}`).once("value");
  const stylendarPromise = database.ref(`/veins/stylendar/${uid}`).once("value");
  return Promise.all([profilePromise, stylendarPromise])
    .then(snapshots => {
      if (!snapshots[0].exists()) {
        console.log(`admin:report:${__filename}: the user\'s profile was not found`);
        return true;
      }
      const user = snapshots[0].val();
      user.stylendar = snapshots[1].val();
      _.merge(report.user, user);

      return sendReportEmail(report);
    })
    .catch(error => {
      console.log(`admin:report:${__filename} the promises system failed with the following error: `, error);
    });
});

module.exports = { report };

// Sends the email to the user using nodemailer.
function sendReportEmail(report) {
  var options = {
    from: '"Stylendar" <razvanbirgaoanu10@gmail.com>',
    to: adminRecipients,
  };

  // Creates the email itself
  var text = `Things are getting tensioning between Stylendar users. The account having the id \'${report.senderUid}\' has submitted a report.\n\n`;

  // The Reason
  text += "Reason\n";
  text += report.reason + "\n\n";

  // The Profile
  text += "Reported User\n";
  text += "• Id: " + report.user.uid + "\n";
  text += "• Name: " + report.user.name.full + "\n";
  text += "• Username: " + report.user.username + "\n";
  text += "• Profile Image: " + report.user.profileImageUrl + "\n\n";

  // The Stylendar
  if (report.user.stylendar) {
    text += "Stylendar\n";

    // Depth-first search
    const stylendar = report.user.stylendar;
    Object.keys(stylendar).forEach(year => {
      const yearObj = stylendar[year];
      Object.keys(yearObj).forEach(month => {
        const monthObj = yearObj[month];
        Object.keys(monthObj).forEach(day => {
          // We also wish to pad-zero the days and the month if they are lower than 0, so that the dates will be string-sortable when they are retrieved.
          const date = utils.formatDate(year, month, day);
          const imageUrl = monthObj[day];
          text += `• ${date}: ${imageUrl}\n`;
        });
      });
    });
    text += "\n";
  }

  text +=
    "Kill this reported user with fire to by tapping the link below. Be careful though, with power comes reponsibility!\n";
  text += `https://us-central1-stylendar-bfe97.cloudfunctions.net/remove-user?uid=${report.user.uid}\n`;

  _.merge(options, {
    subject: strings.reportEmailSubject,
    text: text,
  });
  return mailTransport.sendMail(options).then(() => {
    console.log(`admin:report:${__filename} New report email sent to:`, adminRecipients);
  });
}

module.exports = report;
