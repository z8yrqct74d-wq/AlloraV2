# Allora iOS — Capture Plan (Primary Journey)

A structured screenshot/video capture plan for the prototype's primary journey,
to be executed once the app builds and runs (see `VALIDATION.md`). Goal: a clean
set of stills + short clips that show the AI-native journey and, above all, the
orb and the liquid-glass interaction language at a premium bar.

> Reminder on the design split: **venue photography = trust; orb / glass /
> motion / interface = magic.** Until real venue photos are bundled, the venue
> imagery is warm **gradient placeholders** — capture around them (favor the
> orb, glass, type, and motion), and clearly label any frame that contains a
> placeholder.

---

## 1. Recommended frame / device

| Setting | Recommendation |
|---------|----------------|
| Device frame | **iPhone 16 Pro** (or 15 Pro) simulator — modern aspect ratio, Dynamic Island |
| Appearance | Light mode (the app is light-only by design) |
| Orientation | Portrait |
| Status bar | Use a clean override (`xcrun simctl status_bar … override` → 9:41, full battery/signal, no clutter) |
| Scale | Capture at native @3x; export @2x/@1x as needed |
| Device bezel | Add an iPhone frame for shareable exports; keep raw (frameless) versions too |

---

## 2. Recording format

| Use | Format | Notes |
|-----|--------|-------|
| Stills | **PNG** (lossless), native resolution | for review + design QA |
| Screen recordings | **.mov / H.264 or HEVC**, 60 fps | 60 fps is essential to show the orb honestly |
| Social/teaser | **MP4 (H.264)**, 1080×1920 vertical, 60 fps | re-export from masters |
| GIF (optional) | only for short orb loops; expect quality loss | prefer video |

Capture commands (simulator):
- Still: `xcrun simctl io booted screenshot allora-01-splash.png`
- Video: `xcrun simctl io booted recordVideo --codec=h264 allora-journey.mov`
  (Ctrl-C to stop). Use QuickTime screen recording if you need a device frame.

Suggested file naming: `allora-NN-<screen>-<still|clip>.<ext>`
(e.g. `allora-03-chip-pulse-clip.mov`).

---

## 3. Primary journey — capture sequence

Walk the journey in order; capture the stills and clips noted at each beat.

| # | Beat | Screen | Still | Clip |
|---|------|--------|:-----:|:----:|
| 1 | Brand open | Splash | ✅ | ✅ (tap → Home transition) |
| 2 | Home, orb at rest | Home (idle orb) | ✅ | ✅ (3–5 s idle drift) |
| 3 | Prompt-chip tap pulse | Home | ✅ (at swell peak) | ✅ (tap → orb pulse) |
| 4 | Ask Allora | Composer | ✅ | ✅ (type / pick example) |
| 5 | Reading the evening | Thinking (orb) | ✅ | ✅ (full thinking loop) |
| 6 | Convergence → results arriving | Thinking → Results | ✅ (convergence peak) | ✅ (converge → Results stagger) |
| 7 | Shortlist | Results | ✅ | ✅ (scroll + refine chip) |
| 8 | Venue hero | Detail | ✅ | ✅ (hero → scroll to menu/map) |
| 9 | Choose a table | Booking | ✅ | ✅ (time select + guest stepper) |
| 10 | Confirmation moment | Confirmed | ✅ (check + receipt) | ✅ (confirm → check pop) |
| 11 | Shareable artifact | Share | ✅ | ✅ (card entrance + copy toast) |
| 12 | After-dinner feedback | Feedback | ✅ | ✅ (tap → memory line appears) |
| 13 | City Pulse | City Pulse | ✅ | ✅ (scroll the sections) |
| — | (bonus) Taste Profile | Taste Profile | ✅ | optional |

---

## 4. Exact moments — STILL screenshots

Capture these as frozen frames:

1. **Splash** — full logo lockup, glow at a bright phase, "Tap to begin" visible.
2. **Home idle** — orb centered, the "Where should we go, *tonight?*" headline,
   glass prompt pill, prompt-chip row, tab bar visible.
3. **Chip pulse peak** — the instant the orb's pulse swell is brightest/most
   gathered after a chip tap (~300 ms after tap).
4. **Composer** — input with an example query filled in, orb (84 pt) above,
   "Find tables" CTA visible.
5. **Thinking** — orb mid-spin with the intent chips laid out and the progress
   bar partway, "Reading the evening…".
