> [!NOTE]
> I no longer use this project, so I am archiving this project's repository. I am keeping it here as a reference for the future.

# Minecraft Realms Mapcrafter Renderer

This group of Bash scripts does the following:

1. Downloads the latest Minecraft Realms world if it more recent than the local copy
2. Clones (or updates) and builds the latest copy of Mapcrafter from Github
3. Creates the Mapcrafter configuration file
4. Downloads the Minecraft client for the specified Minecraft version and runs mapcrafter_textures.py to extract textures (runs only for Minecraft versions prior to 1.13)
5. Runs Mapcrafter on the local copy of the Minecraft Realms world to generate an awesome web-based map experience!
---
### Prerequisites
- Bash
- [jq](https://github.com/stedolan/jq)
- python3
---
### Services used
- [Mojang Authentication](https://wiki.vg/Authentication)
- [Minecraft Realms API](https://wiki.vg/Realms_API)
- [MCVersions.net](https://mcversions.net)
---
### Tools used
- [Mapcrafter](https://github.com/mapcrafter/mapcrafter)
    - The owner of the Mapcrafter project has taken a hiatus, so for now I am using a [separate fork](https://github.com/miclav/mapcrafter) with more recent updates from miclav. (Thank you!)
