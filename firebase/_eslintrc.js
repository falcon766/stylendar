module.exports = {
    "env": {
        "node": true,
        "es6": true
    },
    "extends": "eslint:recommended",
    "parserOptions": {
        "sourceType": "module"
    },
    "rules": {
        "indent": [
            "error",
            "tab"
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
						"single", {
							avoidEscape: true,
							allowTemplateLiterals: true
						}
        ],
        "semi": [
            "error",
            "always"
        ],
		    "no-console": 0,
    }
};
