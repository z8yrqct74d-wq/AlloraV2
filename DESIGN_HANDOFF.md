# Allora — Native iOS Design Handoff

A standalone **native SwiftUI** exploration of the next-generation Allora
experience. This repo is *not* the production Expo/React Native app — it exists
to explore and validate the AI-native Home, the Allora orb, liquid-glass
navigation, the primary journey, City Pulse, the booking/share/feedback
emotional moments, and the overall motion + interaction language at a premium
native-iOS quality bar.

> **Status:** design prototype. Self-contained — runs with no external assets.
> Real photography and brand fonts are the intended final direction and drop in
> without code changes (see [Assets](#image-asset-requirements)).

---

## 1. Screen list

| # | Screen | File | Purpose |
|---|--------|------|---------|
| 1 | Splash | `Views/SplashView.swift` | Brand moment; tap to enter |
| 2 | Home | `Views/HomeView.swift` | AI-native home; the orb is the primary CTA |
| 3 | Composer | `Views/ComposerView.swift` | Free-text / voice / example prompt entry |
| 4 | Thinking | `Views/ThinkingView.swift` | Intent parse + "checking availability" |
| 5 | Results | `Views/ResultsView.swift` | 3-table shortlist with reasons + refine chips |
| 6 | Detail | `Views/DetailView.swift` | Full venue: why-picked, times, menu, map, reviews |
| 7 | Booking | `Views/BookingView.swift` | Time / guests / contact / special request |
| 8 | Confirmed | `Views/ConfirmedView.swift` | Reservation success + receipt card |
| 9 | Share | `Views/ShareView.swift` | Beautiful shareable card + targets |
| 10 | Feedback | `Views/FeedbackView.swift` | After-dinner "was this right?" → memory |
| 11 | City Pulse | `Views/PulseView.swift` | What the city is doing tonight |
| 12 | Taste Profile | `Views/TasteProfileView.swift` | The user's living memory / taste graph |

The native iOS status bar and home indicator are used directly (the HTML
prototype faked a status bar + Dynamic Island; those are unnecessary natively).

---

## 2. Flow structure

State and navigation live in **`AppState.swift`** (an `ObservableObject`),
mirroring the prototype's `DCLogic` state machine. `ContentView` is a router
that renders the top of a navigation stack and overlays the tab bar.

```
Splash ─tap─▶ Home ◀────────────────── tab bar (Home · Ask · Pulse)
               │                                 │
               │ orb / Ask                       └─▶ City Pulse
               ▼
           Composer ─submit─▶ Thinking ─▶ Results ─▶ Detail ─▶ Booking ─▶ Confirmed
               ▲                              │         │                     │
   prompt chips ┘                    refine chips    Share ◀────────┬─────────┘
                                                                    │
                              Home (after booking) ─▶ Feedback ◀────┘
                                                          │
   Home avatar ─▶ Taste Profile                     memory line → Home
```

Navigation primitives (`AppState`):
- `go(_:)` push · `replace(_:)` swap top · `back()` pop · `goHome()` reset
- `openDetail`, `openBooking`, `openComposerWith`, `submit`, `confirm`,
  `setTab`, `pulseOrb`, `chooseFeedback`, `finishFeedback`

Key state: `screenStack`, `query`, `listening`, `selectedRefine`, `bookTime`,
`bookGuests`, `specialRequest`, `booked`, `feedbackChoice`, `fedback`,
`copied`, `pulseCount`, `orbMode`, `selectedRestaurantId`, `activeTab`.

All transitions use `withAnimation(.alloraEase)`; the "booked" flag unlocks the
Home memory card and the share card's "we're booked tonight" badge.

---

## 3. The Allora orb — behavior & state machine

File: `Views/Components/AlloraOrbView.swift`. A volumetric particle sphere
rendered with `Canvas` + a 60 fps timer. Apple-grade *motion quality* (smooth
critically-damped easing, gentle breathing, depth-shaded additive particles),
but deliberately **Allora's own**: a warm dining orb — champagne, amber,
candlelit, atmospheric, alive — not a literal Apple/Siri copy.

### States
| State | Trigger | Rotation rate | Gather | Glow | Feeling |
|-------|---------|--------------:|-------:|-----:|---------|
| **idle** | Home resting | 0.16 | 0.0 | 0.0 | Calm, slow drift |
| **prompt-chip pulse** | tap a Home chip (`pulse` counter) | — | +0.07 transient | +0.5 transient | A quick "breath" of acknowledgement (~620 ms half-sine) |
| **thinking** | `submit()` | 0.55 | 0.14 | 0.34 | Energy gathering, warming |
| **converge** | ~1.48 s into thinking | 0.92 | 1.0 | 0.62 | Particles pull to center, brightest — "the answer is forming" |
| **results-ready** | results shown | back to idle | 0.0 | 0.0 | Settles, calm again |

### How it's wired
- `mode: OrbDisplayMode` (`idle / thinking / converge`) is eased toward
  per-mode targets **every frame** — transitions are continuous, never cut.
- `pulse: Int` — increment to fire the one-shot transient. Home passes
  `pulse: state.pulseCount`; `pulseOrb()` bumps it on chip tap.
- Rotation **angle is integrated** (`angle += dt * rate`) so changing the rate
  never snaps the orb.
- Timeline (`AppState.submit()`): `thinking` → after 1.48 s `converge` → after
  2.25 s `replace(.results)` and `orbMode = .idle`.

### Tuning knobs
- Particle count scales with size (`140…1800`), center-dense (`pow(rand,1.15)`).
- Palette = `makeParticles()` color array (champagne→bronze→blush), weighted
  toward the brighter end.
- Per-mode targets live in `updateAnimation()`; pulse shape/length in
  `drawOrb()` (`0.62 s`, `0.07` gather, `0.5` glow).

---

## 4. Motion language

A calm, warm, premium choreography. Nothing snaps; everything breathes.

- **Screen transitions** — `easeInOut ~0.42 s` (`Animation.alloraEase`).
- **Cards / success** — gentle spring (`response 0.5, damping 0.75–0.8`)
  with staggered entrances (Results cards offset by `index * 0.09 s`).
- **Orb** — critically-damped easing toward targets (`k = 1 - 0.0025^dt`),
  continuous breathing (`±2.8%`), slow vertical float on Home (`5.6 s`).
- **Ambient blobs** — large blurred radial-gradient orbs drift behind content
  (champagne / terracotta / dusk-purple) for depth and atmosphere.
- **Pulse rings** — expanding strokes around the orb / live dots (`3.6 s` Home,
  `2.4 s` Thinking).
- **Thinking** — intent chips appear, a progress bar fills `~2.1 s`.
- **Mic** — expanding ring while "listening".
- **Presses** — buttons scale to `0.92–0.97` (`AlloraButtonStyle` /
  `CircleButtonStyle`).

Principle: **the interface is alive but never busy** — motion communicates that
Allora is thinking *with* you.

---

## 5. Glass / navigation system ("liquid glass")

File: `Views/Components/TabBarView.swift`, plus inline glass surfaces.

- **Floating capsule tab bar** — `Home · Ask · Pulse` — translucent
  (`.ultraThinMaterial` + warm tint `#FAF4E9` @72%), hairline white stroke,
  soft warm drop shadow, hovering above a bottom fade that melts content under
  it. The center **Ask** control is the orb-colored primary action.
- **Glass surfaces elsewhere** — the Composer input, Home CTA pill, Pulse
  status pill, Results cards, and Taste "usual vibe" card all use the same
  recipe: `Color(...).opacity(~0.66) + .ultraThinMaterial + white stroke +
  warm shadow`. This is the system's signature material.
- Shown only on Home & Pulse (`AppState.showTabBar`); inner screens are
  full-bleed with their own back affordances.

---

## 6. Design tokens

File: `DesignSystem.swift` (`Color(hex:)` + named tokens).

| Token | Hex | Use |
|-------|-----|-----|
| `alloraCream` | `#F3ECDF` | App background |
| `alloraDark` | `#241D14` | Primary text / dark cards |
| `alloraTerracotta` | `#BC5230` | Primary accent / CTAs |
| `alloraGold` | `#B07A3F` | Section labels |
| `alloraGoldLight` | `#C99A5E` | Splash accents |
| `alloraMuted` | `#8A7E6C` | Secondary text |
| `alloraFaint` | `#A2967F` | Tertiary text |
| `alloraWarm` | `#F0E3CE` | Mic / soft chips |
| `alloraSurface` | `#FCF8F0` | Cards |
| `alloraBorder` | `#E4C7A0` | Memory card border |
| `alloraChip` | `#EAE0CF` | Chips / circle buttons |
| `alloraText` | `#3A3128` | Body |
| `alloraGreen` | `#4F9C6B` | Live / confirmed |

Plus **role colors** per restaurant (`roleColor`) and orb-gradient stops
(`#D2693F → #A53E20`). Gradients: `creamBackground`, `splashBackground`,
`composerBackground`. Radii: chips `11–13`, cards `15–18`, big cards `22–28`,
pills/Capsule. Spacing is on a loose `~4 pt` grid (common: `9/11/13/14/18/20/22`).

---

## 7. Typography

Helper: `AlloraFont` in `DesignSystem.swift`.

- **Newsreader** (serif) — display, restaurant names, the editorial italic
  voice ("where should we go, *tonight?*"). Light for the splash logo (74 pt).
- **Hanken Grotesk** (sans) — labels, body, buttons, meta. Bold + wide kerning
  for the uppercase section labels.

Both fall back to the system font until installed — see
`Allora/Resources/Fonts/README.md` for the drop-in steps and the exact
PostScript names / weights referenced.

---

## 8. Image asset requirements

See `Allora/Resources/VENUE_PHOTOS.md` for the full table.

- **Venue photos** — add Image Sets named `r-mat`, `r-kane`, `r-sare`, … to
  `Assets.xcassets`. `RestaurantPlaceholderImage` uses them automatically via
  `UIImage(named:)`; **no code change** required.
- **App icon / accent** — `Assets.xcassets/AppIcon` (1024² slot present, art
  TBD) and `AccentColor` (set to terracotta).
- **Gallery** ("A look inside") — currently abstract warm gradients; swap for
  3–4 real photos per venue when a gallery asset list is added.

---

## 9. Final design direction vs placeholder

| Element | Status | Notes |
|--------|--------|-------|
| Orb (motion, palette, states) | **Final direction** | The signature; tune values, don't replace the approach |
| Liquid-glass tab bar + glass surfaces | **Final direction** | Material recipe is the system |
| Warm palette, type system, motion language | **Final direction** | Brand-defining |
| Screen layouts & primary journey | **Final direction** (prototype fidelity) | Validated end-to-end |
| **Venue gradients** | **Placeholder — temporary** | Stand-ins so the app is self-contained; real photography is final |
| "A look inside" gallery gradients | **Placeholder — temporary** | Replace with real photos |
| App icon art | **Placeholder** | 1024² slot only |
| Fonts (system fallback) | **Placeholder rendering** | Newsreader + Hanken Grotesk are final |
| Data (9 Bucharest venues, contact, "live") | **Mock** | Hard-coded; no backend in this repo |
| Map (stylized block) | **Placeholder** | Real map/`MapKit` TBD |
| Voice "listening" | **Simulated** | Canned transcript; no real speech yet |

The split to hold onto: **photography = trust; orb / glass / motion / interface
= magic.** Keep gradients clearly temporary; let real venue photography land as
the final direction.

---

## 10. Build & run

- Xcode 15+, iOS 17.0+ deployment target.
- Open `Allora.xcodeproj`, select an iPhone 15/16 simulator, Run.
- No packages, no network, no assets required to launch.

## 11. Recommended next design refinement

1. **Land real venue photography** for the 9 seeds — it's the single biggest
   jump in perceived quality and the one explicitly-final placeholder.
2. **Install the brand fonts** (Newsreader + Hanken Grotesk) — moves the type
   from "nice" to on-brand; everything is already tuned for them.
3. **Orb polish pass on device** — verify 60 fps with full particle counts on
   older hardware; consider a `TimelineView(.animation)` migration and a
   reduced-motion / low-power fallback.
4. **Real map** (MapKit) on Detail, and a richer per-venue gallery.
5. **Haptics** on the emotional beats (chip tap → orb pulse, confirm, feedback)
   to deepen the "alive" feeling.
