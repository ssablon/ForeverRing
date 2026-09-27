# -*- coding: utf-8 -*-
"""Build curseforge/logo-512.png — gold cursor ring + cyan range ring."""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SIZE = 512
GOLD = (212, 160, 23, 255)
CYAN = (102, 204, 255, 255)
BG = (18, 16, 12, 255)

out = Path(__file__).with_name("logo-512.png")
img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)
cx = cy = SIZE / 2
draw.rounded_rectangle((16, 16, SIZE - 17, SIZE - 17), radius=88, fill=BG)


def ring(color, radius, width, blur=0):
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    box = (cx - radius, cy - radius, cx + radius, cy + radius)
    d.ellipse(box, outline=color, width=width)
    if blur:
        layer = layer.filter(ImageFilter.GaussianBlur(blur))
    return layer


img = Image.alpha_composite(img, ring(CYAN, 184, 40, 2.4))
img = Image.alpha_composite(img, ring(GOLD, 112, 32, 1.2))
dot = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
ImageDraw.Draw(dot).ellipse((cx - 24, cy - 24, cx + 24, cy + 24), fill=GOLD)
img = Image.alpha_composite(img, dot)
img.save(out, format="PNG")
print("wrote", out, out.stat().st_size)
