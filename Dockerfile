FROM openjdk:8u151-jdk

RUN apt-get -qq update \
    && apt-get -qq -y install \
    unzip \
    git

# install the Android SDK
ENV ANDROID_HOME /var/android_home
ADD https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip .
RUN unzip sdk-tools-linux-3859397.zip -d ${ANDROID_HOME} \
    && rm sdk-tools-linux-3859397.zip \
    && yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# https://developer.android.com/studio/command-line/sdkmanager.html
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-26"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;26.0.2"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;google;m2repository"

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# install Tabris CLI and dependencies
RUN npm install -g cordova@6.5.0
RUN npm install -g tabris-cli@^2.2.0
RUN npm install typescript -g

# install Gradle
ENV GRADLE_VERSION 3.5
ENV GRADLE_HOME /var/gradle-${GRADLE_VERSION}
ADD https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip .
RUN unzip gradle-${GRADLE_VERSION}-bin.zip -d /var && rm gradle-${GRADLE_VERSION}-bin.zip
RUN ln -s /var/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/

WORKDIR /workspace
VOLUME ["/workspace"]
