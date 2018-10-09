[![Build Status](https://travis-ci.org/eclipsesource/tabris-js-hello-world.svg?branch=master)](https://travis-ci.org/eclipsesource/tabris-js-hello-world)

# Hello World example for Tabris.js

## Run

In the project directory, run the [Tabris CLI](https://www.npmjs.com/package/tabris-cli) command:

```
tabris serve
```

This will start a JavaScript app code server at a free port and print its URL to the console.

The JavaScript app code can be [side-loaded](https://tabrisjs.com/documentation/2.0/developer-app.html#the-developer-console) in the [developer app](https://tabrisjs.com/documentation/2.0/developer-app.html) if the default config.xml was not changed. Otherwise, the JavaScript app code must be side-loaded in a [debug build](https://tabrisjs.com/documentation/2.0/build.html#building-a-tabrisjs-app) of this app.

## Build

The app can be built using the online build service at [tabrisjs.com](https://tabrisjs.com) or locally using [Tabris.js CLI](https://www.npmjs.com/package/tabris-cli).

See [Building a Tabris.js App](https://tabrisjs.com/documentation/2.0/build.html) for more information.

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

```sh
$ npm install
$ BUILD_NUMBER=4 tabris build android

...
BUILD SUCCESSFUL

Total time: 52.348 secs
Built the following apk(s):
	/workspace/build/cordova/platforms/android/build/outputs/apk/android-debug.apk
```

## Build with custom code signing key

If you want to sign your app with the same key in each build (e.g. when using Google Maps) you can use `--cordova-build-config`.
(This parameter has been itroduced to Tabris CLI with version `0.6.0`)

```sh
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
