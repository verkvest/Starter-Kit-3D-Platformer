#!/usr/bin/env python3
"""Generate Mallowskip's original app icon, splash, and store sizes.

The mark is a cream sprout on a sky hill with mallow flowers. It does not
reuse Kenney's green character.
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FONT = ROOT / "fonts" / "lilita_one_regular.ttf"

SKY_TOP = (126, 200, 234)
SKY_BOTTOM = (74, 163, 216)
HILL = (61, 154, 76)
HILL_DARK = (31, 107, 50)
CREAM = (255, 246, 228)
INK = (29, 58, 36)
PETAL = (244, 154, 193)
PETAL_DEEP = (232, 120, 168)
GOLD = (244, 211, 94)
LEAF = (90, 184, 96)

IOS_SIZES = {
    "settings_58x58": 58,
    "settings_87x87": 87,
    "notification_40x40": 40,
    "notification_60x60": 60,
    "notification_76x76": 76,
    "notification_114x114": 114,
    "spotlight_80x80": 80,
    "spotlight_120x120": 120,
    "iphone_120x120": 120,
    "iphone_180x180": 180,
    "ipad_167x167": 167,
    "ipad_152x152": 152,
    "ios_128x128": 128,
    "ios_192x192": 192,
    "ios_136x136": 136,
    "app_store_1024x1024": 1024,
    "icon_1024x1024": 1024,
}


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def vertical_gradient(size, top, bottom):
    image = Image.new("RGB", (size, size))
    draw = ImageDraw.Draw(image)
    for y in range(size):
        draw.line([(0, y), (size, y)], fill=lerp(top, bottom, y / max(1, size - 1)))
    return image


def flower(draw, cx, cy, scale, fill=True):
    petal_r = 18 * scale
    center_r = 11 * scale
    for i in range(5):
        ang = -3.14159 / 2 + i * (2 * 3.14159 / 5)
        px = cx + int(26 * scale * __import__("math").cos(ang))
        py = cy + int(26 * scale * __import__("math").sin(ang))
        box = [px - petal_r, py - petal_r, px + petal_r, py + petal_r]
        draw.ellipse(box, fill=PETAL if fill else None, outline=None if fill else (255, 255, 255, 255))
    draw.ellipse(
        [cx - center_r, cy - center_r, cx + center_r, cy + center_r],
        fill=GOLD if fill else (255, 255, 255, 255),
    )


def sprout(draw, cx, cy, scale, fill_body, fill_leaf, fill_ink):
    body_w = 150 * scale
    body_h = 130 * scale
    box = [cx - body_w, cy - body_h * 0.85, cx + body_w, cy + body_h]
    draw.ellipse(box, fill=fill_body)
    stem_w = 10 * scale
    stem_top = cy - body_h * 0.85 - 70 * scale
    draw.rectangle([cx - stem_w, stem_top, cx + stem_w, cy - body_h * 0.35], fill=fill_leaf)
    leaf = 36 * scale
    draw.ellipse([cx - stem_w - leaf * 1.7, stem_top + 8 * scale, cx - stem_w, stem_top + leaf], fill=fill_leaf)
    draw.ellipse([cx + stem_w, stem_top + 18 * scale, cx + stem_w + leaf * 1.5, stem_top + leaf * 0.95], fill=fill_leaf)
    eye_r = 16 * scale
    eye_y = cy - 8 * scale
    for dx in (-48 * scale, 48 * scale):
        draw.ellipse([cx + dx - eye_r, eye_y - eye_r, cx + dx + eye_r, eye_y + eye_r], fill=fill_ink)
        glint = 5 * scale
        draw.ellipse(
            [cx + dx - eye_r * 0.2, eye_y - eye_r * 0.45, cx + dx - eye_r * 0.2 + glint, eye_y - eye_r * 0.45 + glint],
            fill=(255, 255, 255, 255) if isinstance(fill_body, tuple) and len(fill_body) == 4 else (255, 255, 255),
        )
    smile_w = 28 * scale
    smile_h = 16 * scale
    draw.arc(
        [cx - smile_w, cy + 28 * scale, cx + smile_w, cy + 28 * scale + smile_h * 2],
        20,
        160,
        fill=fill_ink,
        width=max(2, int(6 * scale)),
    )


def master(size, kind):
    """kind: full | foreground | background | mono"""
    if kind == "mono":
        image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(image)
        scale = size / 1024
        sprout(draw, size * 0.5, size * 0.56, scale * 1.15, (255, 255, 255, 255), (255, 255, 255, 255), (0, 0, 0, 0))
        return image

    if kind == "foreground":
        image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(image)
        scale = (size / 1024) * 0.62
        sprout(draw, size * 0.5, size * 0.56, scale, CREAM + (255,), LEAF + (255,), INK + (255,))
        flower(draw, size * 0.30, size * 0.70, scale * 0.7)
        flower(draw, size * 0.72, size * 0.66, scale * 0.55)
        return image

    base = vertical_gradient(size, SKY_TOP, SKY_BOTTOM).convert("RGBA")
    draw = ImageDraw.Draw(base)
    draw.ellipse([size * -0.1, size * 0.62, size * 1.1, size * 1.25], fill=HILL + (255,))
    draw.ellipse([size * 0.55, size * 0.70, size * 1.2, size * 1.15], fill=HILL_DARK + (255,))
    if kind == "background":
        return base
    scale = size / 1024
    sprout(draw, size * 0.50, size * 0.58, scale, CREAM + (255,), LEAF + (255,), INK + (255,))
    flower(draw, size * 0.22, size * 0.74, scale * 0.85)
    flower(draw, size * 0.78, size * 0.70, scale * 0.7)
    flower(draw, size * 0.64, size * 0.80, scale * 0.5)
    return base


def save_rgb(image, path):
    image.convert("RGB").save(path, "PNG", optimize=True)


def save_rgba(image, path):
    image.save(path, "PNG", optimize=True)


def main():
    ios_dir = ROOT / "icons" / "ios"
    android_dir = ROOT / "icons" / "android"
    ios_dir.mkdir(parents=True, exist_ok=True)
    android_dir.mkdir(parents=True, exist_ok=True)

    full = master(1024, "full")
    store = full.convert("RGB")
    if store.mode != "RGB":
        raise SystemExit("App Store icon must be opaque RGB")
    for name, side in IOS_SIZES.items():
        resized = store.resize((side, side), Image.Resampling.LANCZOS)
        resized.save(ios_dir / f"{name}.png", "PNG", optimize=True)
    store.resize((256, 256), Image.Resampling.LANCZOS).save(ROOT / "icon.png", "PNG", optimize=True)

    save_rgba(master(432, "foreground"), android_dir / "foreground_432.png")
    save_rgb(master(432, "background"), android_dir / "background_432.png")
    save_rgba(master(432, "mono"), android_dir / "monochrome_432.png")
    save_rgb(master(192, "full"), android_dir / "main_192.png")

    splash = Image.new("RGB", (1920, 1080))
    draw = ImageDraw.Draw(splash)
    for y in range(1080):
        draw.line([(0, y), (1919, y)], fill=lerp(SKY_TOP, SKY_BOTTOM, y / 1079))
    draw.ellipse([-80, 620, 2000, 1400], fill=HILL)
    draw.ellipse([1100, 760, 2100, 1300], fill=HILL_DARK)
    mark = master(900, "full").convert("RGBA")
    splash.paste(mark, (80, 140), mark)
    font = ImageFont.truetype(str(FONT), 168)
    small = ImageFont.truetype(str(FONT), 54)
    draw.text((980, 390), "Mallowskip", font=font, fill=CREAM, stroke_width=10, stroke_fill=HILL_DARK)
    draw.text((990, 590), "A little hop across the knoll", font=small, fill=CREAM, stroke_width=4, stroke_fill=HILL_DARK)
    splash.save(ROOT / "splash-screen.png", "PNG", optimize=True)
    print("icons written")


if __name__ == "__main__":
    main()
