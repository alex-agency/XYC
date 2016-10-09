[![Join the chat at https://gitter.im/alex-agency/XYC](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alex-agency/XYC?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Xiaomi Yi Configurator (XYC)
==========================
[© Tawbaware software, 2015](http://www.tawbaware.com)

This script runs inside the Xiaomi Yi camera and allows the user to enable RAW file creation, and change photographic options such as exposure, ISO, whitebalance, etc. It is designed to be executed and accessed via a telnet client running on any phone, computer, tablet, etc.

<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090407/33c050ce-d4fe-11e5-93c0-07d54b7c7509.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090408/33d6de7a-d4fe-11e5-9a33-fbb18f55df1a.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090410/33e39f66-d4fe-11e5-8893-c3fdc7a5e85d.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090409/33e33bb6-d4fe-11e5-9c42-bbf8230638d3.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090412/33e4a6ea-d4fe-11e5-9560-203f0ee7d5c0.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090411/33e4a564-d4fe-11e5-84e4-567fa5d262b4.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090418/39eb0a5c-d4fe-11e5-99bd-397156db7e63.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090421/3a18ecd8-d4fe-11e5-9af0-a81595f6d788.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090420/3a1731d6-d4fe-11e5-9507-ff77746db632.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/13090419/3a08d0e6-d4fe-11e5-8e1e-4eea50d874f5.jpg">

# Installation

1. Install script at top level of SD card and ensure execute permissions:    
`chmod 755 /tmp/fuse_d/xyc.sh`   
2. Optional.  If you have custom settings that you want to be included in the autoexec.ash file, store these commands in a  file named autoexec.xyc in the same directory as xyc.sh.  Also, using XYC, set the "Import User settings" menu choice to "yes".  XYC will copy everything from the autoexec.xyc into autoexec.ash whenever it updates autoexec.ash.
3. Optional.  If you want XYC to operate in a language other than English, create a file named xyc_strings.sh in the same directory as xyc.sh.  See "TRANSLATION STRINGS" section below.

# Usage

1. Enable wifi, and connect to camera using telnet
   (IP=192.168.42.1, user id="root", no password)
2. Run script: `/tmp/fuse_d/xyc.sh`

# Changelog

1.0.2 (Oct 2016) by Alex
- Added 640x480 and 848x480 resolutions for FPV
- Added AV out support for all resolutions

1.0.1 (Feb 2016) by Alex
- Simplified user interface for support different languages
- Updated support for 8 languages
- Updated YiMAX preset
- Updated WaffleFPV preset to V8
- Better quality with Alex_Day preset
- Night vision with Alex_Night preset
- Predefined saturation adjustments
- Added scene mode
- Renovate sharpness and coring
- Save battery adjustment
- Ability to change buzzer volume

0.3.5 (Jan 2016) by Alex
- Added SuperView feature
- Added WaffleFPV preset

0.3.4 (Dec 2015) by Alex
- Added Time-lapse script
- Added ability to use Time-lapse with HDR, RAW and others settings 
- Added ability to save and reuse different presets
- Added ability to set bitrates for all resolutions
- Added new video frequencies: 24fps, 48fps
- Resolved 2560x1440 resolution, it's upscaling from 2304x1296
- Added ability to adjust Auto Knee, Gamma level
- Increased script performance
- Fixed issue in XYC Update
- Fixed issue in HDR scripts
- Removed GoPrawn script

0.3.3 (Oct 2015) by Alex
- Support latest 1.2.13 firmware
- Added support file weight limit to 4GB
- Added 1440p resolution for testing purpose
- Added ability managing Noise Reduction
- Added new bitrates for Video Quality (40-50Mb)
- Added XYC Update feature for automatic download new version
- Removed Time Lapse script (use YiCam app Time-lapse with XYC camera settings)

0.3.2 (Sep 2015) by Alex 
- Updated YiMax script
- Added shadow/highlight/gamma script
- Added sharpness script
- Fixed HDR scripts and added HDR Night

0.3.1 (Sep 2015) by Alex 
- Ported features from [XYC v4.6](https://rendy37.wordpress.com/2015/08/13/xiaomi-yi-configurator-xyc-ubah-script-tanpa-pc/)
- Added [YiMax Movie script](http://nutseynuts.blogspot.com/2015/06/xiaomi-yi-action-cam-custom-scripts.html)
- Simplified menu interface
- Fixed issues

0.2.0 (Aug 2015)
- Added support for alternate langauges
- Added support for user settings
- Standardized menu interface

0.1.0 (Aug 2015)
- Initial release

# Disclaimer

This software is not created or endorsed by Xiaomi; it relies on undocumented features of the Xiaomi Yi. 
Using this software may void your camera's warranty and possibly damage your camera.  Use at your own risk!
