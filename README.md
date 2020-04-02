# Minecraft Realms Mapcrafter Renderer

This group of Bash scripts does the following:

1. Downloads the latest Minecraft Realms world if it more recent than the local copy
2. Clones (or updates) and builds the latest copy of Mapcrafter from Github
3. Creates the Mapcrafter configuration file
4. Runs Mapcrafter on the local copy of the Minecraft Realms world to generate an awesome web-based map experience!
---
### Prerequisites
- Bash
- [jq](https://github.com/stedolan/jq)
---
### Tools used
- [Mojang Authentication](https://wiki.vg/Authentication)
- [Minecraft Realms API](https://wiki.vg/Realms_API)
- [Mapcrafter](https://github.com/mapcrafter/mapcrafter)
    - The owner of the Mapcrafter project has taken a hiatus, so for now I am using a [separate fork](https://github.com/miclav/mapcrafter) with more recent updates from miclav. (Thank you!)