[![Build Status](https://travis-ci.org/eclipsesource/tabris-js-hello-world.svg?branch=master)](https://travis-ci.org/eclipsesource/tabris-js-hello-world)

# Hello World example for Tabris.js

## Build with Docker

Create the `tabris-cli` Docker image:

```sh
$ docker build . -t tabris-cli
```

Run a `tabris-cli` container with mounted `workspace`:

```sh
$ cd tabris-js-hello-world
$ docker run -it --rm -v "$PWD":/workspace tabris-cli /bin/bash
```

Within the container prepare and build `tabris-js-hello-world` app with:

```
# npm install
# BUILD_NUMBER=4 tabris build android
...
BUILD SUCCESSFUL

Total time: 9 mins 9.869 secs
Built the following apk(s):
	/workspace/build/cordova/platforms/android/build/outputs/apk/android-debug.apk
```

If you want to sign your app with the same key (e.g. when using Google Maps) you can use a `buildConfig.json`:

```
# npm install
# BUILD_NUMBER=4 tabris build android --debug -- --verbose --device --buildConfig=buildConfig.json
```
