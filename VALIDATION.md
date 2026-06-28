# Allora iOS — Mac/Xcode Validation Sheet

Fill this in while testing the prototype on a Mac. This is the structured
report-back for the validation pass requested in the handoff. Tick boxes,
fill blanks, and log anything notable in the issue table at the end.

> The author of the prototype could **not** run Xcode (Linux container, no
> Apple SDKs), so this build has **never been compiled**. Treat the first
> build as unverified.

---

## 0. Environment under test

| Field | Value |
|-------|-------|
| Repo | `z8yrqct74d-wq/AlloraV2` |
| Branch | `claude/allora-ios-swift-c3pdbe` |
| Commit SHA tested | `____________` |
| Xcode version | `____________` |
| macOS version | `____________` |
| Simulator / device model | `____________` |
| iOS version | `____________` |
| Date / tester | `____________` |

---

## 1. Build

| Check | Result |
|-------|--------|
| Project opens (`Allora.xcodeproj`) | ☐ Yes ☐ No |
| Target builds (Debug) | ☐ Success ☐ Failed |
| Build warnings count | `____` |
| First build clean (no manual fix-ups) | ☐ Yes ☐ No |

Build errors (paste text):
```
(none / paste here)
```

Build warnings (paste text):
```
(none / paste here)
```

---

## 2. Runtime warnings (console)

Note anything logged at launch or during navigation (purple runtime issues,
constraint/layout logs, "CoreAnimation", "Modifying state during view update",
asset-not-found, font fallback, etc.).

```
(none / paste here)
```

| Check | Result |
|-------|--------|
| Launches without crash | ☐ Yes ☐ No |
| No "Modifying state during view update" warnings | ☐ Pass ☐ Fail |
| No constraint/layout console spam | ☐ Pass ☐ Fail |

---

## 3. Per-screen pass/fail (all 12)

For each screen: does it render, is it reachable, and is the layout intact
(no clipping/overlap, scrolls fully, content not hidden behind the tab bar)?

| # | Screen | Reachable | Renders | Layout intact | Notes |
|---|--------|-----------|---------|---------------|-------|
| 1 | Splash | ☐ | ☐ | ☐ | |
| 2 | Home | ☐ | ☐ | ☐ | |
| 3 | Composer (Ask Allora) | ☐ | ☐ | ☐ | |
| 4 | Thinking | ☐ | ☐ | ☐ | |
| 5 | Results | ☐ | ☐ | ☐ | |
| 6 | Detail | ☐ | ☐ | ☐ | |
| 7 | Booking | ☐ | ☐ | ☐ | |
| 8 | Confirmed | ☐ | ☐ | ☐ | |
| 9 | Share | ☐ | ☐ | ☐ | |
| 10 | Feedback | ☐ | ☐ | ☐ | |
| 11 | City Pulse | ☐ | ☐ | ☐ | |
| 12 | Taste Profile | ☐ | ☐ | ☐ | |

Reaching each screen (reference path):
- Splash → tap → **Home**
- Home: orb / Ask tab → **Composer**; type or tap a prompt chip → submit → **Thinking → Results**
- Results: **Details** → **Detail**; **Book** → **Booking** → Confirm → **Confirmed**
- Results/Detail: share icon → **Share**
- Confirmed: "Done" → Home; after booking, Home shows "How was MAT?" → **Feedback**
- Home tab bar: **Pulse**; Home avatar (top-right "A") → **Taste Profile**

---

## 4. Orb state checklist

The orb eases continuously between states — look for smooth transitions, no
snapping, warm champagne/amber palette, and a sphere that reads as volumetric.

| State | How to trigger | Looks right | Smooth (no snap) | Notes |
|-------|----------------|-------------|------------------|-------|
| idle | Home at rest | ☐ | ☐ | slow drift, calm |
| prompt-chip pulse | tap a Home prompt chip | ☐ | ☐ | ~620 ms "breath" swell |
| thinking | submit a query | ☐ | ☐ | faster spin, warming glow |
| convergence | ~1.5 s into Thinking | ☐ | ☐ | particles pull to center, brightest |
| results-ready | Results appears | ☐ | ☐ | settles back to idle/calm |

| Check | Result |
|-------|--------|
| Orb renders on Home (158 pt) | ☐ Yes ☐ No |
| Orb renders on Composer (84 pt) | ☐ Yes ☐ No |
| Orb renders on Thinking (108 pt) | ☐ Yes ☐ No |
| Transition idle→thinking→converge is continuous | ☐ Pass ☐ Fail |
| Pulse transient visibly distinct from idle | ☐ Pass ☐ Fail |

---

## 5. Navigation checklist

