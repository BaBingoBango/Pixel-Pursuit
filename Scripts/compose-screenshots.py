#!/usr/bin/env python3
"""Lay out App Store screenshots for Pixel Pursuit.

Each capture is framed on a near-black canvas with a red Roboto Mono caption in the
style of the game's mission interface, at the 13-inch iPad size (2732x2048).

Usage:
    python3 Scripts/compose-screenshots.py <manifest.json> <output dir>

The manifest is a JSON list of {"image": "path.png", "caption": "TEXT"} entries, in
App Store order. Output files are numbered to keep that order. An entry without a
caption is passed through as-is, just fitted to the canvas size if it isn't already.
"""

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

CANVAS = (2732, 2048)
BACKGROUND = (6, 6, 6)
RED = (255, 69, 58)  # SwiftUI's .red in dark mode
MARGIN_X = 110
MARGIN_TOP = 90
MARGIN_BOTTOM = 84
CAPTION_SIZE = 84
CAPTION_GAP = 44
BORDER = 4

ROOT = Path(__file__).resolve().parent.parent
FONT_PATH = ROOT / "Pixel Pursuit" / "Fonts" / "RobotoMono.ttf"
LOGO_PATH = ROOT / "Pixel Pursuit" / "Assets.xcassets" / "IDDA logo.imageset" / "IDDA logo.png"


def tinted_logo(height: int) -> Image.Image:
    """The I.D.D.A. seal in solid red, like the HUD draws it."""
    logo = Image.open(LOGO_PATH).convert("RGBA")
    alpha = logo.getchannel("A").resize((height, height), Image.LANCZOS)
    tinted = Image.new("RGBA", (height, height), RED + (255,))
    tinted.putalpha(alpha)
    return tinted


def wrap(text: str, font: ImageFont.FreeTypeFont, max_width: int) -> list[str]:
    words, lines, current = text.split(), [], ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if font.getlength(candidate) <= max_width or not current:
            current = candidate
        else:
            lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def compose(capture: Path, caption: str, output: Path) -> None:
    canvas = Image.new("RGB", CANVAS, BACKGROUND)
    draw = ImageDraw.Draw(canvas)
    font = ImageFont.truetype(str(FONT_PATH), CAPTION_SIZE)

    logo_size = int(CAPTION_SIZE * 1.25)
    logo = tinted_logo(logo_size)
    text_x = MARGIN_X + logo_size + 36
    lines = wrap(caption.upper(), font, CANVAS[0] - text_x - MARGIN_X)
    line_height = int(CAPTION_SIZE * 1.2)
    caption_height = max(logo_size, line_height * len(lines))

    canvas.paste(logo, (MARGIN_X, MARGIN_TOP + (caption_height - logo_size) // 2), logo)
    text_y = MARGIN_TOP + (caption_height - line_height * len(lines)) // 2
    for line in lines:
        draw.text((text_x, text_y), line, font=font, fill=RED, stroke_width=2, stroke_fill=RED)
        text_y += line_height

    # Fit the capture under the caption, keeping its aspect ratio, inside a thin red frame.
    top = MARGIN_TOP + caption_height + CAPTION_GAP
    available = (CANVAS[0] - 2 * MARGIN_X - 2 * BORDER, CANVAS[1] - top - MARGIN_BOTTOM - 2 * BORDER)
    shot = Image.open(capture).convert("RGB")
    scale = min(available[0] / shot.width, available[1] / shot.height)
    size = (round(shot.width * scale), round(shot.height * scale))
    shot = shot.resize(size, Image.LANCZOS)
    x = (CANVAS[0] - size[0]) // 2
    y = top + BORDER
    draw.rectangle([x - BORDER, y - BORDER, x + size[0] + BORDER - 1, y + size[1] + BORDER - 1], fill=RED)
    canvas.paste(shot, (x, y))

    canvas.save(output, "PNG", optimize=True)


def passthrough(capture: Path, output: Path) -> None:
    """Save a capture unframed, letterboxed onto the canvas only if its size differs."""
    shot = Image.open(capture).convert("RGB")
    if shot.size != CANVAS:
        scale = min(CANVAS[0] / shot.width, CANVAS[1] / shot.height)
        shot = shot.resize((round(shot.width * scale), round(shot.height * scale)), Image.LANCZOS)
        canvas = Image.new("RGB", CANVAS, BACKGROUND)
        canvas.paste(shot, ((CANVAS[0] - shot.width) // 2, (CANVAS[1] - shot.height) // 2))
        shot = canvas
    shot.save(output, "PNG", optimize=True)


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    manifest = json.loads(Path(sys.argv[1]).read_text())
    out_dir = Path(sys.argv[2])
    out_dir.mkdir(parents=True, exist_ok=True)
    for index, entry in enumerate(manifest, start=1):
        output = out_dir / f"{index:02d} {Path(entry['image']).stem}.png"
        if entry.get("caption"):
            compose(Path(entry["image"]), entry["caption"], output)
        else:
            passthrough(Path(entry["image"]), output)
        print(f"wrote {output}")


if __name__ == "__main__":
    main()
