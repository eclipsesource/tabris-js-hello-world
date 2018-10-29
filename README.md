[![Build Status](https://travis-ci.org/eclipsesource/tabris-js-hello-world.svg?branch=experimental)](https://travis-ci.org/eclipsesource/tabris-js-hello-world)

# Hello World example for Tabris.js

This is a simple Hello World app written in [Tabris.js](https:tabrisjs.com).
Its main purpose is to illustrate the different ways to build a Tabris.js app.

## Tabris.js Build Service

The easist way to build a Tabris.js app is to place it in a public GitHub repository and then use the build service available on https://tabrisjs.com

## Android Build on Travis

This project is built on [Travis CI](https://travis-ci.org/eclipsesource/tabris-js-hello-world/builds). The [.travis.yml](.travis.yml) defines what happens during that build. You can use the file as a template to build your own Tabris.js apps on Travis. Just place a copy of the `.travis.yml` in the root folder of your own Tabris.js project.

## Android Build with Docker

This project contains a [Dockerfile](Dockerfile) that describes an Android build environment. If you have Docker installed you can create an Android `.apk` file for this Hello World app without installing an Android SDK. This makes it very convenient to perform builds on your development machine or in a CI system. Just follow these two steps:

1. create the Docker image
1. start a build (using that image)

### Create Docker Image

Create the `tabris-js-build-android` Docker image:

```shell
docker build . --tag tabris-js-build-android:latest
```

### Build in Docker Container

Build the Hello World app in a Docker container created from the `tabris-js-build-android` Docker image:

```shell
cd tabris-js-hello-world
docker run --rm -v $(pwd):/workspace -e BUILD_NUMBER=4 -e TABRIS_BUILD_KEY=<my-build-key> tabris-js-build-android tabris build android
```

The `TABRIS_BUILD_KEY` holds your build key available from https://tabrisjs.com/settings/account.

### Interactive Build in Docker Container

Run an interactive `tabris-js-build-android` container with mounted `workspace`:

```shell
cd tabris-js-hello-world
docker run -it --rm -v $(pwd):/workspace tabris-js-build-android /bin/bash

```

Within the container prepare and build `tabris-js-hello-world` app with:

```shell
$ npm install
$ BUILD_NUMBER=4 tabris build android
...
BUILD SUCCESSFUL

Total time: 52.348 secs
Built the following apk(s):
    /workspace/build/cordova/platforms/android/build/outputs/apk/android-debug.apk
```

If you want to sign your app with the same key in each build (e.g. when using Google Maps) you can use `--cordova-build-config`. (This parameter has been itroduced to Tabris CLI with version `0.6.0`)

```shell
tabris build android --debug --cordova-build-config=cordovaBuildConfig.json
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
