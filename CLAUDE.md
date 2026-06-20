# reward-jar

A SwiftUI iOS app for tracking rewards. Users fill a cartoon jar with stars and gems by tapping buttons. When the jar reaches capacity a celebration animation plays and the jar resets.

## How it works

- **Star** = 1 point, **Gem** = 2 points
- **Capacity** = 10 points total
- **Nearly full** (8–9 pts): jar wobbles, lid chatters, haptic buzz fires
- **Full** (10 pts): celebration overlay + explosion sound, tap anywhere to dismiss and reset

## File map

| File | What it contains |
|---|---|
| `ContentView.swift` | Root view; owns all state (`items`, `celebrating`); drives the wobble timeline |
| `JarItem.swift` | `JarItem` model — `Kind` (.star/.gem), random tilt/jitter on init |
| `Jar.swift` | `Jar`, `JarBody`, `JarLid`, `ItemPile`, all custom `Shape` paths for the glass jar |
| `CartoonItem.swift` | `CartoonStarView` / `CartoonGemView` — layered shapes with highlight/shadow |
| `CartoonShapes.swift` | `CartoonStarShape`, `CartoonGemShape`, `StarShine`, `GemShine` — pure `Shape` paths |
| `Buttons.swift` | `BigButton` (circle gradient button) + `BounceStyle` press animation |
| `Counters.swift` | `CounterRow` + `CounterChip` — top HUD showing star/gem counts |
| `Celebration.swift` | `CelebrationView` (particle burst overlay) + `RewardPanel` modal + `Particle` model |
| `Palette.swift` | `Palette` enum — all `LinearGradient` and `Color` constants |
| `Background.swift` | `ModernBackground` — pink-to-lavender layered gradient background |
| `SoundManager.swift` | `SoundManager` singleton — **all sounds are synthesized at runtime** via AVAudioEngine; no audio asset files |

## Architecture notes

- **All state lives in `ContentView`** — no view model, no observable objects. Items are a plain `[JarItem]` `@State`.
- **Platform**: iOS only. Uses `UIImpactFeedbackGenerator` and `UINotificationFeedbackGenerator` directly in `ContentView`.
- **Sound synthesis**: `SoundManager` builds PCM buffers on init using sine waves and custom envelopes (pluck, chime, buzz, sparkle). Pool of 4 `AVAudioPlayerNode`s for concurrent playback. Adding sounds = add a `makeX()` method + buffer key + public `playX()` method.
- **Item layout**: `ItemPile` stacks items in rows of 3 (`perRow = 3`), alternating row stagger, each item has random tilt (±18°) and x/y jitter baked in at creation.
- **Wobble animation**: driven by `TimelineView(.animation(paused: !isNearlyFull))` — runs only when `totalStars >= 8`. Body and lid animate on separate phase offsets for an organic feel.
- **Palette is the single source of truth** for all colors and gradients — never hardcode colors elsewhere.

## Adding a new item kind

1. Add a case to `JarItem.Kind` with its `value`.
2. Create a `CartoonXxxView` in `CartoonItem.swift` (and shape in `CartoonShapes.swift` if needed).
3. Add gradient colors to `BigButton.colors` in `Buttons.swift`.
4. Add palette entries in `Palette.swift`.
5. Add a sound buffer in `SoundManager.prepareBuffers()` and a `playXxx()` method.
