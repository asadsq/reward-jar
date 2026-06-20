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

```
reward-jar/
├── reward_jarApp.swift     # App entry point
├── ContentView.swift       # Root view, state, and add-item logic
├── JarItem.swift           # Data model (kind, value, jitter/tilt)
├── Jar.swift               # Jar + lid + item pile rendering
├── CartoonItem.swift       # Star and gem illustrations
├── CartoonShapes.swift     # Reusable shape primitives
├── Counters.swift          # Star/gem counter chips
├── Buttons.swift           # Add-item buttons
├── Celebration.swift       # Confetti explosion + reward panel
├── Background.swift        # Gradient background
├── Palette.swift           # Color constants
└── SoundManager.swift      # AVFoundation sound playback
```

## Running the app

Open `reward-jar.xcodeproj` in Xcode, select an iOS simulator or device, and press Run.
