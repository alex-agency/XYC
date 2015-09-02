# XYC
Xiaomi Yi Configurator (XYC)
http://www.tawbaware.com
(c) Tawbaware software, 2015

Description: This script runs inside the Xiaomi Yi camera and allows the user
to enable RAW file creation, and change photographic options such as
exposure, ISO, whitebalance, etc.  In addition, a photographic time-lapse
feature is also available.  It is designed to be executed and accessed via
a telnet client running on any phone, computer, tablet, etc.


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

0.2.0 (Aug 2015) - Added support for alternate langauges
                 - Added support for user settings
                 - Standardized menu interface
0.1.0 (Aug 2015) - Initial release
Disclaimer: This software is not created or endorsed by Xiaomi; it relies on
undocumented features of the Xiaomi Yi. Using this software may void your
camera's warranty and possibly damage your camera.  Use at your own risk!