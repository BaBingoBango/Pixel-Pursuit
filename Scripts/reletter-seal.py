#!/usr/bin/env python3
"""Re-letter the lower arc of the I.D.D.A. seal.

The seal's ring carries two arcs of Optima capitals. This script erases the lower arc and sets a new
phrase in its place, in both the raster used by the app and the traced outlines used by the app icon:

    Pixel Pursuit/Assets.xcassets/IDDA logo.imageset/IDDA logo.png
    Pixel Pursuit/AppIcon.icon/Assets/Ring.svg

Usage:
    python3 Scripts/reletter-seal.py "CYBER CRIMES INVESTIGATION UNIT" [--preview DIR]

The upper arc, the two separator dots and the ring lines are left untouched; the new letters copy the
cap height, stroke weight, tracking and arc span of the lettering that was there. Needs Pillow, numpy,
fontTools and (for the icon) potracer: `/usr/bin/python3 -m venv .venv && .venv/bin/pip install
pillow numpy fonttools potracer`.
"""

from __future__ import annotations

import argparse
import math
import re
import statistics
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
PNG_PATH = ROOT / "Pixel Pursuit" / "Assets.xcassets" / "IDDA logo.imageset" / "IDDA logo.png"
SVG_PATH = ROOT / "Pixel Pursuit" / "AppIcon.icon" / "Assets" / "Ring.svg"
FONT_PATH = "/System/Library/Fonts/Optima.ttc"  # index 0 is Optima Regular

# Angles are in image coordinates: 0° points right, 90° points down (the bottom of the seal).
LOWER_ARC = (13.0, 167.0)  # the lower arc between the two separator dots, dots excluded
ICON_CENTER, ICON_OUTER_RADIUS = 512.0, 384.0  # Ring.svg's outer ring, in its 1024-point canvas


def polar(alpha: np.ndarray):
    """Radius and angle (degrees) of every pixel, plus the centre, for a square seal that fills its canvas."""
    h, w = alpha.shape
    cx, cy = (w - 1) / 2, (h - 1) / 2
    yy, xx = np.mgrid[0:h, 0:w]
    radius = np.hypot(xx - cx, yy - cy)
    angle = np.degrees(np.arctan2(yy - cy, xx - cx)) % 360
    return radius, angle, (cx, cy)


def ring_band(ink: np.ndarray, radius: np.ndarray, outer_radius: float):
    """The radii of the ring lines' facing edges: the band of clear space the lettering sits in."""
    counts = np.bincount(np.round(radius[ink]).astype(int), minlength=int(radius.max()) + 2)
    fill = counts / np.maximum(2 * np.pi * np.arange(len(counts)), 1)
    solid = np.nonzero(fill > 0.95)[0]
    solid = solid[solid > outer_radius * 0.6]  # ignore the artwork in the middle
    breaks = np.nonzero(np.diff(solid) > 1)[0]
    if len(breaks) == 0:
        sys.exit("Could not find two ring lines in the seal.")
    inner_line_end, outer_line_start = solid[breaks[-1]], solid[breaks[-1] + 1]
    return int(inner_line_end), int(outer_line_start)


def arc_runs(ink: np.ndarray, center, radius_px: float, angles):
    """Lengths (px) of the ink runs met while walking a circle through the given angles (degrees)."""
    cx, cy = center
    step = 0.005
    thetas = np.arange(angles[0], angles[1], step)
    xs = np.clip(np.round(cx + radius_px * np.cos(np.radians(thetas))).astype(int), 0, ink.shape[1] - 1)
    ys = np.clip(np.round(cy + radius_px * np.sin(np.radians(thetas))).astype(int), 0, ink.shape[0] - 1)
    samples = ink[ys, xs]
    runs, count = [], 0
    for s in samples:
        if s:
            count += 1
        elif count:
            runs.append(count * math.radians(step) * radius_px)
            count = 0
    return runs


def measure_lettering(ink, radius, angle, center, band):
    """Cap height, baseline radius, stem width and span of the lower arc's existing lettering."""
    inner, outer = band
    in_band = (radius > inner + 4) & (radius < outer - 4)
    lower = ink & in_band & (angle > LOWER_ARC[0]) & (angle < LOWER_ARC[1])
    # The letters hang from the outer edge: their baseline is the largest radius they reach.
    middle = lower & (angle > 80) & (angle < 100)  # a few letters near the bottom, no diacritics
    radii = radius[middle]
    cap_top, baseline = float(np.percentile(radii, 0.5)), float(np.percentile(radii, 99.5))
    angles = angle[lower]
    span = (float(angles.min()), float(angles.max()))
    # Vertical stems, read at mid cap height on the upper arc (which stays): the median short run.
    mid = (cap_top + baseline) / 2
    runs = arc_runs(ink, center, mid, (176, 364))
    stems = [r for r in runs if 8 < r < 0.35 * (baseline - cap_top)]
    stem = statistics.median(stems)
    return dict(cap=baseline - cap_top, baseline=baseline, stem=stem, span=span)


