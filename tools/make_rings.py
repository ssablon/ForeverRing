# -*- coding: utf-8 -*-
"""Bold white rings. Thick hard strokes stay visible after SetVertexColor."""
from pathlib import Path

from PIL import Image

SIZE = 256
CX = CY = (SIZE - 1) / 2
ROOT = Path(__file__).resolve().parents[1]
WHITE = (255, 255, 255, 255)
CLEAR = (255, 255, 255, 0)
STROKE = 16
CLASS_OUTER = 92
CLASS_INNER = CLASS_OUTER - STROKE


def donut(outer, inner):
	img = Image.new("RGBA", (SIZE, SIZE), CLEAR)
	px = img.load()
	outer2 = outer * outer
	inner2 = inner * inner
	for y in range(SIZE):
		dy = (y + 0.5) - CY
		dy2 = dy * dy
		for x in range(SIZE):
			dx = (x + 0.5) - CX
			r2 = dx * dx + dy2
			if inner2 <= r2 <= outer2:
				px[x, y] = WHITE
	return img


def save(img, name):
	for folder in (ROOT, ROOT / "images"):
		folder.mkdir(parents=True, exist_ok=True)
		path = folder / name
		img.save(path, format="TGA")
		print("wrote", path, path.stat().st_size)


save(donut(CLASS_OUTER, CLASS_INNER), "ring.tga")
save(donut(124, 98), "thin_ring.tga")
