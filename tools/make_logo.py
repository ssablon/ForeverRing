# -*- coding: utf-8 -*-
"""Build images/logo.tga — gold cursor ring + cyan range ring."""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SIZE = 128
GOLD = (212, 160, 23, 255)
CYAN = (102, 204, 255, 255)
BG = (18, 16, 12, 255)

out = Path(__file__).resolve().parents[1] / "images" / "logo.tga"
img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)
cx = cy = SIZE / 2

draw.rounded_rectangle((4, 4, SIZE - 5, SIZE - 5), radius=22, fill=BG)

def ring(color, radius, width, blur=0):
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    box = (cx - radius, cy - radius, cx + radius, cy + radius)
    d.ellipse(box, outline=color, width=width)
    if blur:
        layer = layer.filter(ImageFilter.GaussianBlur(blur))
    return layer

img = Image.alpha_composite(img, ring(CYAN, 46, 10, 1.2))
img = Image.alpha_composite(img, ring(GOLD, 28, 8, 0.6))
dot = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
ImageDraw.Draw(dot).ellipse((cx - 6, cy - 6, cx + 6, cy + 6), fill=GOLD)
img = Image.alpha_composite(img, dot)

out.parent.mkdir(parents=True, exist_ok=True)
img.save(out, format="TGA")
print("wrote", out, out.stat().st_size)
