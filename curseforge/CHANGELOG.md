# 0.1.13

- Lighter CPU: 48 cast segments, cast ticker only while casting, skip unchanged cursor/range updates.

# 0.1.12

- Yard numbers sit above the cursor ring.

# 0.1.11

- Range ring sits inside the cursor ring. Yard numbers sit outside. Cast progress uses CursorRing cast segments.

# 0.1.10

- Ring.lua starts itself like CursorRing (own events). Uses CursorRing ring.tga. Frame is anchored at screen center first so it stays visible if OnUpdate fails. enabled is forced on.

# 0.1.9

- Cursor follow is a direct port of CursorRing: UIParent, GetRect, scale divide, SetTexture(..., CLAMP). No WorldFrame, no pcall on the cursor math.

# 0.1.8

- Pin the ring to WorldFrame in raw cursor pixels so camelot secret-values cannot hide it. Visible fallback square if ring.tga fails. Errors print in chat.

# 0.1.7

- Cursor ring follows the mouse the same way as CursorRing (raw cursor math, ring.tga + CLAMP). Class color by default, or pick a custom color in options.

# 0.1.6

- Language option: Auto follows the game client, or pick any of the 11 languages.

# 0.1.5

- Credits live on the Info tab (About, commands, site and Discord), like Forever Rotation.

# 0.1.4

- Interface follows the game client language automatically (11 languages, English fallback). No manual language setting.

# 0.1.3

- The cursor ring follows the mouse again, with the range circle around it. Camelot was hiding the old Blizzard texture and breaking cursor math.

# 0.1.2

- Minimap button opens the options. Drag to move. Right-click hides the rings.

# 0.1.1

- Addon list icon: gold cursor ring with a cyan range ring around it.

# 0.1.0

- First build. Cursor ring plus a range ring around it. Options match Forever Rotation. Not on CurseForge yet.
