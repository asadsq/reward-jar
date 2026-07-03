# Reward Jar

A SwiftUI iOS app that gamifies reward tracking with a visual jar you fill up with stars and gems.

## What it does

Tap the star or gem buttons to drop items into an animated glass jar. Stars are worth 1 point each; gems are worth 2. When the jar reaches 10 points, a celebration screen fires with a confetti burst and a trophy panel. Tapping anywhere resets the jar for the next round.

### Details

- **Stars** (⭐) — worth 1 point
- **Gems** (💎) — worth 2 points
- **Capacity** — 10 points to fill the jar
- **Nearly full warning** — at 8+ points the jar wobbles and the lid rattles to signal it's almost time to celebrate
- **Celebration** — emoji particles explode outward, a "Reward Earned" panel springs in, haptics and sound effects play throughout

## Tech

- Swift / SwiftUI
- iOS (portrait, phone)
- Custom `Shape`-based jar drawn entirely in code — no image assets
- `TimelineView` drives the wobble animation when the jar is nearly full
- `AVFoundation` via `SoundManager` for sound effects
- `UIImpactFeedbackGenerator` / `UINotificationFeedbackGenerator` for haptics

## Project structure

Each source file also carries its own plain-English `Description:` block at the top.

```
reward-jar/
├── reward_jarApp.swift     # App entry point — creates the window, shows ContentView
├── ContentView.swift       # Root view and central controller: state + add-item logic
├── JarItem.swift           # Data model — kind (star/gem), point value, tilt/jitter
├── Jar.swift               # Glass jar (body, lid, highlights) + item pile layout
├── CartoonItem.swift       # Finished glossy star/gem icons, layered from the shapes
├── CartoonShapes.swift     # Raw vector outlines for the star, gem, and shine highlights
├── Counters.swift          # Top row of star/gem counter chips
├── Buttons.swift           # Big round add-item buttons with bounce press effect
├── Celebration.swift       # Confetti explosion + reward panel overlay when jar is full
├── Background.swift         # Soft pink-to-lavender gradient background
├── Palette.swift           # Single source of truth for colors and gradients
└── SoundManager.swift      # Synthesizes and plays all sound effects at runtime
```

Test targets:

- `reward-jarTests/` — unit tests (placeholder, ready for logic tests)
- `reward-jarUITests/` — UI tests that launch the app, plus a launch-screenshot test

## How the pieces fit together

1. `reward_jarApp` launches and shows `ContentView`.
2. `ContentView` lays out `ModernBackground`, `CounterRow`, the `Jar`, and two `BigButton`s.
3. Tapping a button asks `SoundManager` to play a sound and appends a `JarItem`.
4. `Jar` re-renders the pile using `CartoonItem` (built from `CartoonShapes`), all styled with `Palette`.
5. When the total reaches capacity, `ContentView` shows `CelebrationView`; tapping it clears the jar.

See [`CLAUDE.md`](CLAUDE.md) for deeper architecture notes and a guide to adding a new item kind.

## Running the app

Open `reward-jar.xcodeproj` in Xcode, select an iOS simulator or device, and press Run.
