# Allora — iOS

A native iOS (SwiftUI) port of the Allora restaurant-discovery concept — a warm, AI-led app that helps you find and book a table for tonight in Bucharest.

This is a faithful re-implementation of the `Allora.dc.html` design prototype as a real native Swift app, replacing the React/HTML runtime with idiomatic SwiftUI.

## Requirements

- Xcode 15+
- iOS 17.0+

## Running

Open `Allora.xcodeproj` in Xcode, select an iPhone simulator (iPhone 15 / 16 recommended), and run.

## Architecture

- **`AlloraApp.swift`** — app entry point.
- **`ContentView.swift`** — root router that renders the active screen and overlays the tab bar.
- **`AppState.swift`** — `ObservableObject` holding the navigation stack and all flow state (query, booking, feedback, etc.). Mirrors the `DCLogic` state machine from the prototype.
- **`DesignSystem.swift`** — colors, typography helpers, gradients, button styles, and shared small components.
- **`Models/Restaurant.swift`** — the restaurant data model and the full Bucharest dataset.

### Screens (`Views/`)

`Splash → Home → Composer → Thinking → Results → Detail → Booking → Confirmed`,
plus `Share`, `Feedback`, `Pulse` (city pulse) and `TasteProfile`.

### Components (`Views/Components/`)

- **`AlloraOrbView`** — the signature animated particle "orb", rendered with `Canvas` and a per-frame timer. Supports `idle` / `thinking` / `converge` modes that animate gather, rotation, and glow, matching `AlloraOrb.dc.html`.
- **`TabBarView`** — floating glass tab bar (Home / Ask / Pulse).
- **`RestaurantCardView`** — reusable tile / pick-of-night / placeholder-image cards.

## Notes

- The design uses the **Newsreader** (serif) and **Hanken Grotesk** (sans) type families. If those fonts aren't installed/bundled, SwiftUI falls back to the system font automatically. To match the prototype exactly, add the font files to the target and register them under `UIAppFonts`.
- Restaurant imagery in the prototype referenced bundled photos; here those are represented with warm generated gradient placeholders so the app runs with no external assets.
