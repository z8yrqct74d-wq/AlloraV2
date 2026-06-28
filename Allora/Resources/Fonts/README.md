# Fonts

The Allora design uses two type families:

| Role            | Family            | Used for                                  |
|-----------------|-------------------|-------------------------------------------|
| Serif / display | **Newsreader**    | Headlines, restaurant names, editorial voice |
| Sans / UI       | **Hanken Grotesk**| Labels, body, buttons, meta               |

Both are free (SIL Open Font License):

- Newsreader — https://fonts.google.com/specimen/Newsreader
- Hanken Grotesk — https://fonts.google.com/specimen/Hanken+Grotesk

## How to wire them in (drop-in)

1. Download the families and add the `.ttf` files to this folder, then drag
   them into the Xcode project (check **"Add to target: Allora"**).
2. Add an **`UIAppFonts`** array to the target's Info settings (Build Settings →
   Info, or an `Info.plist`) listing each file name, e.g.:

   ```xml
   <key>UIAppFonts</key>
   <array>
     <string>Newsreader-Light.ttf</string>
     <string>Newsreader-Regular.ttf</string>
     <string>Newsreader-Medium.ttf</string>
     <string>Newsreader-SemiBold.ttf</string>
     <string>Newsreader-Italic.ttf</string>
     <string>HankenGrotesk-Regular.ttf</string>
     <string>HankenGrotesk-Medium.ttf</string>
     <string>HankenGrotesk-SemiBold.ttf</string>
     <string>HankenGrotesk-Bold.ttf</string>
     <string>HankenGrotesk-ExtraBold.ttf</string>
   </array>
   ```

3. The PostScript names referenced in `DesignSystem.swift` (`AlloraFont`) are:
   `Newsreader-Light/Regular/Medium/SemiBold/Italic` and
   `HankenGrotesk-Regular/Medium/SemiBold/Bold/ExtraBold`. Verify them in Font
   Book if a weight doesn't apply, and adjust `AlloraFont` accordingly.

## Until then

`AlloraFont` calls `Font.custom(...)`, which **falls back to the system font**
when a family isn't installed. The app builds and runs today on San Francisco;
adding the fonts is what takes it from "good" to "on-brand".
