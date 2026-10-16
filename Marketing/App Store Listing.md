# Pixel Pursuit: App Store Connect worksheet

Everything below is paste-ready. Character limits are noted where App Store Connect enforces them; the
script at the bottom of this file was used to check them. Items marked **YOU** need something only you
can supply.

## App record

| Field | Value |
| --- | --- |
| Platform | iOS (iPad only) |
| Name (30) | Pixel Pursuit |
| Primary language | English (U.S.) |
| Bundle ID | Ethan-Marshall.Pixel-Pursuit |
| SKU | pixel-pursuit |
| User access | Full access |

If the name is already taken by another developer, fall back to **Pixel Pursuit: AR Forensics** (27).

## Version information (1.0)

**Subtitle (30):** Solve a cybercrime in AR

Alternates: "Computer forensics, in AR" / "An AR detective story"

**Promotional text (170):**

> Scan your floor, step into a suspect's office and hard drive, and follow the clues to her secret server. A WWDC23 Swift Student Challenge winner, rebuilt for iPadOS 26.

**Description (4000):**

> The I.D.D.A. needs YOU.
>
> Pixel Pursuit is a short augmented-reality detective story. Amanda Becker is suspected of hacking the International Digital Defense Authority and walking off with its secrets. Her hard drive is encrypted, her office is full of sticky notes, and her search history is a mess. Agent W will talk you through the rest.
>
> HOW IT PLAYS
> • Point your iPad at some open floor and tap to place the scene. Everything happens life-size, in your room.
> • Walk around Amanda's home office and find the password she thought was well hidden.
> • Step inside her hard drive: four tables, four leads. Walk up to one to open it.
> • Piece together the address and passcode of her secret server, break in, and deliver your verdict.
>
> A run takes about ten minutes. Turn your sound on: there is Debussy, a little retro funk, and a lot of static.
>
> GOOD TO KNOW
> • Made for iPad. You'll want roughly two by two meters of floor space, and decent light helps the room scan.
> • Tap MOVE SCENE at any time to put the scene somewhere else.
> • No accounts, no ads, no analytics, nothing collected. The camera is used only to show the AR scene, on your iPad.
>
> Pixel Pursuit won Apple's WWDC23 Swift Student Challenge as a Swift Playgrounds project. This is that game, rebuilt for iPadOS 26 with SwiftUI, Swift 6, RealityKit, and ARKit. It's open source: github.com/BaBingoBango/Pixel-Pursuit

**Keywords (100, comma-separated, no spaces):**

> augmented reality,AR,detective,mystery,forensics,cybercrime,hacker,puzzle,investigation,story

Don't repeat words from the name or subtitle; App Store Connect already indexes those.

**Support URL:** https://github.com/BaBingoBango/Pixel-Pursuit/issues
**Marketing URL (optional):** https://github.com/BaBingoBango/Pixel-Pursuit
**Privacy Policy URL:** https://github.com/BaBingoBango/Pixel-Pursuit/blob/main/PRIVACY.md

**What's New:** not shown for a first release; leave blank.

**Copyright:** 2026 Ethan Marshall

**Version:** 1.0 · **Build:** 2 (the one Xcode uploaded)

## Screenshots

iPad 13-inch display, in this order, from `Marketing/Screenshots/Composed/`:

1. `01 IMG_1778.png` Investigate a cybercrime in augmented reality
2. `02 IMG_1779.png` Discover clues
3. `03 IMG_1780.png` Search through files
4. `04 IMG_1781.png` Find the perp's story
5. `05 title.png`
6. `06 warning.png`

No other device sizes are required for an iPad-only app. An app preview (15 to 30 s screen recording of placing the scene) is optional and would go first.

## Category and availability

| Field | Value |
| --- | --- |
| Primary category | Games |
| Subcategories | Adventure, Puzzle |
| Secondary category | none (Education is defensible if you want one) |
| Price | Free |
| Availability | All countries or regions |
| Apple Vision Pro | Off (requires ARKit; already unchecked) |
| Mac | Not offered; the build opts out of "Designed for iPad" on Mac |
| Pre-order | No |

