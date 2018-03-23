pipeline {
    // Choose a name (or label) of the node you want to use for building
    // the app, here we use "mac-tabris-2.4.0-g"
    agent {
        node {
            label 'mac-tabris-2.4.0-yubikey-01'
        }
    }
    // Set environment variables required by fastlane
    environment {
        LANG = "en_US.UTF-8"
        LC_ALL = 'en_US.UTF-8'
        FASTLANE_DISABLE_COLORS = 'true'
        FASTLANE_SKIP_UPDATE_CHECK = 'true'
    }
    stages {
        // This stage theoretically should not be required, especially when
        // we have "post cleanup" phase. However if anything in this job
        // will fail "post cleanup" stage will not be executed.
        //
        // That's why if you decide to have clean environment on each build,
        // you should also check if it's clean before starting the job.
        //
        // We use "|| true" in case if any of those command fail. For
        // example, there might be no files in root directory, or keychain
        // might not exist. "rm" and "security" will return non zero code
        // than, however goal (clean environment) is achieved, so we just
        // append "|| true" to do not break whole job.
        stage('pre cleanup') {
            steps {
                sh 'rm -Rf * || true'
                sh 'rm -Rf .* || true'
                sh 'security delete-keychain ios-build.keychain || true'
                sh 'rm -Rf ~/Library/MobileDevice/Provisioning\\ Profiles/* || true'
            }
        }
        // Print versions of the tools used in this job, it will also check if
        // tools are available (installed correctly).
        stage('info') {
            steps {
                sh 'uname -a'
                sh 'node -v'
                sh 'npm -version'
                sh 'tabris --version'
                sh 'ruby --version'
                sh 'fastlane env'
                sh 'xcodebuild -version'
            }
        }
        // Create new keychain called "ios-build.keychain", which will hold
        // credentials for signing the binary.
        stage('create keychain') {
            steps {
                withCredentials([
                    string(credentialsId: 'MATCH_PASSWD', variable: 'MATCH_PASSWORD'),
                ]) {
                    // create new keychain with password "foobar"
                    sh 'security create-keychain -p foobar ios-build.keychain'
                    // unlock the keychain
                    sh 'security unlock-keychain -p foobar ios-build.keychain'
                    // add the keychain to search list (so that xcode will be able
                    // to find it when searching for credentials)
                    sh 'security list-keychains -s ios-build.keychain'
                    // keep keychain unlocked for 1 hour
                    sh 'security set-keychain-settings -u -t 3600 ios-build.keychain'
                    // print keychain info - only to validate it
                    sh 'security show-keychain ios-build.keychain'
                    // fetch certificates and private key for signing, configure
                    // acl, add to keychain, fetch provisioning profile and store
                    sh 'fastlane match development \
                            --app_identifier com.eclipsesource.hello.world \
                            --keychain_name ios-build.keychain \
                            --keychain_password foobar \
                            --readonly'
                }
            }
        }
        // Checkout source code
        stage('checkout') {
            steps {
                // instead of cloning from URL like:
                // "git 'git@github.com:eclipsesource/hello-world-app.git'"
                // we can use a "shorthand" to checkout same revision of same
                // repository where this Jenkinsfile was taken from
                checkout scm
            }
        }
        // Install application dependencies
        stage('dependencies') {
            steps {
                sh 'npm install'
                // Check if there is only one YubiKey plugged in
                sh '[[ $(ykman list | wc -l) -eq 1 ]]'
                // Check if the YubiKey SN equals 4132277
                sh '[[ $(ykman list | grep "Serial: 4132277" | wc -l) -eq 1 ]]'
            }
        }
        // Build
        stage('build') {
            steps {
                sh 'tabris build ios --debug --device'
            }
        }
        // Archive artifacts
        stage('archive') {
            steps {
                // tar dSYM file while directories cannot be archived
                sh 'tar -C build/cordova/platforms/ios/build/device/ -cf Hello_World.app.dSYM.tar Hello\\ World.app.dSYM'
                // archive "ipa" and dSYM tar files as artifacts of this job
                archive '**/*.ipa,**/*.dSYM.tar'
            }
        }
        // Cleanup workspace
        stage('post cleanup') {
            steps {
                // remove all files in worlspace folder
                sh 'rm -Rf *'
                sh 'rm -Rf .* || true'
                sh 'rm -Rf /tmp/custom-tabris-platform'
                // delete keychain with signing credentials
                sh 'security delete-keychain ios-build.keychain'
                // delete provisioning profiles
                sh 'rm -Rf ~/Library/MobileDevice/Provisioning\\ Profiles/*'
            }
        }
    }
}