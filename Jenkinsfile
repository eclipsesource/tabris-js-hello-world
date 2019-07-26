node('xcode10') {
    stage('info') {
        sh 'npm -version'
        sh 'node -v'
        sh 'tabris --version'
        sh 'xcodebuild -version'
        sh 'FASTLANE_DISABLE_COLORS=true LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 fastlane env'
        sh 'uname -a'
        sh 'ruby --version'
        sh 'java -version'
        sh '/usr/libexec/java_home -v 1.8'
        sh '/usr/libexec/java_home -v 9 || true'
    }
    stage('checkout') {
//        if(isScmConfigured()) {
//            checkout scm
//        } else {
//            git 'git@github.com:eclipsesource/tabris-js-hello-world.git'
//        }
        checkout scm
    }
    stage('npm') {
        sh 'npm install'
    }
    stage('fastlane') {
        withCredentials([
            string(credentialsId: 'FASTLANE_PASSWD', variable: 'FASTLANE_PASSWORD'),
            string(credentialsId: 'GITHUB_ECLIPSESOURCE_MATCH_CERTIFICATES_MATCH_PASS', variable: 'MATCH_PASSWORD'),
            string(credentialsId: 'ANKA_VM_PASSWD', variable: 'ANKA_VM_PASSWORD')
        ]) {
            sh 'echo ${FASTLANE_PASSWORD}'
            sh 'echo ${MATCH_PASSWORD}'
            sh 'echo ${ANKA_VM_PASSWORD}'
            sh 'security unlock-keychain -p ${ANKA_VM_PASSWORD} login.keychain'
            sh 'LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 FASTLANE_DISABLE_COLORS=true fastlane ios prepareProvisioning'
            sh 'security set-key-partition-list -S apple-tool:,apple: -s -k ${ANKA_VM_PASSWORD} login.keychain'
        }
    }
    stage('tabris build') {
        // sh 'echo ${TABRIS_BUILD_KEY}'
        sh 'tabris build ios --debug --device'
    }
    stage('archive ipa') {
        archive '**/*.ipa'
    }
}
