module.exports = function(context) {

  const fs = require('fs');
  const cordova_util = context.requireCordovaModule('cordova-lib/src/cordova/util');

  let projectRoot = cordova_util.isCordova();
  let configXML = cordova_util.projectConfig(projectRoot);
  let data = fs.readFileSync(configXML, 'utf8');
  for (var envVar in process.env) {
    data = data.replace('$' + envVar, process.env[envVar]);
  }
  fs.writeFileSync(configXML, data, 'utf8');
};
