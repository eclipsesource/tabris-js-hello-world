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

Total time: 52.348 secs
Built the following apk(s):
	/workspace/build/cordova/platforms/android/build/outputs/apk/android-debug.apk
```

If you want to sign your app with the same key in each build (e.g. when using Google Maps) you can use `--cordova-build-config`. (This parameter has been itroduced to Tabris CLI with version `0.6.0`)

```shell
$ tabris build android --debug --cordova-build-config=cordovaBuildConfig.json
```

The following `cordovaBuildConfig.json` contains the signing details for a debug build:

```json
{
  "android": {
    "debug": {
      "keystore": "../signing/debug.keystore",
      "storePassword": "android",
      "alias": "androiddebugkey",
      "password" : "android"
    }
  }
}
```
