[![Join the chat at https://gitter.im/alex-agency/XYC](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alex-agency/XYC?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Xiaomi Yi Configurator (XYC)
==========================
[© Tawbaware software, 2015](http://www.tawbaware.com)

This script runs inside the Xiaomi Yi camera and allows the user to enable RAW file creation, and change photographic options such as exposure, ISO, whitebalance, etc. It is designed to be executed and accessed via a telnet client running on any phone, computer, tablet, etc.

<img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204186/020da82c-67c3-11e5-876b-1d81f47e87e6.jpg">  <img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204185/020c3884-67c3-11e5-9831-5f00f2c42b93.jpg">
<img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204182/02079c8e-67c3-11e5-9f9a-156afc9452e8.jpg">  <img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204183/020a636a-67c3-11e5-9b5a-179ce842a2c7.jpg">
<img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204184/020af41a-67c3-11e5-9ba0-412c8df99d72.jpg">  <img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204187/020ee1b0-67c3-11e5-8c1b-0e2466283d5e.jpg">
<img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204188/021f9186-67c3-11e5-9a5f-6c476ed3d81f.jpg">  <img width="309" src="https://cloud.githubusercontent.com/assets/1122708/10204189/02257092-67c3-11e5-824f-1a8ab38489ef.jpg">

# Installation

1. Install script at top level of SD card and ensure execute permissions:    
`chmod 755 /tmp/fuse_d/xyc.sh`   
2. Optional.  If you have custom settings (e.g. bitrate, video size, etc.)
   that you want to be included in the autoexec.ash file, store these commands
   in a  file named autoexec.xyc in the same directory as xyc.sh.  Also, using
   XYC, set the "Custom Photo Settings" ->  "Import additional settings..."
   menu choice to "yes".  XYC will copy everything from the autoexec.xyc into
   autoexec.ash whenever it updates autoexec.ash.
3. Optional.  If you want XYC to operate in a language other than English,
   create a file named xyc_strings.sh in the same directory as xyc.sh.  See
   "TRANSLATION STRINGS" section below.
4. Optional. If you want RAW Time Lapse than enable Create RAW camera setting, 
   save settings and go to official Xiaomi YiCam app -> Photo Time-lapse. 
   Also you can use other camera settings to configure Time-lapse footage. 

# Usage

1. Enable wifi, and connect to camera using telnet
   (IP=192.168.42.1, user id="root", no password)
2. Run script: `/tmp/fuse_d/xyc.sh`

# Changelog

0.3.5 (Dec 2015) by toyorg
- Added SD formatting, removing files only in /DCIM/100MEDIA/

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

This software is not created or endorsed by Xiaomi; it relies on
undocumented features of the Xiaomi Yi. Using this software may void your
camera's warranty and possibly damage your camera.  Use at your own risk!
