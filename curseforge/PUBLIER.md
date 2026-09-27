# Publish Forever Mouse Ring-Range on CurseForge

The API token cannot create a project. It only uploads a zip after the project exists.

## Create the project (once)

https://authors.curseforge.com/#/projects/create/general

Values: `FIELDS.txt`. Logo: `logo-512.png`. Description: paste `DESCRIPTION.md` (Markdown).

Do not put "WoW" in the project name. Wait for approval if asked. The numeric ID is on the project page (About Project). Public slug: `forever-mouse-ring-range`.

## Zip and upload

```
python curseforge/pack.py
CF_TOKEN=... CF_PROJECT_ID=1714166 python curseforge/upload.py
```

Output zip: `F:\Github\addons\wow\ForeverRing-<version>.zip`  
Root folder inside the zip: `ForeverRing`

`gameVersions` = `[17053]` (CurseForge name **1.60.1**).

After the first file is accepted, put the ID in both TOC files:

```
## X-Curse-Project-ID: 1714166
```
