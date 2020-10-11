![](https://i.imgur.com/wi7RlVt.png)

<p align="center">
<a target="new" href="https://play.google.com/store/apps/details?id=chat.fluffy.fluffychat">
  <img height="66px" src="https://christianpauly.gitlab.io/fluffychat-website/assets/images/google-play-badge.png" />
  </a>
  <a target="new" href="https://fluffychat.im/en/fdroid.html">
  <img height="66px" src="https://christianpauly.gitlab.io/fluffychat-website/assets/images/fdroid_button.png " />
  </a>
  <br>
  <a href="https://web.fluffychat.im" target="new">Open FluffyChat in the browser</a> - <a href="https://matrix.to/#/#fluffychat:matrix.org" target="new">Join the community</a> - <a href="https://metalhead.club/@krille" target="new">Follow me on Mastodon</a> - <a href="https://hosted.weblate.org/projects/fluffychat/" target="new">Translate FluffyChat</a> - <a href="https://gitlab.com/ChristianPauly/fluffychat-website" target="new">Translate the website</a> - <a href="https://christianpauly.gitlab.io/fluffychat-website/faq.html" target="new">FAQ</a> - <a href="https://christianpauly.gitlab.io/fluffychat-website/" target="new">Website</a> - <a href="https://gitlab.com/ChristianPauly/fluffychat-flutter/-/jobs/artifacts/main/browse?job=build_android_apk" target="new">Download latest APK</a> - <a href="https://gitlab.com/famedly/famedlysdk" target="new">Famedly Matrix SDK</a>
 </p>
<br>
<br>

# Features
 * Single and group chats
 * Send images and files
 * Voice messages
 * Offline chat history
 * Push Notifications
 * Account settings
 * Display user avatars
 * Themes, chat wallpapers and dark mode
 * Device management
 * Edit chat settings and permissions
 * Kick, ban and unban users
 * Display and edit chat topics
 * Change chat & user avatars
 * Archived chats
 * Discover public chats on the user's homeserver
 * Registration
 * Disable account
 * Change password
 * End-To-End-Encryption

# How to build

1. [Install flutter](https://flutter.dev)

2. Clone the repo:
```
git clone --recurse-submodules https://gitlab.com/ChristianPauly/fluffychat-flutter
cd fluffychat-flutter
```

3. Choose your target platform below and enable support for it.

4. Debug with: `flutter run`

### Android

* Install CMake from the SDK Manager

* Install ninja:
```
sudo apt install ninja-build
```

* Outcomment the Google Services plugin at the end of the file `android/app/build.gradle`:
```
// apply plugin: "com.google.gms.google-services"
```

* Build with: `flutter build apk`

### iOS / iPadOS

* With xcode you can't build a release version without our cert. :-/ Use `flutter run --profile` to have a working version on your iOS device.

### Web

* Enable web support in Flutter: https://flutter.dev/docs/get-started/web

* Build with: `flutter build web --release`

### Desktop (Linux, Windows, macOS)

* Enable Desktop support in Flutter: https://flutter.dev/desktop

* Build with one of these: 
```
flutter build linux --release
flutter build windows --release
flutter build macos --release
```


## How to add translations for your language

You can use Weblate to translate the app to your language:

https://hosted.weblate.org/projects/fluffychat/



1. Replace the non-translated string in the codebase:
```
Text("Hello world"),
```
with a method call:
```
Text(L10n.of(context).helloWorld),
```

and add the following import if missing:

```
import 'package:flutter_gen/gen_l10n/l10n.dart';
```

2. Add the string to `/lib/l10n/l10n_en.arb`:

(The following example need to be sorounded by the usual json `{}` and after the `@@locale` key)

Example A:
```
"helloWorld": "Hello World!",
"@helloWorld": {
  "description": "The conventional newborn programmer greeting"
}
```

Example B:
```
"hello": "Hello {userName}",
"@hello": {
  "description": "A message with a single parameter",
  "placeholders": {
    "userName": {
      "type": “String”,
      “example”: “Bob”
    }
  }
}
```

3. For testing just run a regular build without extras

# Special thanks to

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer from Brasil and has made the fluffychat logo and the banner. Big thanks for her great designs.

* <a href="https://github.com/advocatux">Advocatux</a> has made the Spanish translation with great love and care. He always stands by my side and supports my work with great commitment.

* Thanks to MTRNord and Sorunome for developing.

* Thanks to Mark for all his support and the chat background.

* Also thanks to all translators and testers! With your help, fluffychat is now available in more than 12 languages.
