FROM openjdk:8u222-jdk

RUN apt-get -qq update \
   && apt-get -qq -y install \
   unzip \
   git

# install the Android SDK
ENV ANDROID_HOME /usr/local/share/android-sdk
ENV SDK_TOOLS_ARCHIVE sdk-tools-linux-4333796.zip
RUN curl -L https://dl.google.com/android/repository/${SDK_TOOLS_ARCHIVE} -o ${SDK_TOOLS_ARCHIVE} \
  && unzip ${SDK_TOOLS_ARCHIVE} -d ${ANDROID_HOME} \
  && rm ${SDK_TOOLS_ARCHIVE} \
  && yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# https://developer.android.com/studio/command-line/sdkmanager.html
# the following lines correspond to the section "android.components" in the .travis.yml
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --install "platform-tools"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --install "build-tools;28.0.3"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --install "platforms;android-27"

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -L https://deb.nodesource.com/setup_8.x | bash - && apt-get -qq -y install nodejs

# install Gradle
ENV GRADLE_VERSION 4.1
ENV GRADLE_HOME /usr/local/share/gradle-${GRADLE_VERSION}
RUN curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-${GRADLE_VERSION}-bin.zip \
  && unzip gradle-${GRADLE_VERSION}-bin.zip -d /usr/local/share \
  && rm gradle-${GRADLE_VERSION}-bin.zip \
  && ln -s /usr/local/share/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin/

# install Tabris CLI and dependencies
RUN npm install -g tabris-cli@3.2.0

# opt-out of Cordova usage statistics
ENV CI true

WORKDIR /workspace
VOLUME ["/workspace"]