## Age rating questionnaire

Answer **None / No** throughout, which rates the app **4+**:

- Violence (cartoon, realistic, prolonged), horror, medical, alcohol/tobacco/drugs, gambling, contests: None.
- Mature or suggestive themes, profanity or crude humor: None. The only borderline lines are Amanda's search history ("tips for stupid boss", "how to get over psycho ex") and a to-do item that says "download tinder". If you'd rather be conservative, pick **Infrequent/Mild** for profanity or crude humor, which makes it 9+.
- Unrestricted web access, user-generated content, messaging, parental controls, loot boxes, advertising: No.

## App Privacy

- Data collection: **No, we do not collect data from this app.** The label will read "Data Not Collected".
- Privacy policy URL: as above.
- Tracking: No. There is no network access at all.

## Accessibility (optional claims)

Only claim what the whole game honors. Safe to check: **Dark Interface** (the game is always dark) and **Sufficient Contrast** (the red on black measures about 6:1). Don't claim VoiceOver or Larger Text: the buttons and text fields are labeled, but the AR scene itself isn't navigable with VoiceOver, and the type is fixed-size by design.

## App Review information

| Field | Value |
| --- | --- |
| Sign-in required | No |
| Contact first name / last name / phone / email | **YOU** |

**Notes (paste as written):**

> Pixel Pursuit is an augmented-reality game and needs a physical iPad with ARKit; it cannot be exercised in the Simulator. Please allow camera access, hold the iPad in landscape, and have about two by two meters of open floor. A full run takes about ten minutes.
>
> Flow and puzzle answers:
> 1. Tap the power button, then ACTIVATE SYSTEM.
> 2. When the floor scan completes, point at open floor and tap to place the scene. MOVE SCENE (bottom left) re-places it.
> 3. Tap "tap to advance text" until "search amanda's office" appears, then tap it.
> 4. In the office, tap "decrypt disk" and enter the password: mike4neva
> 5. Tap through to "search amanda's disk". Walk within about a meter of each small table to open it; the computer table offers "access server".
> 6. Server address: nothingtoseehere.net — Passcode: 4231
> 7. Tap "enter amanda's server", then "exit server" to reach the verdict screen. Any verdict ends the game.
>
> There are no accounts, no network features, no purchases, and no data collection. Export compliance is declared in the Info.plist (no non-exempt encryption).

Attachment (optional): a short screen recording of a full run helps if a reviewer can't find floor space.

## Content rights

The form asks whether the app contains third-party content. **YOU**: confirm the sources and licenses of `Clair de Lune.mp3`, `Retro Funk.mp3`, and `static sound effect.mp3` (Debussy's composition is public domain, but a particular recording may not be), and that the photos used in the scenes are yours. Roboto Mono is under the SIL Open Font License, and the Reality Composer library models are licensed for use in apps.

## Pricing, tax, and agreements

Free apps only need the Free Apps agreement, already accepted for any developer account that has published. If App Store Connect shows a pending **Paid Apps** agreement, it can be ignored for a free app.

## Checking the limits

```bash
python3 - <<'EOF'
fields = {
    "name": "Pixel Pursuit",
    "subtitle": "Solve a cybercrime in AR",
    "promo": "Scan your floor, step into a suspect's office and hard drive, and follow the clues to her secret server. A WWDC23 Swift Student Challenge winner, rebuilt for iPadOS 26.",
    "keywords": "augmented reality,AR,detective,mystery,forensics,cybercrime,hacker,puzzle,investigation,story",
}
limits = {"name": 30, "subtitle": 30, "promo": 170, "keywords": 100}
for key, text in fields.items():
    print(f"{key:9s} {len(text):3d}/{limits[key]}  {'ok' if len(text) <= limits[key] else 'TOO LONG'}")
EOF
```
