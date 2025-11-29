# Let's started

1. Clone the repo.
2. Run flutter pub get
3. Open simulator
4. Run `futter run` or open `[Run and Debug] from left menu`
```
Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision dec2ee5c1f (4 days ago) • 2024-11-13 11:13:06 -0800
Engine • revision a18df97ca5
Tools • Dart 3.5.4 • DevTools 2.37.3
```
# firebase tool
 ```                                                    │
   │                Update available 13.25.0 → 13.27.0                 │
   │          To update to the latest version using npm, run           │
   │                   npm install -g firebase-tools                   |
```
   
## Add a new pacakge
1. Add the package in pubspec.yaml file
2. Run `flutter pub get

## Conflict in pckage
1. `flutter clean` or `flutter pub cache repair`
2. `flutter pub get`

## Add a new word to dicionaries
1. Open `/lib/l10n/intl_ar.arb` and `/lib/l10n/intl_en.arb`
2. Add the new word with translation
3. Run `dart run intl_utiles:generate` or `flutter pub run intl_utils:generate`

## Install and run the FlutterFire CLI
- From any directory, run this command: `dart pub global activate flutterfire_cli`

- Then, at the root of your Flutter project directory, run this command: `flutterfire configure --project=groomly-e3370`


## If needed, run pod install with Rosetta (Apple M1) if you use windows skipe step 1:
1. `arch -x86_64 /usr/bin/env bash`
2. `cd ios`
3. `pod install`
4. flutter run or through debug butotn in left menu vscode

## Clean the Project (if issues persist)
### `Sometimes, you might need to clear out old cached data and pods:
1. `flutter clean`
2. `rm -rf ios/Pods` or `rm -rf Pods`
3. `rm ios/Podfile.lock` or `rm Podfile.lock`
4. `arch -x86_64 /usr/bin/env bash` (M1)
4. `cd ios`
5. `pod install` or `arch -x86_64 pod install`

# Run the following command to create a release build for iOS:
`flutter build ios --release`

# Change icon 
1. `flutter pub add flutter_launcher_icons`
2. `dart run flutter_luncher_icons`

# Release iOS version through testFlight app
1. open xCode -> Product(tab) -> Archive (buildin g ...)
2. open organizr (open default)
3. Distribute App (testFlight or direct to apple store)
4. contine woth apple.developer

# Release Android version 
- JAVA VERSSION 17.0.13  
gradle.properties file should contains
`org.gradle.java.home=/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home`
- gradle verssion 8.0
gradle-wrapper.properties file
`distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-bin.zip`
- `flutter clean`
- `cd android`
- `./gradlew clean`
- `./gradlew --stop`
- `./gradlew build`
- or `./gradlew clean build`
- `./gradlew -v`

- [optiona] `./gradlew wrapper --gradle-version 8.0`
- `./gradlew build`
- [optiona] `flutter doctor --verbose` Ensure Flutter is using the same Java version
- `flutter build apk --release` or `flutter build apk --debug`
- `flutter build appbundle --release`
# Publish to Google play we need 
1. ### Generate a Keystore 
 `keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias keyAlias`
2. ### Update build.gradle with your keystore details: In android/app/build.gradle, add:
```
android {
    ...
    signingConfigs {
        release {
            keyAlias 'keyAlias'
            keyPassword 'your_key_password'
            storeFile file('/path/to/your/my-release-key.jks')
            storePassword 'your_store_password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}

```
- Generating a keystore is necessary for creating a signed APK, which is required for publishing your app on the Google Play Store or distributing it securely. Here’s a breakdown of why and when you need a keystore:

# Cloud Funciton 
- node 18.19.1
- npm 8.19.4
- Ensure everything works locally before deploying: `firebase emulators:start`
- check logs details  `firebase functions:log`
- `firebase deploy --only functions`


# Add version
You can use the version package to manage versions automatically:
- `flutter pub add version`

- `flutter pub run version:increment --build`

- steps to increase build
   - `flutter clean`
   - `flutter pub get`
   - `arch -x86_64 pod install`
   - reopen xcode - write there in console versiona and build
   - pubspec.yaml
   - build.gradle
   ```
    versionCode 54
    versionName "5.2.34"
   ```
   - AppFrameworkInfo.plist
   ```
    <key>CFBundleShortVersionString</key>
    <string>5.2.34</string>
    <key>CFBundleVersion</key>
    <string>54.0</string>
   ```

# steps to rebuild android
-   export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    export PATH=$JAVA_HOME/bin:$PATH
-   rm -rf ~/.gradle/caches
    rm -rf ~/.gradle/kotlin-dsl
    rm -rf ~/.gradle/daemon
    rm -rf ~/.gradle/native
-   rm -rf android/.gradle
-   flutter clean
-   flutter pub get
-   ./gradlew clean
-   flutter build appbundle --release


# IF Sundenlly the compiler ot flutter stopping to work
- open flutter folder `ahmadsabbah/dev/flutter` in terminal
- `git status`
- `git reset --hard or git stash(if you want the changes)`

# How to run as production
- Open Xcode -> Product -> Scheme -> Edit Schema
- In Run (Menu) -> Info (tab) -> Set Build Configuration Release
