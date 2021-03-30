# No longer maintained, upgraded to <a href="https://github.com/andrei0465/csgorevolver">CS:GO Revolver Mod</a>

![alt text](https://i.imgur.com/srecEyR.jpg)
![alt text](https://i.imgur.com/RUWoYXR.jpg)
![alt text](https://i.imgur.com/9cxhlMC.jpg)
![alt text](https://i.imgur.com/8zlZkTM.jpg)
![alt text](https://i.imgur.com/Z0maBTr.jpg)
![alt text](https://i.imgur.com/DJJMSZY.jpg)

# CSGO Remake 1Gx
CSGO Remake 1Gx created by Nubo for CS1.6. (SMA source was restored and improved)

# Improvements
1. Added new chat system which does not require other fixchat plugins. (the living can see what the dead write and vice versa)
2. Changed the save system for natives because the old one did not save after the map change.
3. Other small things that can affect the future of mod.

# Compatibility
Tested on the following AMXX versions:
- 1.9-dev build 5271 (Recommended)

# Download
You can download from <a href="https://github.com/kuamquat940/csgoremake/releases">releases</a>.

# Installation tutorial

csgoremake.cfg - addons/amxmodx/configs/ <br />
csgoremake.ini - addons/amxmodx/configs/ <br />
csgoremake.txt - addons/amxmodx/data/lang/ <br />
csgoremake.amxx - addons/amxmodx/plugins/ <br />

3dranks.mdl - models/ <br />
w_fb_csgor.mdl - models/ <br />
w_he_csgor.mdl - models/ <br />
w_sg_csgor.mdl - models/ <br />

ctwingo.wav - sound/misc/ <br />
twingo.wav - sound/misc/ <br />

Tested with the following active modules: <br />
fun <br />
engine <br />
fakemeta <br />
geoip <br />
sockets <br />
regex <br />
nvault <br />
hamsandwich <br />
csx

# Changelog
## v0.3-dev

### Added

- Ported to AMXX version 1.9-dev.
- Color print system
- Register dictionary colored

### Fixed

- Since the menu item data is a string, it's possible that it doesn't handle negative values and it seems to get converted to an unsigned byte.

### Changed

- client_print_color with color_print (Ex.: client_print_color(id, id, ... with  color_print(id, ... )

## v0.2-dev

### Added
### Fixed

- Fixed small chat bugs.

### Changed

## v0.1-dev

- Official playtest launch.
