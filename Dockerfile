#FROM openjdk:8u131-jdk-alpine
FROM openjdk:8u131-jdk

# we need unzip, git, node and npm
#RUN apk --update add unzip && rm -rf /var/lib/apt/lists/* && rm /var/cache/apk/*
#RUN apk --update add git && rm -rf /var/lib/apt/lists/* && rm /var/cache/apk/*
#RUN apk --update add nodejs nodejs-npm && rm -rf /var/lib/apt/lists/* && rm /var/cache/apk/*

RUN apt-get update
RUN apt-get install unzip
RUN apt-get install git

# install the Android SDK
ENV ANDROID_HOME /var/android_home
ADD https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip .
RUN unzip sdk-tools-linux-3859397.zip -d ${ANDROID_HOME} && rm sdk-tools-linux-3859397.zip
RUN mkdir -p "${ANDROID_HOME}/licenses"
RUN echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"

# https://developer.android.com/studio/command-line/sdkmanager.html
#    - platform-tools
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools"
#    - android-25
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-25"
#    - build-tools-25.0.2
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;25.0.2"
#    - extra-android-m2repository
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository"
#    - extra-google-m2repository
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;google;m2repository"

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# install Tabris CLI and dependencies
RUN npm install -g cordova@6.5.0
RUN npm install -g tabris-cli@0.4.0
RUN npm install typescript -g

ENV TABRIS_VERSION 2.0.0-rc1
ADD https://tabrisjs.com/downloads/${TABRIS_VERSION}/platforms/tabris-android.zip .
RUN unzip tabris-android.zip && rm tabris-android.zip
ENV TABRIS_ANDROID_PLATFORM=/tabris-android

# install Gradle
ENV GRADLE_VERSION 3.5
ENV GRADLE_HOME /var/gradle-${GRADLE_VERSION}
ADD https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip .
RUN unzip gradle-${GRADLE_VERSION}-bin.zip -d /var && rm gradle-${GRADLE_VERSION}-bin.zip
RUN ln -s /var/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/

WORKDIR /workspace
VOLUME ["/workspace"]
