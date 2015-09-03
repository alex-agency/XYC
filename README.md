# XYC
Xiaomi Yi Configurator (XYC)
http://www.tawbaware.com
(c) Tawbaware software, 2015

Description: This script runs inside the Xiaomi Yi camera and allows the user
to enable RAW file creation, and change photographic options such as
exposure, ISO, whitebalance, etc.  In addition, a photographic time-lapse
feature is also available.  It is designed to be executed and accessed via
a telnet client running on any phone, computer, tablet, etc.

<img width="309" alt="1" src="https://cloud.githubusercontent.com/assets/1122708/9668357/baf4a22c-5289-11e5-81e6-ce1c12cee2cf.png">  <img width="309" alt="2" src="https://cloud.githubusercontent.com/assets/1122708/9668358/baf52a76-5289-11e5-8e9e-92db6999715f.png">  <img width="309" alt="3" src="https://cloud.githubusercontent.com/assets/1122708/9668359/baf7d5f0-5289-11e5-9cab-e8c1582f3c3f.png">
<img width="309" alt="4" src="https://cloud.githubusercontent.com/assets/1122708/9668361/bafa6194-5289-11e5-80a0-e18d2656d566.png">  <img width="309" alt="5" src="https://cloud.githubusercontent.com/assets/1122708/9668360/baf8305e-5289-11e5-9365-f9d4bac8e38a.png">  <img width="309" alt="6" src="https://cloud.githubusercontent.com/assets/1122708/9668362/bb0edd0e-5289-11e5-8a67-0e4f50d48458.png">



Installation:

1. Install script at top level of SD card and ensure execute permissions:
        chmod 755 /tmp/fuse_d/xyc.sh
2  Optional.  If you have custom settings (e.g. bitrate, video size, etc.)
   that you want to be included in the autoexec.ash file, store these commands
   in a  file named autoexec.xyc in the same directory as xyc.sh.  Also, using
   XYC, set the "Custom Photo Settings" ->  "Import additional settings..."
   menu choice to "yes".  XYC will copy everything from the autoexec.xyc into
   autoexec.ash whenever it updates autoexec.ash.
3. Optional.  If you want XYC to operate in a language other than English,
   create a file named xyc_strings.sh in the same directory as xyc.sh.  See
   "TRANSLATION STRINGS" section below.

Usage:

1. Enable wifi, and connect to camera using telnet
   (IP=192.168.42.1, user id="root", no password)
2. Run script: /tmp/fuse_d/xyc.sh

Changelog:

0.3.1 (Sep 2015) by Alex 
- Ported features from XYC v4.6 https://rendy37.wordpress.com/2015/08/13/xiaomi-yi-configurator-xyc-ubah-script-tanpa-pc/
- Added YiMax Movie script http://nutseynuts.blogspot.com/2015/06/xiaomi-yi-action-cam-custom-scripts.html
- Simplified menu interface
- Fixed issues

0.2.0 (Aug 2015)
- Added support for alternate langauges
- Added support for user settings
- Standardized menu interface

0.1.0 (Aug 2015)
- Initial release

Disclaimer: This software is not created or endorsed by Xiaomi; it relies on
undocumented features of the Xiaomi Yi. Using this software may void your
camera's warranty and possibly damage your camera.  Use at your own risk!
