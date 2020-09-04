const constants = {
  kSTInvitationURL: "https://mkwr8.app.goo.gl/CTXh",

  // All the available notifications types.
  kSTNotificationFollower: "follower",
  kSTNotificationFollowerRequest: "follower_request",
  kSTNotificationFollowerRequestAccepted: "follower_request_accepted",
  kSTNotificationReminder: "reminder",

  // Specific times used throughout the app.
  kSTNotificationReminderMorning: 8, // We're sending the stylendars morning reminders at 9
  kSTNotificationReminderEvening: 18, // We're sending the stylendars evening reminders at 18
};

module.exports = constants;
