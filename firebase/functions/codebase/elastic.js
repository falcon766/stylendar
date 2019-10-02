const functions = require('firebase-functions');
const request = require('request-promise');

// Creates the entry in the elasticsearch when the user sign ups.
function create(uid, profile) {
	// console.log('elastic:create ', uid, profile);

	const elasticSearchConfig = functions.config().elasticsearch;
	const elasticSearchUrl = elasticSearchConfig.url + 'users/user/' + uid;

	const elasticSearchRequest = {
		method: 'POST',
		uri: elasticSearchUrl,
		auth: {
			username: elasticSearchConfig.username,
			password: elasticSearchConfig.password,
		},
		body: {
			name: profile.name.full,
			username: profile.username,
			profileImageUrl: profile.profileImageUrl
		},
		json: true
	};

	return request(elasticSearchRequest).then(response => {
		console.log('elastic:create: response is ', response);
	}).catch((error) => {
		console.log('elastic:create: the promises system failed with error: ', error);
	});
}

// Updates the entry in the elasticsearch when the user edits either his name or username.
function update(uid, keys, values) {
	// console.log('elastic:update ', uid);

	const elasticSearchConfig = functions.config().elasticsearch;
	const elasticSearchUrl = elasticSearchConfig.url + 'users/user/' + uid + '/_update';

	// We only need the full name, not the whole nested `name` object.
	var doc = {};
	for (var i = 0; i < keys.length; ++i) {
		const key = keys[i];
		if (key != 'name') {
			doc[key] = values[i];
		} else {
			doc[key] = values[i].full;
		}
	}

	const elasticSearchRequest = {
		method: 'POST',
		uri: elasticSearchUrl,
		auth: {
			username: elasticSearchConfig.username,
			password: elasticSearchConfig.password,
		},
		body: {
			doc: doc
		},
		json: true
	};

	return request(elasticSearchRequest).then(response => {
		console.log('elastic:update: response is ', response);
	}).catch((error) => {
		console.log('elastic:update: the promises system failed with error: ', error);
	});
}

// Removes the entry in the elasticsearch when the user account is deleted.
function remove(uid) {
	// console.log('elastic:remove ', uid);

	const elasticSearchConfig = functions.config().elasticsearch;
	const elasticSearchUrl = elasticSearchConfig.url + 'users/user/' + uid;

	var elasticSearchRequest = {
		method: 'DELETE',
		uri: elasticSearchUrl,
		auth: {
			username: elasticSearchConfig.username,
			password: elasticSearchConfig.password,
		},
		json: true
	};

	return request(elasticSearchRequest).then(response => {
		console.log('elastic:remove: response is ', response);
	}).catch((error) => {
		console.log('elastic:remove: the promises system failed with error: ', error);
	});
}

module.exports = { create, update, remove };
