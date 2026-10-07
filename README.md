<img src="https://github.com/BaBingoBango/Pixel-Pursuit/assets/40375449/ad570455-47d0-487d-9811-cd54f73d525f" alt="Pixel Pursuit logo" width="100"/>

### Pixel Pursuit

An AR game that tasks you with conducting a basic computer forensics investigation! The I.D.D.A. needs YOU!

- Explore Amanda's hard drive and office in augmented reality!
- Piece together the story of Amanda's (alleged) crime!
- Solve puzzles and make a final judgement!
- A winner of Apple’s [WWDC23 Swift Student Challenge](https://web.archive.org/web/20230404002347/https://developer.apple.com/wwdc23/swift-student-challenge/)!

## Playing

Pixel Pursuit is an iPad game for iPadOS 26 and later on any iPad with ARKit. It plays best in landscape with some open floor space around you, since the whole investigation happens in augmented reality. Turn your sound on, too!

## Building

Open `Pixel Pursuit.xcodeproj` in Xcode 27 or later and run the **Pixel Pursuit** scheme on an iPad.

> **Note**<br>
> The Simulator can't do AR, so there the game renders each scene with a fixed virtual camera and skips the room-scanning step. That's enough to try the interface and the puzzles, but the scenes inside Amanda's disk are triggered by walking up to things, which only works on a real iPad.

`⌘U` runs the tests: the game logic, loading every scene from the Reality file, and a UI playthrough up to Amanda's disk.

## Project layout

- `Pixel Pursuit/` – the app. SwiftUI with the `App` life cycle, Swift 6 with main-actor isolation by default, and RealityKit + ARKit for the AR scenes.
  - `Models/` – the game's phases, scenes, actions, and Agent W's dialogue.
  - `Views/` – one view per phase of the game, from the power switch to the finale.
  - `AR/` – the RealityKit view and the loader for `Pixel Pursuit.reality`.
  - `Support/` – fonts, audio, logos, and the animated static background.
  - `AppIcon.icon` – the app icon as an Icon Composer package: the I.D.D.A. seal split into Liquid Glass layers (sparkles, ring, globe, pixels) over a near-black gradient. Open it in Icon Composer to tweak glass, translucency, or the per-appearance fills.
  - `Pixel Pursuit.reality` – the compiled Reality Composer scenes the game loads.
- `Reality Composer Projects/` – the editable `.rcproject` sources for the AR scenes. Current versions of Xcode can't compile these any more, so to change a scene, open the project in Reality Composer on iPad and export a new `Pixel Pursuit.reality`. The bundled file was built from `Pixel Pursuit Iconic`, which uses the stylized "iconic" look of Reality Composer's object library and weighs about 22 MB. `Pixel Pursuit` is the photorealistic variant: its export comes out around 410 MB, which is over GitHub's file size limit, so it isn't checked in. To ship it, export it from Reality Composer and replace `Pixel Pursuit/Pixel Pursuit.reality` before archiving. `Pixel Pursuit Reduced` is a trimmed-down experiment.
- `Pixel Pursuit.swiftpm/` – the Swift Playgrounds app package exactly as it was submitted to the Swift Student Challenge, kept for posterity.
- `Final SSC Submission/` – the submission itself.
