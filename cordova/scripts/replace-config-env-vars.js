module.exports = function(context) {

  const fs = require('fs');
  const plist = require('plist');
  const cordova_util = context.requireCordovaModule('cordova-lib/src/cordova/util');

  let projectRoot = cordova_util.isCordova();
  let configXML = cordova_util.projectConfig(projectRoot);
  let data = fs.readFileSync(configXML, 'utf8');
  for (var envVar in process.env) {
    data = data.replace('$' + envVar, process.env[envVar]);
  }
  fs.writeFileSync(configXML, data, 'utf8');

	const plistPath = 'res/Settings.bundle/Root.plist';
	console.log(`Reading plist file from ${plistPath}`);
	if (fs.existsSync(plistPath)) {
		let plistData = fs.readFileSync(plistPath, 'utf8');
		console.log('Plist file read successfully.');

		let plistObj;
		try {
			plistObj = plist.parse(plistData);
			console.log('Plist file parsed successfully.');
		} catch (err) {
			console.error('Error parsing plist data:', err);
			return;
		}

		let buildNumberReplaced = false;
		plistObj.PreferenceSpecifiers.forEach(specifier => {
            console.log(`Specifier: ${JSON.stringify(specifier)}`);
			if (specifier.Title === '$BUILD_NUMBER') {
                specifier.Title = `Build number: ${process.env.BUILD_NUMBER}`;
				console.log(`Replaced $BUILD_NUMBER with ${specifier.Title}`);
				buildNumberReplaced = true;
			}
		});

		if (buildNumberReplaced) {
			fs.writeFileSync(plistPath, plist.build(plistObj), 'utf8');
			console.log('Plist file written successfully.');
		} else {
			console.warn('$BUILD_NUMBER was not found in plist file.');
		}
	} else {
		console.warn(`Plist file does not exist at ${plistPath}`);
	}
};
