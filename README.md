[![Join the chat at https://gitter.im/alex-agency/XYC](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alex-agency/XYC?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Xiaomi Yi Configurator (XYC)
==========================
[© Tawbaware software, 2015](http://www.tawbaware.com)

This script runs inside the Xiaomi Yi camera and allows the user to enable RAW file creation, and change photographic options such as exposure, ISO, whitebalance, etc. It is designed to be executed and accessed via a telnet client running on any phone, computer, tablet, etc.

<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181006/65ec7bc6-b588-11e5-910f-e8350db1694f.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181007/65edf5d2-b588-11e5-9e22-08e21f26c711.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181009/65f06556-b588-11e5-8151-b04f1ea3f7bd.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181010/65f0aaf2-b588-11e5-9dea-76664d2e410b.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181008/65ef2330-b588-11e5-804a-b224ab3808d6.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181012/6a9b1c4a-b588-11e5-93db-72586539117f.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181015/6a9c5718-b588-11e5-855d-64aad59c1fa8.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181016/6a9e44d8-b588-11e5-867a-ba0630e18c66.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181013/6a9bc9ec-b588-11e5-89ce-1064d42b31b1.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181014/6a9c1c3a-b588-11e5-8d76-ba28f670ee1f.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181020/707c869e-b588-11e5-8471-0c35872baa2f.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181018/707a762e-b588-11e5-85db-317d018b49f0.jpg">
<img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181021/707ce0bc-b588-11e5-8e0f-336572893cd2.jpg">  <img width="320" src="https://cloud.githubusercontent.com/assets/1122708/12181019/707b85fa-b588-11e5-99c6-b597f2cc2d37.jpg">

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