| Check | Result | Notes |
|-------|--------|-------|
| Splash tap → Home | ☐ Pass ☐ Fail | |
| Back buttons return to previous screen | ☐ Pass ☐ Fail | |
| Tab bar Home / Ask / Pulse all work | ☐ Pass ☐ Fail | |
| Tab bar only shows on Home & Pulse | ☐ Pass ☐ Fail | |
| Prompt chip → Composer (prefilled) | ☐ Pass ☐ Fail | |
| Submit → Thinking → Results (auto) | ☐ Pass ☐ Fail | |
| Results → Detail / Booking | ☐ Pass ☐ Fail | |
| Booking → Confirm → Confirmed | ☐ Pass ☐ Fail | |
| Confirmed → Done → Home | ☐ Pass ☐ Fail | |
| Post-booking Home memory card → Feedback | ☐ Pass ☐ Fail | |
| Share reachable from Detail/Results/Confirmed | ☐ Pass ☐ Fail | |
| Home avatar → Taste Profile | ☐ Pass ☐ Fail | |
| No dead-ends / stuck screens | ☐ Pass ☐ Fail | |

---

## 6. Layout clipping checklist

| Check | Result | Notes |
|-------|--------|-------|
| No text truncated/clipped unexpectedly | ☐ Pass ☐ Fail | |
| Content not hidden behind floating tab bar | ☐ Pass ☐ Fail | |
| Safe-area handling correct (notch / Dynamic Island) | ☐ Pass ☐ Fail | |
| Home indicator area not overlapped by controls | ☐ Pass ☐ Fail | |
| Horizontal card rows scroll without clipping | ☐ Pass ☐ Fail | |
| Long scroll screens reach the bottom | ☐ Pass ☐ Fail | |
| Bottom action bars (Detail/Booking/Results) usable | ☐ Pass ☐ Fail | |

---

## 7. Missing asset / font warnings

| Check | Result | Notes |
|-------|--------|-------|
| Venue gradient placeholders show (no real photos bundled) | ☐ Expected ☐ Unexpected | gradients are intentional placeholders |
| Any "image not found" / asset warnings | ☐ None ☐ Some → list | |
| Fonts: rendering with system fallback (Newsreader/Hanken not bundled) | ☐ Expected ☐ Unexpected | |
| AppIcon present (art is placeholder) | ☐ Yes ☐ No | |
| AccentColor resolves (terracotta) | ☐ Yes ☐ No | |

List any unexpected asset/font messages:
```
(none / paste here)
```

---

## 8. Animation smoothness

| Check | Result | Notes |
|-------|--------|-------|
| Orb animates smoothly (target ~60 fps) | ☐ Pass ☐ Fail | |
| Screen transitions smooth (no jank) | ☐ Pass ☐ Fail | |
| Results card stagger entrance smooth | ☐ Pass ☐ Fail | |
| Ambient blob drift smooth | ☐ Pass ☐ Fail | |
| Thinking progress bar / chips smooth | ☐ Pass ☐ Fail | |
| Any visible stutter / dropped frames | ☐ None ☐ Some → where | |

Notes (where stutter appears, which device, foreground/background, etc.):
```
```

---

## 9. CPU / GPU / Instruments (if checked)

Optional but valuable — the orb uses a 60 fps `Timer` with up to ~1,800
particles via `Canvas`. Capture rough numbers if you profile.

| Metric | Idle (Home) | Thinking/Converge | Notes |
|--------|-------------|-------------------|-------|
| CPU % | | | |
| GPU % | | | |
| Memory (MB) | | | |
| Frame rate (Core Animation FPS) | | | |
| Energy impact (Xcode gauge) | | | |
| Behavior when orb scrolled off-screen | | | does the Timer keep running? |
| Behavior in Low Power Mode | | | |

Instruments observations:
```
```

---

## 10. Final verdict

☐ **Pass** — builds, all screens/orb states/navigation work, no significant issues
☐ **Pass with minor issues** — usable; minor cosmetic/perf items logged below
☐ **Blocked** — build or a core flow fails; see issues

Summary:
```
```

---

## 11. Issue log

| ID | Severity | Screen / area | Description | Repro steps | Screenshot/video ref |
|----|----------|---------------|-------------|-------------|----------------------|
| 1 | ☐ Blocker ☐ Major ☐ Minor ☐ Cosmetic | | | | |
| 2 | ☐ Blocker ☐ Major ☐ Minor ☐ Cosmetic | | | | |
| 3 | ☐ Blocker ☐ Major ☐ Minor ☐ Cosmetic | | | | |
| 4 | ☐ Blocker ☐ Major ☐ Minor ☐ Cosmetic | | | | |
| 5 | ☐ Blocker ☐ Major ☐ Minor ☐ Cosmetic | | | | |

**Severity guide:** Blocker = can't build/can't proceed · Major = broken
feature or bad stutter · Minor = noticeable but non-blocking · Cosmetic =
polish. Reference screenshots/clips by the filenames from `CAPTURE_PLAN.md`.