6. **Convergence peak** — orb at maximum gather/brightness, just before Results.
7. **Results** — all three cards in view (or top two), reason callouts and the
   role badges legible; refine chips + bottom CTA.
8. **Detail hero** — large hero with the name overlay, "Why Allora picked this"
   card just below the fold.
9. **Booking** — time row with a slot selected, guest stepper, the "Confirmed
   live" green strip.
10. **Confirmed** — green check + "Your table is set." + the receipt card with
    confirmation code.
11. **Share artifact** — the share card fully on-screen (this is the hero
    social/marketing still); also one with the "Link copied ✓" toast.
12. **Feedback** — a feedback chip selected and the "Allora is learning" memory
    line shown.
13. **City Pulse** — header + "pick of the night" tall card + a section of
    available-now cards.

---

## 5. Exact moments — VIDEO clips

Capture these as short clips (keep each tight, 2–6 s unless noted):

1. **Splash → Home** — tap, brand dissolves into Home (shows entrance motion).
2. **Home idle loop** — 4–5 s of the orb breathing/drifting with the float
   (this is a key "it's alive" clip).
3. **Chip pulse** — tap a prompt chip, hold on the orb's pulse swell, into the
   Composer push.
4. **Full thinking → convergence → results** (the money clip, ~4 s) — submit,
   orb spins up, particles converge, Results cards stagger in. Capture at 60 fps.
5. **Results interaction** — scroll the shortlist and tap a refine chip (shows
   the refine note appear).
6. **Detail scroll** — hero parallax-feel into menu/map/reviews.
7. **Booking** — select a time, step guests up/down (button press scale).
8. **Confirmation** — Confirm → check-mark pop + glow.
9. **Share** — entrance of the share card + tap "Copy link" → toast.
10. **Feedback** — choose a chip → memory line animates in.

For each clip, also keep a **frameless master** so it can be re-cropped/re-framed.

---

## 6. Real-photo placeholder vs final photography

- Every venue image currently shown is a **gradient placeholder** — not the
  design direction. **Label** any captured frame that includes one
  (filename suffix `-PLACEHOLDER`, or a note in the contact sheet).
- For review decks, prefer frames where the orb/glass/type/motion carry the
  story and venue imagery is incidental (Home, Composer, Thinking,
  convergence, Confirmed receipt).
- Plan a **re-capture pass** once real venue photography is bundled (drop image
  sets `r-mat`, `r-kane`, … per `Allora/Resources/VENUE_PHOTOS.md`). The
  highest-impact re-captures will be **Detail hero**, **Results cards**, and the
  **Share artifact** — the frames where photography does the most work.
- Keep a clear "before (placeholder) / after (real photo)" pairing for those
  three — useful for showing the trust+magic split.

---

## 7. Capturing the orb clearly

- **Record at 60 fps.** 30 fps misrepresents the motion.
- Use the largest instance (**Home, 158 pt**) for the hero orb clips; the
  Thinking orb (108 pt) is best for the convergence beat.
- Hold idle for a few seconds before triggering a state change so the
  transition reads against a calm baseline.
- Capture the **full** idle → thinking → converge → results-ready arc in one
  take so the easing between states is visible (no cuts).
- If profiling shows the orb is heavy, note it in `VALIDATION.md` rather than
  changing anything — motion architecture is frozen until reviewed on-device.
- Consider one slow-motion export (e.g. 0.5×) of the convergence purely for
  showing particle behavior in design review.

---

## 8. Optional social teaser ideas

- **15–20 s vertical teaser** (1080×1920, 60 fps): idle orb → chip tap pulse →
  thinking → convergence → Results → Confirmed check → Share card. Score with a
  calm, warm track; let the orb be the star.
- **Loopable orb sting** (3–5 s): the idle orb breathing, seamless loop, for an
  app-icon/launch teaser or a landing-page hero.
- **"Trust + magic" split card**: Share artifact (magic) beside a real venue
  photo once available (trust) — one frame that states the product thesis.
- **Before/after photography** reel: the three re-capture frames (Detail hero /
  Results / Share) placeholder → real, quick cross-dissolves.
- **Convergence close-up** (slow-mo): particles gathering — a striking, abstract
  brand moment that doesn't depend on any venue imagery.

Keep masters lossless and frameless; export framed/compressed versions per
channel.