def font_matching(cap_px: float, stem_px: float):
    """Optima Regular sized to the cap height, with the outline stroke that reproduces the stem weight."""
    probe = ImageFont.truetype(FONT_PATH, 200, index=0)
    box = probe.getbbox("H")
    size = round(200 * cap_px / (box[3] - box[1]))
    font = ImageFont.truetype(FONT_PATH, size, index=0)
    best = None
    for stroke in range(0, 8):
        canvas = Image.new("L", (size, size * 2), 0)
        ImageDraw.Draw(canvas).text((size // 2, size * 1.5), "I", font=font, fill=255, anchor="ms",
                                    stroke_width=stroke, stroke_fill=255)
        row = np.array(canvas)[int(size * 1.5 - cap_px / 2)] > 127
        width = int(row.sum())
        if best is None or abs(width - stem_px) < abs(best[1] - stem_px):
            best = (stroke, width)
    return font, size, best[0]


def layout(text: str, font, stroke: int, metrics, tracking_reference: str | None):
    """Angular position of each glyph so the phrase is centred on the bottom with the original tracking."""
    cap, baseline = metrics["cap"], metrics["baseline"]
    mid_radius = baseline - cap / 2
    advances = [font.getlength(ch) for ch in text]
    if tracking_reference:
        # Reproduce the designer's letter spacing: what the old phrase needed to fill its arc.
        old_span_px = math.radians(metrics["span"][1] - metrics["span"][0]) * mid_radius
        natural = sum(font.getlength(ch) for ch in tracking_reference) + 2 * stroke * len(tracking_reference)
        tracking = (old_span_px - natural) / (len(tracking_reference) - 1)
    else:
        tracking = 0
    widths = [a + 2 * stroke for a in advances]
    total = sum(widths) + tracking * (len(text) - 1)
    positions, x = [], 0.0
    for w in widths:
        positions.append(x + w / 2)
        x += w + tracking
    # Earlier letters sit at larger angles: the phrase reads left to right along the bottom.
    angles = [90 + math.degrees((total / 2 - p) / mid_radius) for p in positions]
    return angles, tracking, total / mid_radius


def render_lower_arc(text, font, size, stroke, metrics, angles, shape, center):
    """A mask of the new lettering, each glyph rotated to stand on the lower arc."""
    cx, cy = center
    mask = Image.new("L", (shape[1], shape[0]), 0)
    canvas_w, canvas_h = size * 2, size * 2
    baseline_y = int(size * 1.4)
    for ch, theta in zip(text, angles):
        if ch == " ":
            continue
        glyph = Image.new("L", (canvas_w, canvas_h), 0)
        ImageDraw.Draw(glyph).text((canvas_w / 2, baseline_y), ch, font=font, fill=255, anchor="ms",
                                   stroke_width=stroke, stroke_fill=255)
        # Upright at the bottom (90°); elsewhere turned so the letter's top faces the centre.
        glyph = glyph.rotate(90 - theta, resample=Image.BICUBIC, center=(canvas_w / 2, baseline_y))
        px = cx + metrics["baseline"] * math.cos(math.radians(theta))
        py = cy + metrics["baseline"] * math.sin(math.radians(theta))
        offset = (round(px - canvas_w / 2), round(py - baseline_y))
        mask.paste(combined(mask, glyph, offset), offset)
    return mask


def combined(base: Image.Image, glyph: Image.Image, offset):
    """The glyph combined with whatever the base already holds under it (so overlaps never erase)."""
    region = base.crop((offset[0], offset[1], offset[0] + glyph.width, offset[1] + glyph.height))
    return Image.fromarray(np.maximum(np.array(region), np.array(glyph)))


def reletter_png(text: str, preview: Path | None):
    image = Image.open(PNG_PATH).convert("RGBA")
    rgba = np.array(image)
    alpha = rgba[:, :, 3]
    ink = alpha > 127
    radius, angle, center = polar(alpha)
    band = ring_band(ink, radius, outer_radius=center[0] + 0.5)
    metrics = measure_lettering(ink, radius, angle, center, band)
    font, size, stroke = font_matching(metrics["cap"], metrics["stem"])
    angles, tracking, span = layout(text, font, stroke, metrics, "UNITED NATIONS SECURITY COUNCIL")
    print(f"seal: band r{band[0]}–{band[1]}, cap {metrics['cap']:.0f} px, stem {metrics['stem']:.0f} px, "
          f"old arc {metrics['span'][0]:.1f}°–{metrics['span'][1]:.1f}°")
    print(f"      Optima {size} px, stroke {stroke} px, tracking {tracking / size:.3f} em, "
          f"new arc {math.degrees(span):.1f}° centred on the bottom")
    if angles[0] > LOWER_ARC[1] - 1 or angles[-1] < LOWER_ARC[0] + 1:
        sys.exit("The phrase is too long for the lower arc; pick a shorter one.")

    # Erase the lower arc between the dots, then lay the new letters down in solid black.
    erase = (radius > band[0] + 4) & (radius < band[1] - 4) & (angle > LOWER_ARC[0]) & (angle < LOWER_ARC[1])
    rgba[erase] = (255, 255, 255, 0)
    mask = np.array(render_lower_arc(text, font, size, stroke, metrics, angles, alpha.shape, center))
    drawn = mask > 0
    rgba[drawn, 0:3] = 0
    rgba[:, :, 3] = np.maximum(rgba[:, :, 3], mask)
    result = Image.fromarray(rgba, "RGBA")
    result.save(PNG_PATH, "PNG", optimize=True)
    print(f"wrote {PNG_PATH.relative_to(ROOT)}")

    if preview:
        preview.mkdir(parents=True, exist_ok=True)
        flat = Image.new("RGBA", result.size, (255, 255, 255, 255))
        flat.alpha_composite(result)
        flat.convert("RGB").resize((1200, 1200), Image.LANCZOS).save(preview / "seal.png")
        flat.convert("RGB").crop((700, 2900, 3059, 3759)).save(preview / "seal-lower-arc.png")
    return mask, center


def svg_subpaths(d: str):
    return [s for s in re.split(r"(?=M)", d) if s.strip()]


def subpath_angle(subpath: str):
    numbers = [float(v) for v in re.findall(r"-?\d+\.?\d*", subpath)]
    xs, ys = numbers[0::2], numbers[1::2]
    bx, by = (min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2
    return math.degrees(math.atan2(by - ICON_CENTER, bx - ICON_CENTER)) % 360


def trace_to_icon_paths(mask: np.ndarray, center, scale: float):
    """Outline the lettering mask with potrace and express it in the icon's coordinates."""
    try:
        import potrace
    except ImportError:
        sys.exit("potracer is not installed, so Ring.svg was left alone. Install it and rerun.")
    ys, xs = np.nonzero(mask > 127)
    y0, y1, x0, x1 = ys.min() - 2, ys.max() + 3, xs.min() - 2, xs.max() + 3
    crop = mask[y0:y1, x0:x1] > 127
    bitmap = potrace.Bitmap(~crop)  # potracer reads False as black
    path = bitmap.trace(turdsize=4, alphamax=1.0, opticurve=True, opttolerance=0.2)
    cx, cy = center

    def pt(p):
        x = ICON_CENTER + (p.x + x0 - cx) * scale
        y = ICON_CENTER + (p.y + y0 - cy) * scale
        return f"{x:.2f} {y:.2f}"

    pieces = []
    for curve in path.curves:
        d = [f"M{pt(curve.start_point)}"]
        for segment in curve.segments:
            if segment.is_corner:
                d.append(f"L{pt(segment.c)}L{pt(segment.end_point)}")
            else:
                d.append(f"C{pt(segment.c1)} {pt(segment.c2)} {pt(segment.end_point)}")
        d.append("Z")
        pieces.append("".join(d))
    return pieces


def reletter_svg(mask: np.ndarray, center, seal_outer_radius: float):
    svg = SVG_PATH.read_text()
    paths = re.findall(r'<path [^>]*d="([^"]+)"', svg)
    glyph_path = max(paths, key=len)
    kept = [s for s in svg_subpaths(glyph_path) if not (LOWER_ARC[0] < subpath_angle(s) < LOWER_ARC[1])]
    new = trace_to_icon_paths(mask, center, ICON_OUTER_RADIUS / seal_outer_radius)
    svg = svg.replace(glyph_path, "".join(kept + new))
    SVG_PATH.write_text(svg)
    print(f"wrote {SVG_PATH.relative_to(ROOT)}: kept {len(kept)} outlines, traced {len(new)} new ones")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("text", help="the new phrase for the lower arc, in capitals")
    parser.add_argument("--preview", type=Path, help="directory for preview renders")
    args = parser.parse_args()
    text = args.text.upper()
    mask, center = reletter_png(text, args.preview)
    reletter_svg(mask, center, seal_outer_radius=center[0] + 0.5)


if __name__ == "__main__":
    main()
