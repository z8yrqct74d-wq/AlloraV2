# Venue photography (FINAL design direction)

Real restaurant / interior photography is the intended final direction for all
venue imagery. Photos carry **trust**; the orb, glass, motion and interface
carry the **magic**. The generated gradients currently shown are temporary
placeholders only (see `DESIGN_HANDOFF.md`).

## How to add real photos (drop-in, no code changes)

For each restaurant, add an **Image Set** to `Assets.xcassets` whose name
matches the restaurant's `imageName`:

| Restaurant | `id`     | Asset name (`imageName`) |
|------------|----------|--------------------------|
| MAT        | `mat`    | `r-mat`                  |
| Kané       | `kane`   | `r-kane`                 |
| Noua       | `noua`   | `r-noua`                 |
| Sare & Foc | `sare`   | `r-sare`                 |
| Lumina     | `lumina` | `r-lumina`               |
| Ora Opt    | `oraopt` | `r-oraopt`               |
| Verde      | `verde`  | `r-verde`                |
| Cuib       | `cuib`   | `r-cuib`                 |
| Foaie      | `foaie`  | `r-foaie`                |

`RestaurantPlaceholderImage` (in `Views/Components/RestaurantCardView.swift`)
calls `UIImage(named:)` for that asset. If it exists, the photo is used
(`scaledToFill`, clipped); if not, the gradient placeholder is shown. So simply
dropping the image sets in is enough — nothing else to change.

### Asset guidance
- Provide @2x and @3x, or a single high-res universal image.
- Favor warm, low-light, candlelit interiors and plated food — the palette the
  whole app is tuned around.
- Hero/detail images are shown large (≈390×354 pt); list thumbnails are small
  (≈54–62 pt). One well-cropped landscape image per venue works for both.
- The "A look inside" gallery on the Detail screen currently uses abstract warm
  gradients (`galleryGradients`). Replace with 3–4 real photos per venue when a
  per-venue gallery asset list is introduced.
