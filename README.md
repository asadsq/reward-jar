# Reward Jar

A small, playful SwiftUI iOS app. Tap the buttons to drop stars and gems into a
glass jar. Stars are worth 1 point and gems are worth 2. As the jar nears full
it wobbles and buzzes, and once it hits capacity (10 points) a full-screen
celebration bursts with confetti and a trophy. Tapping the celebration empties
the jar to start again.

This document is the master overview of every code file in the project. Each
source file also carries its own plain-English `Description:` block at the top.

## Project layout

```
reward-jar/            App source code (SwiftUI)
reward-jarTests/       Unit tests
reward-jarUITests/     UI / launch tests
reward-jar.xcodeproj/  Xcode project files
```

## App source files (`reward-jar/`)

- **reward_jarApp.swift** — The app's entry point. Creates the app window and
  shows the main screen (`ContentView`) when the app launches.
- **ContentView.swift** — The main screen and central controller. Tracks the
  items in the jar, shows the counters, the jar, and the two add buttons;
  handles adding items, the near-full wobble, and triggering/dismissing the
  celebration.
- **JarItem.swift** — The data model for one item. Records whether it's a star
  or gem, its random tilt and position jitter, and its point value (star = 1,
  gem = 2).
- **Palette.swift** — A single source of truth for all colors and gradients
  used across the app (stars, gems, lid, glass).
- **Background.swift** — The soft pink-to-lavender gradient backdrop with two
  glowing corner accents that sits behind everything.
- **Counters.swift** — The top row of two pill-shaped counters showing how many
  stars and gems have been collected, with the numbers animating on change.
- **Buttons.swift** — The two large round "add star" / "add gem" buttons,
  including the springy bounce effect when pressed.
- **CartoonShapes.swift** — The raw vector outlines (geometry only) for the star
  and gem plus their smaller shine highlights.
- **CartoonItem.swift** — Builds the finished, glossy star and gem icons by
  layering shadow, fill, shading, outline, and shine over the shapes. Reused in
  the buttons, counters, and jar.
- **Jar.swift** — Draws the glass jar (body, lid, knob, highlights, reflections)
  and arranges the collected items in staggered rows piling up inside it.
- **Celebration.swift** — The full-screen "you did it!" overlay: dimmed
  background, bursting emoji confetti, and a trophy reward panel. Tapping it
  dismisses and resets the jar.
- **SoundManager.swift** — Generates all sound effects in code (no audio files)
  and plays them: `playStar()`, `playGem()`, `playVibration()`, and
  `playExplosion()`.

## Test files

- **reward-jarTests/reward_jarTests.swift** — Unit test target for the app's
  logic. Currently a placeholder ready for tests.
- **reward-jarUITests/reward_jarUITests.swift** — UI test target that launches
  the app to test it like a user would; includes a launch-performance test.
- **reward-jarUITests/reward_jarUITestsLaunchTests.swift** — Launches the app and
  captures a screenshot of the first screen to verify a clean startup.

## How the pieces fit together

1. `reward_jarApp` launches and shows `ContentView`.
2. `ContentView` lays out `ModernBackground`, `CounterRow`, the `Jar`, and two
   `BigButton`s.
3. Tapping a button asks `SoundManager` to play a sound and appends a `JarItem`.
4. `Jar` re-renders the pile using `CartoonItem` (built from `CartoonShapes`),
   all styled with `Palette`.
5. When the total reaches capacity, `ContentView` shows `CelebrationView`;
   tapping it clears the jar.
