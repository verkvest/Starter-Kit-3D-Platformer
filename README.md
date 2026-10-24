<p align="center"><img src="icon.png"/></p>

# Mallowskip

A small landscape 3D platformer for phones. Hop a cream sprout across five grassy knolls, grab coins, and reach the flag.

Built from the [Kenney Starter Kit 3D Platformer](https://kenney.nl) for Godot 4.6. The renderer is Mobile. Touch play uses a virtual joystick on the left, a jump button on the right, and a swipe anywhere else to orbit the camera.

Bundle id, iOS and Android: `es.verkvest.mallowskip`

### Play

Levels unlock in order. Coins are the score; the flag clears the level. Falling off restarts that level so dropped platforms come back. Best coin counts are saved on the device.

| Level | What it asks |
| --- | --- |
| Meadow | The original starter layout, plus a goal on the flag |
| Brick Rise | Steps and bricks you bonk from below |
| Crumble Run | Tan platforms that fall as soon as you land |
| High Garden | One island that needs a double jump |
| Summit | Steps, falling bridges, and a last double jump |

Keyboard and gamepad still work: WASD or arrows to move, Space to jump, arrow keys to look.

### Credits

Open Credits in the game, or read `THIRD_PARTY_LICENSES.md`.

- Game code: MIT, Copyright 2023 and 2026 Kenney, plus the Mallowskip changes in this repo
- Models, sprites, sounds, skybox: CC0 Kenney. No music
- Lilita One: SIL OFL 1.1, Juan Montoreano 2011, reserved name Lilita
- Sound pool in `scripts/audio.gd`: adapted from KidsCanCode
- Engine: Godot 4.6, MIT

The app icon and boot splash are original. They are not Kenney's character.

### Export

Godot 4.6.2. iOS exports an Xcode project only (`application/export_project_only`) so signing happens in CI. Android uses the Gradle build with `minSdk` 24 and `targetSdk` 36. The stock template still compiles against API 35; `ci/patch-android-templates.sh` raises `compileSdk` and the Android Gradle Plugin to 8.9.1, then `ci/install-android-template.sh` installs that template into `android/build` (Godot will not export without it).

GitHub Actions:

- `ios-testflight` archives an unsigned iOS build, then signs with the App Store Connect API key (team `38PT254HDZ`) and uploads to TestFlight. Build number is `github.run_number`. `ITSAppUsesNonExemptEncryption` is false.
- `android` builds a release APK and AAB. With `ANDROID_KEYSTORE_B64`, `ANDROID_KEYSTORE_PASSWORD`, and `ANDROID_KEY_ALIAS` they are release-signed. Without those secrets they are debug-signed and still uploaded as artifacts. A second job saves phone-viewport screenshots of the menu and the first level.

The App Store Connect app record cannot be created by the API. If the upload says it cannot determine the Apple ID, create the app for `es.verkvest.mallowskip` in App Store Connect and re-run `ios-testflight`.
