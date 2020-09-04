'use strict';

const gcloud = require('google-cloud');
const storage = gcloud.storage({
	projectId: 'stylendar-bfe97',
	keyFilename: 'service-account-credentials.json',
});
const bucket = storage.bucket('stylendar-bfe97.appspot.com');

// Sugar function to delete all the stored files for a given user.
function remove(uid) {
	var promises = [];
	// We have basically two folders to destroy: the profile/${uid} and the newsfeed{$uid}

	console.log(storage);
	console.log(bucket);

	return true;
	const profileBucket = gcs.bucket(`/profile`);
	const profilePromise = profileBucket.file(`${uid}.jpg`).delete();
	promises.push(profilePromise);

	// Stylendar
	// const stylendarBucket = gcs.bucket(`/stylendar`);
	// const stylendarPromise = stylendarBucket.deleteFiles({prefix: `${uid}`});
	// promises.push(stylendarPromise);

	// Fire the promises otherwise.
	return Promise.all(promises).catch((error) => {
		console.log(`${__filename}: the promises system failed with the following error`, error);
	});
}

module.exports = { remove };
