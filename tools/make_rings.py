# -*- coding: utf-8 -*-
"""White ring textures so SetVertexColor can tint them in-game."""
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 256
CX = CY = SIZE / 2
OUT = Path(__file__).resolve().parents[1] / "images"
WHITE = (255, 255, 255, 255)


def donut(outer, inner, dot=0):
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((CX - outer, CY - outer, CX + outer, CY + outer), fill=WHITE)
    d.ellipse((CX - inner, CY - inner, CX + inner, CY + inner), fill=(0, 0, 0, 0))
    if dot > 0:
        d.ellipse((CX - dot, CY - dot, CX + dot, CY + dot), fill=WHITE)
    return img


def save(img, name):
    path = OUT / name
    img.save(path, format="TGA")
    print("wrote", path, path.stat().st_size)


OUT.mkdir(parents=True, exist_ok=True)
save(donut(118, 92, 7), "ring.tga")
save(donut(122, 108, 0), "thin_ring.tga")
