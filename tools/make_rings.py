# -*- coding: utf-8 -*-
"""White hard-edge rings. Soft alpha + class tint looks like a dark halo (mage)."""
from pathlib import Path

from PIL import Image

SIZE = 256
CX = CY = (SIZE - 1) / 2
ROOT = Path(__file__).resolve().parents[1]
WHITE = (255, 255, 255, 255)
CLEAR = (255, 255, 255, 0)


def donut(outer, inner, dot=0):
	img = Image.new("RGBA", (SIZE, SIZE), CLEAR)
	px = img.load()
	outer2 = outer * outer
	inner2 = inner * inner
	dot2 = dot * dot
	for y in range(SIZE):
		dy = (y + 0.5) - CY
		dy2 = dy * dy
		for x in range(SIZE):
			dx = (x + 0.5) - CX
			r2 = dx * dx + dy2
			if (inner2 <= r2 <= outer2) or (dot > 0 and r2 <= dot2):
				px[x, y] = WHITE
	return img


def save(img, name):
	for folder in (ROOT, ROOT / "images"):
		folder.mkdir(parents=True, exist_ok=True)
		path = folder / name
		img.save(path, format="TGA")
		print("wrote", path, path.stat().st_size)


# One stroke, no center dot. A thick donut reads as two circles on mage.
save(donut(118, 104, 0), "ring.tga")
save(donut(122, 108, 0), "thin_ring.tga")
