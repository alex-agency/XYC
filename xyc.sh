# Xiaomi Yi Configurator
# http://www.tawbaware.com
# (c) Tawbaware software, 2015
#
# Description: This script runs inside the Xiaomi Yi camera and allows the user
# to enable RAW file creation, and change photographic options such as
# exposure, ISO, whitebalance, etc. It is designed to be executed and accessed
# via a telnet client running on any phone, computer, tablet, etc.
#
#
# Installation:
#
# 1. Install script at top level of SD card and ensure execute permissions:
#        chmod 755 /tmp/fuse_d/xyc.sh
# 2  Optional.  If you have custom settings that you want to be included in the
#    autoexec.ash file, store these commands in a  file named autoexec.xyc in
#    the same directory as xyc.sh.  Also, using XYC, set the "Import User settings"
#    menu choice to "yes".  XYC will copy everything from the autoexec.xyc into
#    autoexec.ash whenever it updates autoexec.ash.
# 3. Optional.  If you want XYC to operate in a language other than English,
#    create a file named xyc_strings.sh in the same directory as xyc.sh.  See
#    "TRANSLATION STRINGS" section below.
#
# Usage:
#
# 1. Enable wifi, and connect to camera using telnet
#    (IP=192.168.42.1, user id="root", no password)
# 2. Run script: /tmp/fuse_d/xyc.sh
#
# Changelog:
#
# 0.3.5 (Dec 2015) - Added SD formatting, removing files only in /DCIM/100MEDIA/
# by toyorg
# 0.3.4 (Dec 2015) - Added Time-lapse script
# by Alex          - Added ability to use Time-lapse with HDR, RAW and others settings
#                  - Added ability to save and reuse different presets
#                  - Added ability to set bitrates for all resolutions
#                  - Added new video frequencies: 24fps, 48fps
#                  - Resolved 2560x1440 resolution, it's upscaling from 2304x1296
#                  - Added ability to adjust Auto Knee, Gamma level
#                  - Increased script performance
#                  - Fixed issue in XYC Update
#                  - Fixed issue in HDR scripts
#                  - Removed GoPrawn script
# 0.3.3 (Oct 2015) - Support latest 1.2.13 firmware
# by Alex          - Added support file weight limit to 4GB
#                  - Added 1440p resolution for test purpose
#                  - Added ability managing Noise Reduction
#                  - Added new bitrates for Video Quality (40-50Mb)
#                  - Added XYC Update feature for automatic download new version
#                  - Removed Time Lapse script (use YiCam app Time-lapse with XYC camera settings)
# 0.3.2 (Sep 2015) - Updated YiMax script
# by Alex          - Added shadow/highlight/gamma script
#                  - Added sharpness script
#                  - Fixed HDR scripts and added HDR Night
# 0.3.1 (Sep 2015) - Ported features from XYC v4.6 https://rendy37.wordpress.com/2015/08/13/xiaomi-yi-configurator-xyc-ubah-script-tanpa-pc/
# by Alex          - Added YiMax Movie script http://nutseynuts.blogspot.com/2015/06/xiaomi-yi-action-cam-custom-scripts.html
#                  - Simplified menu interface
#                  - Fixed issues
# 0.2.0 (Aug 2015) - Added support for alternate langauges
#                  - Added support for user settings
#                  - Standardized menu interface
# 0.1.0 (Aug 2015) - Initial release
# Disclaimer: This software is not created or endorsed by Xiaomi; it relies on
# undocumented features of the Xiaomi Yi. Using this software may void your
# camera's warranty and possibly damage your camera.  Use at your own risk!

VERS="0.3.5 Alex"
FUSED=/tmp/fuse_d
SCRIPT_DIR=$(cd `dirname "$0"` && pwd)
WEB=/var/www
if [ ! -d "$FUSED" ]; then
  FUSED=$SCRIPT_DIR
  if [ -d "$WEB" ]; then
    FUSED=$WEB
  fi
fi
AASH=${FUSED}/autoexec.ash
CORCONF=${FUSED}/sharpening.config
THIS_SCRIPT="$SCRIPT_DIR/`basename "$0"`"
LANGUAGE_FILE="$SCRIPT_DIR/xyc_strings.sh"
USER_SETTINGS_FILE="$SCRIPT_DIR/autoexec.xyc"
PRESETS_FILE="$SCRIPT_DIR/xyc_presets.sh"

#=============================================================================
#
# TRANSLATION STRINGS
#
# This list of variables contains the user interface strings for the English
# Language.  English is the default language for this program, but other
# languages can be easily supported.  If you wish to translate xyc to a
# different language, create a file named xyc_strings.sh in the same directory
# as xyc.sh, and store translated versions of (any or all) these XYC_* strings
# in that file.

XYC_MAIN_MENU="Main Menu"
XYC_EDIT_PHOTO_SETTINGS="View/Edit Photo settings"
XYC_EDIT_VIDEO_SETTINGS="View/Edit Video settings"
XYC_RESET_SETTINGS="Reset camera settings"
XYC_SHOW_CARD_SPACE="Show SD card space usage"
XYC_RESTART_CAMERA="Restart Camera"
XYC_EXIT="Exit"
XYC_SAVE_AND_BACK="<- Save & Back"
XYC_BACK="<- Back"
XYC_SELECT_OPTION="Select option"
XYC_INVALID_CHOICE="Invalid choice"
XYC_SD_CARD_SPACE="SD Card Space"
XYC_TOTAL="Total"
XYC_USED="Used"
XYC_FREE="Free"
XYC_FILE_COUNTS="File counts"
XYC_ESTIMATED_REMAINING="Estimated remaining file capacity"
XYC_MINUTES="minutes"
XYC_UNKNOWN_OPTION="Warning...unknown option"
XYC_ISO="ISO"
XYC_EXPOSURE="Exposure"
XYC_EXP="Exp"
XYC_AWB="AWB"
XYC_CREATE_RAW="Create RAW"
XYC_RAW="RAW"
XYC_NR="NR"
XYC_YES="Yes"
XYC_NO="No"
XYC_Y="y"
XYC_N="n"
XYC_ON="On"
XYC_OFF="Off"
XYC_AUTO="Auto"
XYC_ENTER="Enter"
XYC_CHOOSE="Choose"
XYC_ENTER_AWB_PROMPT="Auto White Balance (y/n)"
XYC_CREATE_RAW_PROMPT="Create RAW files (y/n)"
XYC_RESTART_NOW_PROMPT="Restart camera now (y/n)"
XYC_REBOOTING_NOW="Rebooting now"
XYC_WRITING="Writing"
XYC_DELETING="Deleting"
XYC_CREATE_HDR="Create HDR settings"
XYC_PHOTO_SETTINGS_MENU="Photo Settings Menu"
XYC_VIDEO_SETTINGS_MENU="Video Settings Menu"
XYC_INCLUDE_USER_SETTINGS_PROMPT="Import settings from autoexec.xyc (y/n)"
XYC_HDR_MENU="HDR Settings Menu"
XYC_CANNOT_READ="WARNING: Cannot read/access"
XYC_USER_IMPORT="Import User settings"
XYC_EXPOSURE_MENU="Exposure Setting"
XYC_ISO_MENU="ISO Setting"
XYC_SEC="sec"
XYC_REMOVING="Removing"
XYC_DELETE_VIDEO_PREVIEW_PROMPT="Delete All Video Preview files (y/n)"
XYC_DELETE_RAW_PROMPT="Delete All RAW files (y/n)"
XYC_HDR="HDR"
XYC_HDR_DAY="HDR Day"
XYC_HDR_NIGHT="HDR Night"
XYC_HDR_RESET="Reset HDR settings"
XYC_AVOID_LIGHT="*AVOID LIGHT*"
XYC_RESOLUTION="Resolution"
XYC_DEFAULT="Default"
XYC_VIDEO_RESOLUTION="Video Resolution"
XYC_VIDEO_FREQUENCY="Video Frequency"
XYC_VIDEO_BITRATE="Video Bitrate"
XYC_AUTOKNEE="Auto Knee"
XYC_AUTOKNEE_PROMPT="Enter Auto Knee level (0-255)"
XYC_SHARPNESS="Sharpness"
XYC_SHARPNESS_MENU="Sharpness Menu"
XYC_SHARPNESS_MODE="Sharpness Mode"
XYC_SHARPNESS_FIR="Digital Filter"
XYC_SHARPNESS_COR="Coring"
XYC_SHR_MODE_VIDEO="Video"
XYC_SHR_MODE_FAST="Fast Still"
XYC_SHR_MODE_LOWISO="LowISO Still"
XYC_SHR_MODE_HIGHISO="HighISO Still"
XYC_SHARPNESS_FIR_PROMPT="Coefficients of Digital Filter"
XYC_SHARPNESS_COR_PROMPT="Coefficients of Coring (1-255)"
XYC_BIG_FILE="4Gb files"
XYC_BIG_FILE_PROMPT="Set file weight limit to 4GB (y/n)"
XYC_RESOLUTION_WARNING="Warning Resolution"
XYC_NR_MENU="Noise Reduction Menu"
XYC_DISABLE_NR="Disable NR"
XYC_MAX_NR="Max NR"
XYC_CUSTOM_NR_PROMPT="Enter Noise Reduction (0-16383)"
XYC_MAX="Max"
XYC_DISABLE="Disable"
XYC_UPDATING_NOW="Updating now"
XYC_SCRIPT_UPDATE="Update XYC"
XYC_UPDATE_NOW_PROMPT="Download latest and rewrite existing XYC (y/n)"
XYC_NO_INTERNET="The script doesn't have internet connection."
XYC_UPDATE_ERROR="It's required for download XYC update."
XYC_UPDATE_COMPLETE="Update complete."
XYC_UPDATE_MANUAL="For download script manually browse to"
XYC_CREATE_FILE="First create"
XYC_BITRATE="Bitrate all"
XYC_AAA="AAA"
XYC_AAA_PROMPT="AAA function: set AE/AWB/ADJ locks (y/n)"
XYC_GAMMA="Gamma"
XYC_GAMMA_PROMPT="Enter Gamma level (0-255)"
XYC_GAMMA_MENU="Gamma Menu"
XYC_CUSTOM="Custom"
XYC_AUTOKNEE_MENU="Auto Knee Menu"
XYC_VIBSAT="Saturation"
XYC_VIBSAT_PROMPT="Vibrance and Saturation adjustments (y/n)"
XYC_PRESETS="Manage XYC Presets"
XYC_PRESETS_MENU="XYC Presets Menu"
XYC_NO_PRESETS="You don't have any presets, create it first."
XYC_LOAD_PRESET="Load preset"
XYC_CREATE_PRESET="Create new preset"
XYC_REMOVE_PRESET="Remove preset"
XYC_LOAD_PRESET_MENU="Load Preset Menu"
XYC_REMOVE_PRESET_MENU="Remove Preset Menu"
XYC_NEW_PRESET_PROMPT="Enter name of current configuration"
XYC_NAME_EXIST="Specified name already exist"
XYC_PRESET_CREATED="XYC settings were saved to"
XYC_PRESET_LOADED="Preset loaded"
XYC_PRESET_REMOVED="Preset removed"
XYC_CREATE_TIME_LAPSE="Create Time-lapse settings"
XYC_TIME_LAPSE_MENU="Time-lapse Settings Menu"
XYC_TIME_LAPSE_RESET="Reset Time-lapse settings"
XYC_TIME_LAPSE_MODE="Time-lapse Mode"
XYC_TIME_LAPSE_CYCLES="Time-lapse Cycles"
XYC_TIME_LAPSE_INTERVAL="Time-lapse Interval"
XYC_RUN_ONCE_ONLY="Run once only"
XYC_ALLOW_POWEROFF="Allow poweroff"
XYC_SHUTTING_DOWN_NOW="Shutting down now"
XYC_NUM_CYCLES_PROMPT="Enter number of cycles (1-360)"
XYC_CYCLES_INTERVAL_PROMPT="Enter interval between cycles, sec (1-3600)"
XYC_RUN_ONCE_ONLY_PROMPT="Remove time-lapse script when complete (y/n)"
XYC_POWEROFF_WHEN_COMPLETE_PROMPT="Poweroff camera when complete (y/n)"
XYC_RESTART_TO_APPLY="Restart your camera to apply settings."
XYC_INVINITY="Invinity"
XYC_FORMAT="SD card formatting"
XYC_REMOVE_FILE="Remove"
XYC_REMOVE_INFO="Removing files only in /DCIM/100MEDIA/"
XYC_WIFI="WiFi settings"
XYC_WIFI_CLIENT="WiFi in client mode"
XYC_WIFI_WATCHDOG"WiFi watchdog"
XYC_WIFI_INFO="Edit watchdog.sh and wpa_supplicant.conf BEFORE using!"

#If language file exists, source it to override English language UI strings
if [[ -s "$LANGUAGE_FILE" && -r "$LANGUAGE_FILE" ]]; then
  source $LANGUAGE_FILE
fi

#=============================================================================

welcome ()
{
  clear
  echo ""
  echo " *  Xiaomi Yi Configurator  * "
  echo " *  12/16/2015  ${VERS}  * "
  echo ""
}

showMainMenu ()
{
  local REPLY
  while [ "$EXITACTION" == "" ]
  do
    echo "    ====== ${XYC_MAIN_MENU} ====="
    echo " [1] ${XYC_EDIT_PHOTO_SETTINGS}"
    echo " [2] ${XYC_EDIT_VIDEO_SETTINGS}"
    echo " [3] ${XYC_CREATE_TIME_LAPSE}"
    echo " [4] ${XYC_CREATE_HDR}"
    echo " [5] ${XYC_USER_IMPORT}"
    echo " [6] ${XYC_PRESETS}"
    echo " [7] ${XYC_RESET_SETTINGS}"
    echo " [8] ${XYC_SHOW_CARD_SPACE}"
    echo " [9] ${XYC_FORMAT}"
    echo " [10] ${XYC_WIFI}"
    echo " [11] ${XYC_RESTART_CAMERA}"
    echo " [12] ${XYC_SCRIPT_UPDATE}"
    echo " [13] ${XYC_EXIT}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    clear
    case $REPLY in
      0) clear; cat $AASH;;
      1) showPhotoSettingsMenu; writeAutoexec;;
      2) showVideoSettingsMenu; writeAutoexec;;
      3) showTimeLapseMenu; writeAutoexec;;
      4) showHDRMenu; writeAutoexec;;
      5) getIncludeUserSettings;;
      6) showPresetsMenu;;
      7) removeAutoexec; resetCameraSettings;;
      8) showSpaceUsage;;
      9) formatSD;;
      10) wifiSettings;;
      11) EXITACTION="reboot";;
      12) EXITACTION="update";;
      13) EXITACTION="nothing";;
      *) echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showPhotoSettingsMenu ()
{
  local REPLY
  while true
  do
    echo "    == ${XYC_PHOTO_SETTINGS_MENU} =="
    if [ -z "$EXP" ]; then
      echo " [1] ${XYC_EXPOSURE}     : ${XYC_AUTO}"
    else
      expView $EXP
      echo " [1] ${XYC_EXPOSURE}     : $EXPVIEW"
    fi
    if [ -z "$ISO" ]; then
      echo " [2] ${XYC_ISO}          : ${XYC_AUTO}"
    else
      echo " [2] ${XYC_ISO}          : $ISO"
    fi
    if [ "$AWB" == ${XYC_N} ]; then
      echo " [3] ${XYC_AWB}          : ${XYC_NO}"
    else
      echo " [3] ${XYC_AWB}          : ${XYC_YES}"
    fi
    if [ -z "$AUTOKNEE" ]; then
      echo " [4] ${XYC_AUTOKNEE}    : ${XYC_DEFAULT}"
    else
      echo " [4] ${XYC_AUTOKNEE}    : $AUTOKNEE"
    fi
    if [ "$VIBSAT" == ${XYC_Y} ]; then
      echo " [5] ${XYC_VIBSAT}   : ${XYC_YES}"
    else
      echo " [5] ${XYC_VIBSAT}   : ${XYC_DEFAULT}"
    fi
    if [ -z "$SHR" ]; then
      echo " [6] ${XYC_SHARPNESS}    : ${XYC_DEFAULT}"
    else
      echo " [6] ${XYC_SHARPNESS}    : $SHR $FIR $COR"
    fi
    if [ "$RAW" == ${XYC_Y} ]; then
      echo " [7] ${XYC_CREATE_RAW}   : ${XYC_YES}"
    else
      echo " [7] ${XYC_CREATE_RAW}   : ${XYC_NO}"
    fi
    echo " [8] ${XYC_SAVE_AND_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getExposureInput; clear;;
      2) getISOInput; clear;;
      3) getAWBInput; clear;;
      4) getAutoKneeInput; clear;;
      5) getVibSatInput; clear;;
      6) getSharpnessInput; clear;;
      7) getRawInput; clear;;
      8) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showVideoSettingsMenu ()
{
  local REPLY
  while true
  do
    echo "    == ${XYC_VIDEO_SETTINGS_MENU} =="
    if [ -z "$NR" ]; then
      echo " [1] ${XYC_NR}           : ${XYC_DEFAULT}"
    elif [ $NR -eq -1 ]; then
      echo " [1] ${XYC_NR}           : ${XYC_DISABLE}"
    elif [ $NR -eq 16383 ]; then
      echo " [1] ${XYC_NR}           : ${XYC_MAX}"
    else
      echo " [1] ${XYC_NR}           : $NR"
    fi
    if [ "$AAA" == ${XYC_Y} ]; then
      echo " [2] ${XYC_AAA}          : ${XYC_YES}"
    else
      echo " [2] ${XYC_AAA}          : ${XYC_DEFAULT}"
    fi
    if [ -z "$GAMMA" ]; then
      echo " [3] ${XYC_GAMMA}        : ${XYC_DEFAULT}"
    else
      echo " [3] ${XYC_GAMMA}        : $GAMMA"
    fi
    if [ -z "$AUTOKNEE" ]; then
      echo " [4] ${XYC_AUTOKNEE}    : ${XYC_DEFAULT}"
    else
      echo " [4] ${XYC_AUTOKNEE}    : $AUTOKNEE"
    fi
    if [ "$VIBSAT" == ${XYC_Y} ]; then
      echo " [5] ${XYC_VIBSAT}   : ${XYC_YES}"
    else
      echo " [5] ${XYC_VIBSAT}   : ${XYC_DEFAULT}"
    fi
    if [ -z "$SHR" ]; then
      echo " [6] ${XYC_SHARPNESS}    : ${XYC_DEFAULT}"
    else
      echo " [6] ${XYC_SHARPNESS}    : $SHR $FIR $COR"
    fi
    if [ -z "$RES" ]; then
      echo " [7] ${XYC_RESOLUTION}   : ${XYC_DEFAULT}"
    else
      echo " [7] ${XYC_RESOLUTION}   : $RESVIEW"
    fi
    if [ -z "$BIT" ]; then
      echo " [8] ${XYC_BITRATE}  : ${XYC_DEFAULT}"
    else
      echo " [8] ${XYC_BITRATE}  : $BITVIEW"
    fi
    if [ "$BIG_FILE" == ${XYC_Y} ]; then
      echo " [9] ${XYC_BIG_FILE}    : ${XYC_YES}"
    else
      echo " [9] ${XYC_BIG_FILE}    : ${XYC_NO}"
    fi
    echo " [10] ${XYC_SAVE_AND_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getNRInput; clear;;
      2) getAAAInput; clear;;
      3) getGammaInput; clear;;
      4) getAutoKneeInput; clear;;
      5) getVibSatInput; clear;;
      6) getSharpnessInput; clear;;
      7) getVideoResolutionInput; clear;;
      8) getVideoBitrateInput; clear;;
      9) getBigFileInput; clear;;
      10) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showTimeLapseMenu ()
{
  local REPLY
  while true
  do
    echo "    == ${XYC_TIME_LAPSE_MENU} =="
    if [ -z "$TLMODE" ]; then
      echo " [1] ${XYC_TIME_LAPSE_MODE}     : ${XYC_DISABLE}"
    elif [ $TLMODE -eq 0 ]; then
      echo " [1] ${XYC_TIME_LAPSE_MODE}     : ${XYC_CUSTOM}"
      if [ -z "$TLDELAY" ]; then TLDELAY=10; fi;
      if [ -z "$TLNUM" ]; then TLNUM=30; fi;
      if [ -z "$TLONCE" ]; then TLONCE=${XYC_Y}; fi;
    elif [ $TLMODE -eq 1 ]; then
      echo " [1] ${XYC_TIME_LAPSE_MODE}     : ${XYC_INVINITY}"
      if [ -z "$TLDELAY" ]; then TLDELAY=10; fi;
      unset TLNUM TLONCE TLOFF
    elif [ $TLMODE -eq 2 ]; then
      echo " [1] ${XYC_TIME_LAPSE_MODE}     : ${XYC_HDR}"
      if [ -z "$TLDELAY" ]; then TLDELAY=10; fi;
      unset TLNUM TLONCE TLOFF
    fi
    if [[ -z "$TLMODE" || -z "$TLDELAY" ]]; then
      echo " [2] ${XYC_TIME_LAPSE_INTERVAL} : ${XYC_DISABLE}"
    else
      echo " [2] ${XYC_TIME_LAPSE_INTERVAL} : $TLDELAY"
    fi
    if [ -z "$TLMODE" ]; then
      echo " [3] ${XYC_TIME_LAPSE_CYCLES}   : ${XYC_DISABLE}"
    elif [ $TLMODE -eq 0 ]; then
      echo " [3] ${XYC_TIME_LAPSE_CYCLES}   : $TLNUM"
    else
      echo " [3] ${XYC_TIME_LAPSE_CYCLES}   : ${XYC_INVINITY}"
    fi
    if [ "$TLONCE" == ${XYC_Y} ]; then
      echo " [4] ${XYC_RUN_ONCE_ONLY}       : ${XYC_YES}"
    else
      echo " [4] ${XYC_RUN_ONCE_ONLY}       : ${XYC_NO}"
    fi
    if [ "$TLOFF" == ${XYC_Y} ]; then
      echo " [5] ${XYC_ALLOW_POWEROFF}      : ${XYC_YES}"
    else
      echo " [5] ${XYC_ALLOW_POWEROFF}      : ${XYC_NO}"
    fi
    echo " [6] ${XYC_TIME_LAPSE_RESET}"
    echo " [7] ${XYC_SAVE_AND_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getTLModeInput; clear;;
      2) getTLDelayInput; clear;;
      3) getTLNumShotsInput; clear;;
      4) getTLOnceInput; clear;;
      5) getTLOffInput; clear;;
      6) unset TLMODE TLDELAY TLNUM TLONCE TLOFF; clear; return;;
      7) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showHDRMenu ()
{
  local REPLY
  while true
  do
    if [ -n "$AUTAN" ]; then
      if [ $AUTAN -eq 1 ]; then
        echo " * ${XYC_HDR}1    : 1/15 sec  "
        echo " * ${XYC_HDR}2    : 1/50 sec  "
        echo " * ${XYC_HDR}3    : 1/250 sec "
        echo " * ${XYC_HDR}4    : 1/500 sec "
        echo " * ${XYC_HDR}5    : 1/1244 sec"
        echo " * ${XYC_HDR}6    : 1/8147 sec"
        echo ""
      elif [ $AUTAN -eq 2 ]; then
        echo " * ${XYC_HDR}1    : 7.9 sec   "
        echo " * ${XYC_HDR}2    : 4.6 sec   "
        echo " * ${XYC_HDR}3    : 2.7 sec   "
        echo " * ${XYC_HDR}4    : 1.0 sec   "
        echo " * ${XYC_HDR}5    : 1/3 sec   "
        echo " * ${XYC_HDR}6    : 1/15 sec  "
        echo ""
      elif [ $AUTAN -eq 0 ]; then
        expView $HDR1
        echo " * ${XYC_HDR}1    : $EXPVIEW  "
        expView $HDR2
        echo " * ${XYC_HDR}2    : $EXPVIEW  "
        expView $HDR3
        echo " * ${XYC_HDR}3    : $EXPVIEW  "
        echo ""
      fi
    fi
    echo "    == ${XYC_HDR_MENU} =="
    echo " [1] ${XYC_HDR_DAY}"
    echo " [2] ${XYC_HDR_NIGHT}"
    echo " [3] ${XYC_CUSTOM}"
    echo " [4] ${XYC_HDR_RESET}"
    echo " [5] ${XYC_SAVE_AND_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) AUTAN=1; HDR1=900; HDR2=1531; HDR3=2047; clear;;
      2) AUTAN=2; HDR1=1; HDR2=300; HDR3=900; clear;;
      3) AUTAN=0; getHDRInput; clear;;
      4) unset AUTAN HDR1 HDR2 HDR3; clear; return;;
      5) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showPresetsMenu ()
{
  clear
  local REPLY
  while true
  do
    echo "    == ${XYC_PRESETS_MENU} =="
    echo " [1] ${XYC_LOAD_PRESET}"
    echo " [2] ${XYC_CREATE_PRESET}"
    echo " [3] ${XYC_REMOVE_PRESET}"
    echo " [4] ${XYC_BACK}"
    local REPLY
    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) if showPresetsList "load"; then
           writeAutoexec; return;
         fi; clear;;
      2) getCreatePresetInput; clear;;
      3) showPresetsList "remove"; clear;;
      4) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

showSpaceUsage ()
{
  local JPEG_COUNT=`find ${FUSED} -name *.jpg | wc -l`
  local RAW_COUNT=`find ${FUSED} -name *.RAW | wc -l`
  local MP4_COUNT=`find ${FUSED} -name *.mp4 | wc -l`
  local THM_COUNT=`find ${FUSED} -name *.THM -o -name *thm.mp4 | wc -l`

  local SPACE_TOTAL=`df -h ${FUSED} | awk -F " " '/tmp/ {print $2}'`
  local SPACE_USED=`df -h ${FUSED} | awk -F " " '/tmp/ {print $3}'`
  local SPACE_FREE=`df -h ${FUSED} | awk -F " " '/tmp/ {print $4}'`
  local USED_PCT=`df -h ${FUSED} | awk -F " " '/tmp/ {print $5}'`

  local SPACE_FREE_KB=`df -k ${FUSED} | awk -F " " '/tmp/ {print $4}'`

  local JPEG_LEFT=`expr $SPACE_FREE_KB / 5500`
  local RAW_LEFT=`expr $SPACE_FREE_KB / 31000`
  local MP4_LEFT=`expr $SPACE_FREE_KB / 88000`

  echo "${XYC_SD_CARD_SPACE}:"
  echo "  ${XYC_TOTAL}=$SPACE_TOTAL, ${XYC_USED}=$SPACE_USED ($USED_PCT), ${XYC_FREE}=$SPACE_FREE"
  echo ""
  echo "${XYC_FILE_COUNTS}:"
  echo "  JPEG=$JPEG_COUNT, RAW=$RAW_COUNT, MP4=$MP4_COUNT, THM=$THM_COUNT"
  echo ""
  echo "${XYC_ESTIMATED_REMAINING}:"
  echo "  JPEG=$JPEG_LEFT, RAW=$RAW_LEFT, MP4=$MP4_LEFT ${XYC_MINUTES}"
  echo ""

  getCleanUpInput
  clear
}

formatSD ()
{
  local REPLY
  clear
  while true
  do
    echo "    ====== ${XYC_FORMAT} ====="
    echo " ${XYC_REMOVE_INFO}"
    echo " [1] ${XYC_REMOVE_FILE} RAW"
    echo " [2] ${XYC_REMOVE_FILE} JPG"
    echo " [3] ${XYC_REMOVE_FILE} MP4"
    echo " [4] ${XYC_REMOVE_FILE} THM"
    echo " [5] ${XYC_REMOVE_FILE} All"
    echo " [6] ${XYC_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) echo "${XYC_REMOVING} RAW"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.RAW"; clear;;
      2) echo "${XYC_REMOVING} JPEG"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.jpg"; clear;;
      3) echo "${XYC_REMOVING} MP4"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.mp4"; clear;;
      4) echo "${XYC_REMOVING} THM"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.THM"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*thm.mp4" clear;;
      5) echo "${XYC_REMOVING} All"; lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.*"; clear;;
      6) clear; return;;
      *) clear; echo "${XYC_INVALID_CHOICE}";;
    esac
  done
}

wifiSettings ()
{
  local REPLY
  clear
  while true
  do
    echo "    ====== ${XYC_WIFI} ====="
    echo " ${XYC_WIFI_INFO}"
    echo " [1] ${XYC_WIFI_CLIENT}"
    echo " [2] ${XYC_WIFI_WATCHDOG}"
    echo " [3] ${XYC_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) WIFI_CLIENT=${XYC_Y};;
      2) WIFI_WATCHDOG=${XYC_Y};;
      3) clear; return;;
      *) clear; echo "${XYC_SAVE_AND_BACK}";;
    esac
  done
}

getCleanUpInput ()
{
  read -p "${XYC_DELETE_VIDEO_PREVIEW_PROMPT} [${XYC_ENTER}=n]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*.THM"
    lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.THM"
    echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*thm.mp4"
    lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*thm.mp4"
  fi
  read -p "${XYC_DELETE_RAW_PROMPT} [${XYC_ENTER}=n]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*.RAW"
    lu_util exec "rm -f ${FUSED}/DCIM/100MEDIA/*.RAW"
  fi
}

parseCommandLine ()
{
  while [ $# -gt 0 ]
  do
    key="$1"
    case $key in
      -i) ISO=$2; shift;;
      -e) EXP=$2; shift;;
      -w) AWB=$2; shift;;
      -n) NR=$2; shift;;
      -a) AAA=$2; shift;;
      -g) GAMMA=$2; shift;;
      -k) AUTOKNEE=$2; shift;;
      -s) VIBSAT=$2; shift;;
      -r) RAW=$2; shift;;
      -b) BIG_FILE=$2; shift;;
      -u) INC_USER=$2; shift;;
      -t) TLMODE=$2; shift;;
      -h) AUTAN=$2; shift;;
       *) echo "${XYC_UNKNOWN_OPTION}: $key"; shift;;
    esac
    shift # past argument or value
    # write and close
    if [ $# -eq 0 ]; then
      writeAutoexec
      exit
    fi
  done
}

parseExistingAutoexec ()
{
  #Parse existing values from autoexec.ash
  ISO=$(grep "t ia2 -ae exp" $AASH 2>/dev/null | cut -d " " -f 5)
  if [ $ISO -eq 0 2> /dev/null ]; then unset ISO; fi

  EXP=$(grep "t ia2 -ae exp" $AASH 2>/dev/null | cut -d " " -f 6)
  if [ $EXP -eq 0 2> /dev/null ]; then unset EXP; fi

  NR=$(grep "t ia2 -adj tidx" $AASH 2>/dev/null | cut -d " " -f 6)
  GAMMA=$(grep "t ia2 -adj gamma" $AASH 2>/dev/null | cut -d " " -f 5)
  AUTOKNEE=$(grep "t ia2 -adj autoknee" $AASH 2>/dev/null | cut -d " " -f 5)

  grep -q "t ia2 -awb off" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then AWB=${XYC_N}; fi

  grep -q "t app test debug_dump 14" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RAW=${XYC_Y}; fi

  grep -q "t ia2 -3a" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then AAA=${XYC_Y}; fi

  grep -q "t ia2 -adj ev" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then VIBSAT=${XYC_Y}; fi

  grep -q "#User settings" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then INC_USER=${XYC_Y}; fi

  grep -q "#Time-lapse:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    TLMODE=$(grep "#Time-lapse:" $AASH | cut -d " " -f 2)
    TLDELAY=$(grep "#Time-lapse:" $AASH | cut -d " " -f 3)
    TLNUM=$(grep "#Time-lapse:" $AASH | cut -d " " -f 4)
    TLONCE=$(grep "#Time-lapse:" $AASH | cut -d " " -f 5)
    TLOFF=$(grep "#Time-lapse:" $AASH | cut -d " " -f 6)
  fi

  grep -q "#HDRParams:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    AUTAN=$(grep "#HDRParams:" $AASH | cut -d " " -f 2)
    HDR1=$(grep "#HDRParams:" $AASH | cut -d " " -f 3)
    HDR2=$(grep "#HDRParams:" $AASH | cut -d " " -f 4)
    HDR3=$(grep "#HDRParams:" $AASH | cut -d " " -f 5)
  fi

  grep -q "#Sharpness:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    SHR=$(grep "#Sharpness:" $AASH | cut -d " " -f 2)
    FIR=$(grep "#Sharpness:" $AASH | cut -d " " -f 3)
    COR=$(grep "#Sharpness:" $AASH | cut -d " " -f 4)
  fi

  grep -q "writeb 0xC06CC426 0x28" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x11" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x27" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=3; fi
  grep -q "writeb 0xC06CC426 0x0F" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=4; fi
  grep -q "writeb 0xC06CC426 0x34" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=5; fi
  grep -q "writeb 0xC06CC426 0x26" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x17" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x25" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=3; fi
  grep -q "writeb 0xC06CC426 0x16" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=4; fi
  grep -q "writeb 0xC06CC426 0x24" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x0D" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x23" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=3; fi
  grep -q "writeb 0xC06CC426 0x0C" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=4; fi
  grep -q "writeb 0xC06CC426 0x21" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x06" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x20" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=3; fi
  grep -q "writeb 0xC06CC426 0x03" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=4; fi
  grep -q "writel 0xC05C2CB4 0x05100900" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=5; FPS=2; fi
  grep -q "writel 0xC05C2CB4 0x05A00A00" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=6; FPS=2; fi

  grep -q "0x41A0" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x41A0"; fi
  grep -q "0x41C8" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x41C8"; fi
  grep -q "0x41F0" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x41F0"; fi
  grep -q "0x420C" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x420C"; fi
  grep -q "0x4220" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x4220"; fi
  grep -q "0x4234" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x4234"; fi
  grep -q "0x4248" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT="0x4248"; fi

  grep -q "writew 0xC03A8520 0x2004" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIG_FILE=${XYC_Y}; fi
}

resetCameraSettings ()
{
  unset EXP ISO AWB RAW
  unset NR AAA GAMMA RES FPS BIT BIG_FILE
  unset SHR FIR COR
  unset AUTOKNEE VIBSAT
  unset TLMODE TLDELAY TLNUM TLONCE TLOFF
  unset AUTAN HDR1 HDR2 HDR3
  unset INC_USER
  setMissingValues
}

setMissingValues ()
{
  expView $EXP
  setRESView
  setBITView
}

getExposureInput ()
{
  clear
  echo " ******** ${XYC_EXPOSURE_MENU} ********* "
  echo " * (0)=Auto (10)=1/15  (20)=1/752  * "
  echo " * (1)=7.9  (11)=1/30  (21)=1/1244 * "
  echo " * (2)=7.7  (12)=1/50  (22)=1/2138 * "
  echo " * (3)=6.1  (13)=1/60  (23)=1/3675 * "
  echo " * (4)=4.6  (14)=1/80  (24)=1/6316 * "
  echo " * (5)=2.7  (15)=1/125 (25)=1/8147 * "
  echo " * (6)=1.0  (16)=1/140             * "
  echo " * (7)=1/3  (17)=1/250             * "
  echo " * (8)=1/5  (18)=1/320             * "
  echo " * (9)=1/10 (19)=1/500             * "
  echo " *********************************** "
  local REPLY=$EXP
  read -p "${XYC_SELECT_OPTION}: 0-25: " REPLY
  case $REPLY in
    0) unset EXP;;
    1) EXP=1;;
    2) EXP=8;;
    3) EXP=50;;
    4) EXP=100;;
    5) EXP=200;;
    6) EXP=300;;
    7) EXP=590;;
    8) EXP=700;;
    9) EXP=800;;
    10) EXP=900;;
    11) EXP=1000;;
    12) EXP=1100;;
    13) EXP=1145;;
    14) EXP=1200;;
    15) EXP=1275;;
    16) EXP=1300;;
    17) EXP=1405;;
    18) EXP=1450;;
    19) EXP=1531;;
    20) EXP=1607;;
    21) EXP=1700;;
    22) EXP=1800;;
    23) EXP=1900;;
    24) EXP=2000;;
    25) EXP=2047;;
  esac
}

expView ()
{
  case ${1} in
    1) EXPVIEW="7.9 sec";;
    8) EXPVIEW="7.7 sec";;
    50) EXPVIEW="6.1 sec";;
    100) EXPVIEW="4.6 sec";;
    200) EXPVIEW="2.7 sec";;
    300) EXPVIEW="1 sec";;
    590) EXPVIEW="1/3 sec";;
    700) EXPVIEW="1/5 sec";;
    800) EXPVIEW="1/10 sec";;
    900) EXPVIEW="1/15 sec";;
    1000) EXPVIEW="1/30 sec";;
    1100) EXPVIEW="1/50 sec";;
    1145) EXPVIEW="1/60 sec";;
    1200) EXPVIEW="1/80 sec";;
    1275) EXPVIEW="1/125 sec";;
    1300) EXPVIEW="1/140 sec";;
    1405) EXPVIEW="1/250 sec";;
    1450) EXPVIEW="1/320 sec";;
    1531) EXPVIEW="1/500 sec";;
    1607) EXPVIEW="1/752 sec";;
    1700) EXPVIEW="1/1244 sec";;
    1800) EXPVIEW="1/2138 sec";;
    1900) EXPVIEW="1/3675 sec";;
    2000) EXPVIEW="1/6316 sec";;
    2047) EXPVIEW="1/8147 sec";;
    *) EXPVIEW="Auto";;
  esac
}

getISOInput ()
{
  clear
  echo " *********** ${XYC_ISO_MENU} *********** "
  echo " * (0)=Auto   (5)=1600             * "
  echo " * (1)=100    (6)=3200             * "
  echo " * (2)=200    (7)=6400             * "
  echo " * (3)=400    (8)=12800 Warning!   * "
  echo " * (4)=800    (9)=25600 Warning!   * "
  echo " *********************************** "
  local REPLY=$ISO
  read -p "${XYC_SELECT_OPTION}: 0-9: " REPLY
  case $REPLY in
    0) unset ISO;;
    1) ISO=100;;
    2) ISO=200;;
    3) ISO=400;;
    4) ISO=800;;
    5) ISO=1600;;
    6) ISO=3200;;
    7) ISO=6400;;
    8) ISO=12800;;
    9) ISO=25600;;
  esac
}

getAWBInput ()
{
  clear
  local REPLY
  read -p "${XYC_ENTER_AWB_PROMPT} [${XYC_ENTER}]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then AWB=$REPLY; fi
}

getNRInput ()
{
  clear
  echo " ******* ${XYC_NR_MENU} ****** "
  echo " * (0) ${XYC_DEFAULT}                     * "
  echo " * (1) ${XYC_DISABLE_NR}                  * "
  echo " * (2) NR 500                      * "
  echo " * (3) NR 2048                     * "
  echo " * (4) ${XYC_MAX_NR}                      * "
  echo " * (5) ${XYC_CUSTOM}                      * "
  echo " *********************************** "
  local REPLY
  read -p "${XYC_SELECT_OPTION}: 0-5: " REPLY
  case $REPLY in
    0) unset NR;;
    1) NR=-1;;
    2) NR=500;;
    3) NR=2048;;
    4) NR=16383;;
    5) getCustomNRInput;;
  esac
}

getCustomNRInput ()
{
  clear
  local REPLY=$NR
  read -p "${XYC_CUSTOM_NR_PROMPT} [${XYC_ENTER}=$NR]: " REPLY
  if [ -n "$REPLY" ]; then
    if [[ $REPLY -le 16383 && $REPLY -ge 0 ]]; then NR=$REPLY; fi
  fi
}

getAAAInput ()
{
  clear
  local REPLY
  read -p "${XYC_AAA_PROMPT} [${XYC_ENTER}]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then AAA=$REPLY; fi
}

getGammaInput ()
{
  clear
  echo " *********** ${XYC_GAMMA_MENU} ************ "
  echo " * (0) ${XYC_DEFAULT}                     * "
  echo " * (1) Gamma 220                   * "
  echo " * (2) Gamma 255                   * "
  echo " * (3) ${XYC_CUSTOM}                      * "
  echo " *********************************** "
  local REPLY
  read -p "${XYC_SELECT_OPTION}: 0-3: " REPLY
  case $REPLY in
    0) unset GAMMA;;
    1) GAMMA=220;;
    2) GAMMA=255;;
    3) getCustomGammaInput;;
  esac
}

getCustomGammaInput ()
{
  clear
  local REPLY=$GAMMA
  read -p "${XYC_GAMMA_PROMPT} [${XYC_ENTER}=$GAMMA]: " REPLY
  if [ -n "$REPLY" ]; then
    if [[ $REPLY -le 255 && $REPLY -ge 0 ]]; then GAMMA=$REPLY; fi
  fi
}

getAutoKneeInput ()
{
  clear
  echo " ********* ${XYC_AUTOKNEE_MENU} ********** "
  echo " * (0) ${XYC_DEFAULT}                     * "
  echo " * (1) AutoKnee 255                * "
  echo " * (2) ${XYC_CUSTOM}                      * "
  echo " *********************************** "
  local REPLY
  read -p "${XYC_SELECT_OPTION}: 0-2: " REPLY
  case $REPLY in
    0) unset AUTOKNEE;;
    1) AUTOKNEE=255;;
    2) getCustomAutoKneeInput;;
  esac
}

getCustomAutoKneeInput ()
{
  clear
  local REPLY=$AUTOKNEE
  read -p "${XYC_AUTOKNEE_PROMPT} [${XYC_ENTER}=$AUTOKNEE]: " REPLY
  if [ -n "$REPLY" ]; then
    if [[ $REPLY -le 255 && $REPLY -ge 0 ]]; then AUTOKNEE=$REPLY; fi
  fi
}

getVibSatInput ()
{
  clear
  local REPLY
  read -p "${XYC_VIBSAT_PROMPT} [${XYC_ENTER}]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then VIBSAT=$REPLY; fi
}

getRawInput ()
{
  clear
  local REPLY
  read -p "${XYC_CREATE_RAW_PROMPT} [${XYC_ENTER}]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then RAW=$REPLY; fi
}

getSharpnessInput ()
{
  clear
  echo " ********** ${XYC_SHARPNESS_MODE} ********* "
  echo " * (0) ${XYC_SHR_MODE_VIDEO}                       * "
  echo " * (1) ${XYC_SHR_MODE_FAST}                  * "
  echo " * (2) ${XYC_SHR_MODE_LOWISO}                * "
  echo " * (3) ${XYC_SHR_MODE_HIGHISO}               * "
  echo " * (4) ${XYC_DEFAULT}                     * "
  echo " *********************************** "
  local REPLY=$SHR
  read -p "${XYC_SELECT_OPTION}: 0-4: " REPLY
  case $REPLY in
    0) SHR=0; getSharpFirInput;;
    1) SHR=1; getSharpFirInput;;
    2) SHR=2; getSharpFirInput;;
    3) SHR=3; getSharpFirInput;;
    4) unset SHR FIR COR; return;;
  esac
}

getSharpFirInput ()
{
  clear
  local REPLY=$FIR
  read -p "${XYC_SHARPNESS_FIR_PROMPT} [${XYC_ENTER}=$FIR]: " REPLY
  if [ -n "$REPLY" ]; then
    FIR=$REPLY;
  else
    FIR=100;
  fi
  getSharpCorInput
}

getSharpCorInput ()
{
  clear
  local REPLY=$COR
  read -p "${XYC_SHARPNESS_COR_PROMPT} [${XYC_ENTER}=$COR]: " REPLY
  if [ -n "$REPLY" ]; then
    COR=$REPLY;
  else
    COR=104;
  fi
}

getVideoResolutionInput ()
{
  clear
  echo " ********* ${XYC_VIDEO_RESOLUTION} ******** "
  echo " * (0) ${XYC_DEFAULT}   (4) 1920x1080     * "
  echo " * (1) 1280x720  (5) 2304x1296     * "
  echo " * (2) 1280x960  (6) 2560x1440     * "
  echo " * (3) 1600x1200                   * "
  echo " *********************************** "
  local REPLY=$RES
  read -p "${XYC_SELECT_OPTION}: 0-6: " REPLY
  case $REPLY in
    0) unset RES FPS; return;;
    1) RES=1; getVideoFrequencyInput;;
    2) RES=2; getVideoFrequencyInput;;
    3) RES=3; getVideoFrequencyInput;;
    4) RES=4; getVideoFrequencyInput;;
    5) RES=5; FPS=2;;
    6) RES=6; FPS=2;;
  esac
  setRESView
}

getVideoFrequencyInput ()
{
  clear
  echo " ********* ${XYC_VIDEO_FREQUENCY} ********* "
  echo " * (1) 24 FPS                      * "
  echo " * (2) 30 FPS                      * "
  echo " * (3) 48 FPS                      * "
  echo " * (4) 60 FPS                      * "
  if [ $RES -eq 1 ]; then
    echo " * (5) 120 FPS                     * "
  fi
  echo " *********************************** "
  local REPLY=$FPS
  read -p "${XYC_SELECT_OPTION}: " REPLY
  case $REPLY in
    1) FPS=1;;
    3) FPS=3;;
    4) FPS=4;;
    5)  if [ $RES -eq 1 ]; then
          FPS=5
        else
          FPS=2
        fi;;
    *) FPS=2;;
  esac
}

getVideoBitrateInput ()
{
  clear
  echo " ********** ${XYC_VIDEO_BITRATE} ********** "
  echo " * (0) ${XYC_DEFAULT}    (4) 35 Mb/s      * "
  echo " * (1) 20 Mb/s    (5) 40 Mb/s      * "
  echo " * (2) 25 Mb/s    (6) 45 Mb/s      * "
  echo " * (3) 30 Mb/s    (7) 50 Mb/s      * "
  echo " *********************************** "
  local REPLY=$BIT
  read -p "${XYC_SELECT_OPTION}: 0-7: " REPLY
  case $REPLY in
    0) unset BIT; return;;
    1) BIT="0x41A0";;
    2) BIT="0x41C8";;
    3) BIT="0x41F0";;
    4) BIT="0x420C";;
    5) BIT="0x4220";;
    6) BIT="0x4234";;
    7) BIT="0x4248";;
  esac
  setBITView
}

setRESView ()
{
  if [ -z "$RES" ]; then return; fi
  if [ $RES -eq 1 ]; then
    RESVIEW="720p"
    if [ $FPS -eq 1 ]; then
      RESVIEW="$RESVIEW@24"
    elif [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 3 ]; then
      RESVIEW="$RESVIEW@48"
    elif [ $FPS -eq 4 ]; then
      RESVIEW="$RESVIEW@60"
    elif [ $FPS -eq 5 ]; then
      RESVIEW="$RESVIEW@120"
    fi
  elif [ $RES -eq 2 ]; then
    RESVIEW="960p"
    if [ $FPS -eq 1 ]; then
      RESVIEW="$RESVIEW@24"
    elif [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 3 ]; then
      RESVIEW="$RESVIEW@48"
    elif [ $FPS -eq 4 ]; then
      RESVIEW="$RESVIEW@60"
    fi
  elif [ $RES -eq 3 ]; then
    RESVIEW="HD"
    if [ $FPS -eq 1 ]; then
      RESVIEW="$RESVIEW@24"
    elif [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 3 ]; then
      RESVIEW="$RESVIEW@48"
    elif [ $FPS -eq 4 ]; then
      RESVIEW="$RESVIEW@60"
    fi
  elif [ $RES -eq 4 ]; then
    RESVIEW="1080p"
    if [ $FPS -eq 1 ]; then
      RESVIEW="$RESVIEW@24"
    elif [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 3 ]; then
      RESVIEW="$RESVIEW@48"
    elif [ $FPS -eq 4 ]; then
      RESVIEW="$RESVIEW@60"
    fi
  elif [ $RES -eq 5 ]; then
    RESVIEW="1296p"
    if [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    fi
  elif [ $RES -eq 6 ]; then
    RESVIEW="1440p"
    if [ $FPS -eq 2 ]; then
      RESVIEW="$RESVIEW@30"
    fi
  fi
}

setBITView ()
{
  if [ -z "$BIT" ]; then return; fi
  if [ "$BIT" == "0x41A0" ]; then
    BITVIEW="20Mb"
  elif [ "$BIT" == "0x41C8" ]; then
    BITVIEW="25Mb"
  elif [ "$BIT" == "0x41F0" ]; then
    BITVIEW="30Mb"
  elif [ "$BIT" == "0x420C" ]; then
    BITVIEW="35Mb"
  elif [ "$BIT" == "0x4220" ]; then
    BITVIEW="40Mb"
  elif [ "$BIT" == "0x4234" ]; then
    BITVIEW="45Mb"
  elif [ "$BIT" == "0x4248" ]; then
    BITVIEW="50Mb"
  fi
}

getBigFileInput ()
{
  clear
  local REPLY
  read -p "${XYC_BIG_FILE_PROMPT} [${XYC_ENTER}]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then BIG_FILE=$REPLY; fi
}

getIncludeUserSettings ()
{
  clear
  if [ "$INC_USER" == ${XYC_Y} ]; then
    echo " * ${XYC_USER_IMPORT}: ${XYC_YES}"
    echo ""
  fi
  if [[ -f "$USER_SETTINGS_FILE" && -r "$USER_SETTINGS_FILE" ]]; then
    local REPLY
    read -p "${XYC_INCLUDE_USER_SETTINGS_PROMPT} [${XYC_ENTER}]: " REPLY
    if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then
      INC_USER=$REPLY;
      clear; writeAutoexec;
      return;
    fi
  else
    echo "${XYC_CANNOT_READ} $USER_SETTINGS_FILE"
    echo "${XYC_CREATE_FILE} $USER_SETTINGS_FILE"
    echo ""
    read -p "[${XYC_ENTER}]"
  fi
  clear
}

getTLModeInput()
{
  clear
  echo " ********* ${XYC_TIME_LAPSE_MODE} ********* "
  echo " * (0) ${XYC_CUSTOM}                      * "
  echo " * (1) ${XYC_INVINITY}                    * "
  echo " * (2) ${XYC_HDR}                         * "
  echo " *********************************** "
  local REPLY=$TLMODE
  read -p "${XYC_SELECT_OPTION}: 0-2: " REPLY
  case $REPLY in
    0) TLMODE=0;;
    1) TLMODE=1;;
    2) TLMODE=2;;
  esac
}

getTLDelayInput()
{
  clear
  local REPLY=$TLDELAY
  read -p "${XYC_CYCLES_INTERVAL_PROMPT} [${XYC_ENTER}=$REPLY]: " REPLY
  if [[ $REPLY -le 3600 && $REPLY -ge 1 ]]; then
    TLDELAY=$REPLY
  fi
}

getTLNumShotsInput()
{
  clear
  local REPLY=$TLNUM
  read -p "${XYC_NUM_CYCLES_PROMPT} [${XYC_ENTER}=$REPLY]: " REPLY
  if [[ $REPLY -le 360 && $REPLY -ge 1 ]]; then
    TLNUM=$REPLY
    TLMODE=0
  fi
}

getTLOnceInput()
{
  clear
  local REPLY
  read -p "${XYC_RUN_ONCE_ONLY_PROMPT} [${XYC_ENTER}]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    TLONCE=${XYC_Y}
    TLMODE=0
  elif [ "$REPLY" == ${XYC_N} ]; then
    TLONCE=${XYC_N}
  fi
}

getTLOffInput()
{
  clear
  local REPLY
  read -p "${XYC_POWEROFF_WHEN_COMPLETE_PROMPT} [${XYC_ENTER}]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    TLOFF=${XYC_Y}
    TLMODE=0
  elif [ "$REPLY" == ${XYC_N} ]; then
    TLOFF=${XYC_N}
  fi
}

getHDRInput ()
{
  clear
  local REPLY=0
  while [ $REPLY -eq 0 ]
  do
    echo " ************** ${XYC_HDR}1 *************** "
    echo " *  (1)=4.6    (3)=1     (5)=1/5   * "
    echo " *  (2)=2.7    (4)=1/3   (6)=1/10  * "
    echo " *********************************** "
    read -p "${XYC_SELECT_OPTION}: 1-6: " REPLY
    case $REPLY in
      1) HDR1=100; HEHE1=1;;
      2) HDR1=200; HEHE1=2;;
      3) HDR1=300; HEHE1=3;;
      4) HDR1=590; HEHE1=4;;
      5) HDR1=700; HEHE1=5;;
      6) HDR1=800; HEHE1=6;;
      *) clear; echo "${XYC_INVALID_CHOICE}"; REPLY=0;;
    esac
  done
  clear
  expView $HDR1
  HDR1VIEW=$EXPVIEW
  local REPLY=0
  while [ $REPLY -eq 0 ]
  do
    echo " * ${XYC_HDR}1    : $HDR1VIEW        "
    echo ""
    echo " ************** ${XYC_HDR}2 *************** "
    echo " * (1)=1/15   (3)=1/50   (5)=1/140 * "
    echo " * (2)=1/30   (4)=1/80   (6)=1/250 * "
    echo " *********************************** "
    read -p "${XYC_SELECT_OPTION}: 1-6: " REPLY
    case $REPLY in
      1) HDR2=900; HEHE2=1;;
      2) HDR2=1000; HEHE2=2;;
      3) HDR2=1100; HEHE2=3;;
      4) HDR2=1200; HEHE2=4;;
      5) HDR2=1300; HEHE2=5;;
      6) HDR2=1405; HEHE2=6;;
      *) clear; echo "${XYC_INVALID_CHOICE}"; REPLY=0;;
    esac
  done
  clear
  expView $HDR2
  HDR2VIEW=$EXPVIEW
  local REPLY=0
  while [ $REPLY -eq 0 ]
  do
    echo " * ${XYC_HDR}1    : $HDR1VIEW        "
    echo " * ${XYC_HDR}2    : $HDR2VIEW        "
    echo ""
    echo " ************** ${XYC_HDR}3 *************** "
    echo " * (1)=1/500 (3)=1/1244 (5)=1/3675 * "
    echo " * (2)=1/752 (4)=1/2138 (6)=1/6316 * "
    echo " *********************************** "
    read -p "${XYC_SELECT_OPTION}: 1-6: " REPLY
    case $REPLY in
      1) HDR3=1531; HEHE3=1;;
      2) HDR3=1607; HEHE3=2;;
      3) HDR3=1700; HEHE3=3;;
      4) HDR3=1800; HEHE3=4;;
      5) HDR3=1900; HEHE3=5;;
      6) HDR3=2000; HEHE3=6;;
      *) clear; echo "${XYC_INVALID_CHOICE}"; REPLY=0;;
    esac
  done
  clear
}

getCreatePresetInput ()
{
  clear
  local NAME
  while [ -z "$NAME" ]
  do
    local REPLY
    read -p "${XYC_NEW_PRESET_PROMPT} [${XYC_ENTER}]: " REPLY
    if [ -z "$REPLY" ]; then
      clear; return;
    else
      REPLY=${REPLY//[[:space:]]/}
    fi
    if [[ ! -f "$PRESETS_FILE" ]]; then
      echo "Creating $PRESETS_FILE"
      echo "# Created by XYC $VERS" > $PRESETS_FILE
      echo "# https://github.com/alex-agency/XYC" >> $PRESETS_FILE
      echo "# XYC Presets config" >> $PRESETS_FILE
      NAME=$REPLY
    else
      if grep -Rq "^$REPLY." $PRESETS_FILE; then
        clear;
        echo "${XYC_NAME_EXIST}: $REPLY"
      else
        NAME=$REPLY
      fi
    fi
  done
  clear
  echo "Writing $PRESETS_FILE"
  echo "" >> $PRESETS_FILE
  echo "#Start $NAME" >> $PRESETS_FILE
  writePreset $NAME "ISO" "ISO"
  writePreset $NAME "EXP" "Exposure"
  writePreset $NAME "AWB" "AWB"
  writePreset $NAME "NR" "NR"
  writePreset $NAME "RAW" "RAW"
  writePreset $NAME "AUTAN" "HDR Mode"
  writePreset $NAME "HDR1" "HDR1"
  writePreset $NAME "HDR2" "HDR2"
  writePreset $NAME "HDR3" "HDR3"
  writePreset $NAME "SHR" "Sharpness Mode"
  writePreset $NAME "FIR" "Sharpness Digital Filter"
  writePreset $NAME "COR" "Sharpness Coring"
  writePreset $NAME "AAA" "AAA"
  writePreset $NAME "GAMMA" "Gamma"
  writePreset $NAME "AUTOKNEE" "Auto Knee"
  writePreset $NAME "VIBSAT" "Vibrance/Saturation"
  writePreset $NAME "RES" "Resolution"
  writePreset $NAME "FPS" "FPS"
  writePreset $NAME "BIT" "Bitrate"
  writePreset $NAME "BIG_FILE" "4Gb files"
  writePreset $NAME "INC_USER" "Import User settings"
  writePreset $NAME "TLMODE" "Time-lapse Mode"
  writePreset $NAME "TLDELAY" "Time-lapse Interval"
  writePreset $NAME "TLNUM" "Time-lapse Cycles"
  writePreset $NAME "TLONCE" "Time-lapse run once"
  writePreset $NAME "TLOFF" "Time-lapse poweroff"
  echo "#End $NAME" >> $PRESETS_FILE

  echo ""
  echo "${XYC_PRESET_CREATED}: $NAME"
  echo ""
  read -p "[${XYC_ENTER}]"
}

writePreset ()
{
  local VALUE
  eval VALUE="\$${2}"
  if [ -n "$VALUE" ]; then
    echo "${3}: $VALUE"
    echo "${1}.${2}=$VALUE #${3}" >> $PRESETS_FILE
  fi
}

showPresetsList ()
{
  clear
  local PRESET=$(grep -F '=' $PRESETS_FILE | cut -d '.' -f1 | sort -u )
  if [ -n "$PRESET" ]; then
    if [ "${1}" == "load" ]; then
      echo "    == ${XYC_LOAD_PRESET_MENU} =="
    else
      echo "    == ${XYC_REMOVE_PRESET_MENU} =="
    fi
    local i=1
    for item in $PRESET; do
      echo " [$((i++))] $item "
    done
    local REPLY
    read -p "${XYC_SELECT_OPTION}: " REPLY
    if [[ $REPLY -lt $i && $REPLY -ge 1 ]]; then
      local NAME=$(echo $PRESET | cut -d ' ' -f$REPLY)
      if [ "${1}" == "load" ]; then
        loadPreset $NAME
        return;
      else
        removePreset $NAME
      fi
    fi
  else
    echo ""
    echo "${XYC_NO_PRESETS}"
    echo ""
    read -p "[${XYC_ENTER}]"
  fi
  return 1;
}

loadPreset ()
{
  clear
  echo "Reading $PRESETS_FILE"
  while read line
  do
    if echo $line | grep "${1}\." >/dev/null; then
      local PARAM=$(echo "$line" | cut -d '.' -f 2)
      local INFO=$(echo "$PARAM" | cut -d '#' -f 2)
      local VALUE=$(echo "$PARAM" | cut -d '=' -f 2 | cut -d ' ' -f 1)

      eval $(echo "$PARAM" | cut -d ' ' -f 1)
      echo "$INFO: $VALUE"
    fi
  done < $PRESETS_FILE
  setMissingValues
  echo ""
  echo "${XYC_PRESET_LOADED}: $NAME"
  echo ""
  read -p "[${XYC_ENTER}]"
  clear
}

removePreset ()
{
  clear
  echo "Writing $PRESETS_FILE"
  echo "$(grep -v "^${1}\." $PRESETS_FILE)" > $PRESETS_FILE
  echo "$(grep -v " ${1}$" $PRESETS_FILE)" > $PRESETS_FILE
  echo ""
  echo "${XYC_PRESET_REMOVED}: $NAME"
  echo ""
  read -p "[${XYC_ENTER}]"
  clear
}

getDelaySuggestion ()
{
  #Delay should be sum of file write time (WT) and exposure time (ET)
  #if delay is too short, then the camera doesn't write the RAW file...
  #make delay longer as necessary, depending on shutter speed and SD card
  #performance
  local WT=10
  local ET=0
  if [ ${1} -ge 0 2> /dev/null ]; then
    if [ ${1} -eq 0 ]; then ET=1;
    elif [ ${1} -lt 30 ]; then ET=8;
    elif [ ${1} -lt 50 ]; then ET=7;
    elif [ ${1} -lt 90 ]; then ET=6;
    elif [ ${1} -lt 150 ]; then ET=5;
    elif [ ${1} -lt 200 ]; then ET=4;
    elif [ ${1} -lt 300 ]; then ET=3;
    elif [ ${1} -lt 400 ]; then ET=2;
    elif [ ${1} -lt 1000 ]; then ET=1;
    else ET=0;
    fi
  fi
  return $(expr $WT + $ET)
}

removeAutoexec ()
{
  echo "${XYC_DELETING} $AASH"
  rm -f $AASH
  if [[ -f "$CORCONF" && -w "$CORCONF" ]]; then
    echo "${XYC_DELETING} $CORCONF"
    rm -f $CORCONF
  fi
  echo ${XYC_RESTART_TO_APPLY}
  echo ""
}

writeAutoexec ()
{
  OUTFILE=${1:-$AASH}
  SCRIPT_TYPE=${2:-"settings"}
  echo "${XYC_WRITING} $OUTFILE"

  #Write any necessary script commands to autoexec.ash
  echo "# Generated by XYC $VERS, `date`" > $OUTFILE
  echo "# https://github.com/alex-agency/XYC" >> $OUTFILE
  echo "" >> $OUTFILE

  if [ "$VIBSAT" == ${XYC_Y} ]; then
    echo "#vibrance/saturation adjustments" >> $OUTFILE
    echo "t ia2 -adj ev 0 0 140 0 0 150 0" >> $OUTFILE
    echo "#enable portrait scene mode" >> $OUTFILE
    echo "# [1/13/14]: auto/landscape/portrait" >> $OUTFILE
    echo "# [34/38]: through_glass/car_DV" >> $OUTFILE
    echo "t cal -sc 14" >> $OUTFILE
    echo "#set JPEG quality to 100%" >> $OUTFILE
    echo "writeb 0xC0BC205B 0x64" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ -n "$AUTOKNEE" ]; then
    echo "#shadow/highlight clipping adjustments" >> $OUTFILE
    echo "#this makes blacks not crushed" >> $OUTFILE
    echo "#set long exposure level [0~255]" >> $OUTFILE
    echo "t ia2 -adj l_expo 163" >> $OUTFILE
    echo "#this gets back the highlights" >> $OUTFILE
    echo "#set Auto Knee level [0~255]" >> $OUTFILE
    echo "t ia2 -adj autoknee $AUTOKNEE" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ -n "$GAMMA" ]; then
    echo "#set gamma level [0~255]" >> $OUTFILE
    echo "t ia2 -adj gamma $GAMMA" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [[ -n "$ISO" || -n "$EXP" ]]; then
    echo "#set ISO and Exposure" >> $OUTFILE
    echo "# exp: [iso_idx][exp_idx][gain_idx], 0 auto" >> $OUTFILE
    if [ -z "$ISO" ]; then #ISO (Auto)
      echo "t ia2 -ae exp 0 $EXP 0" >> $OUTFILE
    elif [ -z "$EXP" ]; then  #Exposure (Auto)
      echo "t ia2 -ae exp $ISO 0 0" >> $OUTFILE
    else
      echo "t ia2 -ae exp $ISO $EXP 0" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  fi

  if [ "$AWB" == ${XYC_N} ]; then
    echo "#disable Auto White Balance" >> $OUTFILE
    echo "t ia2 -awb off" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ -n "$NR" ]; then
    echo "#set Noise Reduction" >> $OUTFILE
    echo "# tidx: [ev_idx][nf_idx][shutter_idx], -1 disable" >> $OUTFILE
    echo "# [nf_idx]: 0-16383, 0 no noise (sharper video)" >> $OUTFILE
    echo "t ia2 -adj tidx -1 $NR -1" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ -n "$SHR" ]; then
    echo "#Sharpness: $SHR $FIR $COR" >> $OUTFILE
    echo "#set sharpness" >> $OUTFILE
    echo "t is2 -shp mode $SHR" >> $OUTFILE
    echo "t is2 -shp fir $FIR 0 0 0 0 0 0" >> $OUTFILE
    echo "t is2 -shp max_change 5 5" >> $OUTFILE
    echo "t is2 -shp cor d:\sharpening.config" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "" >> $OUTFILE

    echo "Writing $CORCONF"
    #Write any necessary script commands to sharpening.config
    echo "# Generated by XYC $VERS, `date`" > $CORCONF
    echo "# https://github.com/alex-agency/XYC" >> $CORCONF
    echo "# Sharpening Coring script" >> $CORCONF
    echo "$COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR" >> $CORCONF
    echo "" >> $CORCONF
  fi

  if [ $RES -eq 1 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 1 ]; then                         #1280x720 24fps
      echo "writeb 0xC06CC426 0x28" >> $OUTFILE
      echo "writel 0xC05C2FAC 0x02D00500" >> $OUTFILE
    elif [ $FPS -eq 2 ]; then                       #1280x720 30fps
      echo "writeb 0xC06CC426 0x11" >> $OUTFILE
      echo "writel 0xC05C2DE0 0x02D00500" >> $OUTFILE
    elif [ $FPS -eq 3 ]; then                       #1280x720 48fps
      echo "writeb 0xC06CC426 0x27" >> $OUTFILE
      echo "writel 0xC05C2F98 0x02D00500" >> $OUTFILE
    elif [ $FPS -eq 4 ]; then                       #1280x720 60fps
      echo "writeb 0xC06CC426 0x0F" >> $OUTFILE
      echo "writel 0xC05C2DB8 0x02D00500" >> $OUTFILE
    elif [ $FPS -eq 5 ]; then                       #1280x720 120fps
      echo "writeb 0xC06CC426 0x34" >> $OUTFILE
      echo "writel 0xC05C309C 0x02D00500" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 2 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 1 ]; then                         #1280x960 24fps
      echo "writeb 0xC06CC426 0x26" >> $OUTFILE
      echo "writel 0xC05C2F84 0x03C00500" >> $OUTFILE
    elif [ $FPS -eq 2 ]; then                       #1280x960 30fps
      echo "writeb 0xC06CC426 0x17" >> $OUTFILE
      echo "writel 0xC05C2E58 0x03C00500" >> $OUTFILE
    elif [ $FPS -eq 3 ]; then                       #1280x960 48fps
      echo "writeb 0xC06CC426 0x25" >> $OUTFILE
      echo "writel 0xC05C2F70 0x03C00500" >> $OUTFILE
    elif [ $FPS -eq 4 ]; then                       #1280x960 60fps
      echo "writeb 0xC06CC426 0x16" >> $OUTFILE
      echo "writel 0xC05C2E44 0x03C00500" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 3 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 1 ]; then                         #1600x1200 24fps
      echo "writeb 0xC06CC426 0x24" >> $OUTFILE
      echo "writel 0xC05C2F5C 0x04B00640" >> $OUTFILE
    elif [ $FPS -eq 2 ]; then                       #1600x1200 30fps
      echo "writeb 0xC06CC426 0x0D" >> $OUTFILE
      echo "writel 0xC05C2D90 0x04B00640" >> $OUTFILE
    elif [ $FPS -eq 3 ]; then                       #1600x1200 48fps
      echo "writeb 0xC06CC426 0x23" >> $OUTFILE
      echo "writel 0xC05C2F48 0x04B00640" >> $OUTFILE
    elif [ $FPS -eq 4 ]; then                       #1600x1200 60fps
      echo "writeb 0xC06CC426 0x0C" >> $OUTFILE
      echo "writel 0xC05C2D7C 0x04B00640" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 4 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 1 ]; then                         #1920x1080 24fps
      echo "writeb 0xC06CC426 0x21" >> $OUTFILE
      echo "writel 0xC05C2F20 0x04380780" >> $OUTFILE
    elif [ $FPS -eq 2 ]; then                       #1920x1080 30fps
      echo "writeb 0xC06CC426 0x06" >> $OUTFILE
      echo "writel 0xC05C2D04 0x04380780" >> $OUTFILE
    elif [ $FPS -eq 3 ]; then                       #1920x1080 48fps
      echo "writeb 0xC06CC426 0x20" >> $OUTFILE
      echo "writel 0xC05C2F0C 0x04380780" >> $OUTFILE
    elif [ $FPS -eq 4 ]; then                       #1920x1080 60fps
      echo "writeb 0xC06CC426 0x03" >> $OUTFILE
      echo "writel 0xC05C2CC8 0x04380780" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 5 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 2 ]; then                       #2304x1296 30fps
      echo "writeb 0xC06CC426 0x02" >> $OUTFILE
      echo "writel 0xC05C2CB4 0x05100900" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 6 2> /dev/null ]; then
    echo "#set video $RESVIEW" >> $OUTFILE
    if [ $FPS -eq 2 ]; then                       #2560x1440 30fps
      echo "writeb 0xC06CC426 0x02" >> $OUTFILE
      echo "writel 0xC05C2CB4 0x05A00A00" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  fi

  if [ -n "$BIT" ]; then
    echo "#set $BITVIEW bitrate for all resolutions" >> $OUTFILE
    echo "#1280x720 24fps" >> $OUTFILE
    echo "writew 0xC05C25D2 $BIT" >> $OUTFILE
    echo "#1280x720 30fps" >> $OUTFILE
    echo "writew 0xC05C2182 $BIT" >> $OUTFILE
    echo "#1280x720 48fps" >> $OUTFILE
    echo "writew 0xC05C25A2 $BIT" >> $OUTFILE
    echo "#1280x720 60fps" >> $OUTFILE
    echo "writew 0xC05C2122 $BIT" >> $OUTFILE
    echo "#1280x720 120fps" >> $OUTFILE
    echo "writew 0xC05C2812 $BIT" >> $OUTFILE
    echo "#1280x960 24fps" >> $OUTFILE
    echo "writew 0xC05C2572 $BIT" >> $OUTFILE
    echo "#1280x960 30fps" >> $OUTFILE
    echo "writew 0xC05C22A2 $BIT" >> $OUTFILE
    echo "#1280x960 48fps" >> $OUTFILE
    echo "writew 0xC05C2542 $BIT" >> $OUTFILE
    echo "#1280x960 60fps" >> $OUTFILE
    echo "writew 0xC05C2272 $BIT" >> $OUTFILE
    echo "#1600x1200 24fps" >> $OUTFILE
    echo "writew 0xC05C2512 $BIT" >> $OUTFILE
    echo "#1600x1200 30fps" >> $OUTFILE
    echo "writew 0xC05C20C2 $BIT" >> $OUTFILE
    echo "#1600x1200 48fps" >> $OUTFILE
    echo "writew 0xC05C24E2 $BIT" >> $OUTFILE
    echo "#1600x1200 60fps" >> $OUTFILE
    echo "writew 0xC05C2092 $BIT" >> $OUTFILE
    echo "#1920x1080 24fps" >> $OUTFILE
    echo "writew 0xC05C2482 $BIT" >> $OUTFILE
    echo "#1920x1080 30fps" >> $OUTFILE
    echo "writew 0xC05C1F72 $BIT" >> $OUTFILE
    echo "#1920x1080 48fps" >> $OUTFILE
    echo "writew 0xC05C2452 $BIT" >> $OUTFILE
    echo "#1920x1080 60fps" >> $OUTFILE
    echo "writew 0xC05C1EE2 $BIT" >> $OUTFILE
    echo "#2304x1296 30fps" >> $OUTFILE
    echo "writew 0xC05C1EB2 $BIT" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$RAW" == ${XYC_Y} ]; then
    echo "#create RAW files" >> $OUTFILE
    echo "t app test debug_dump 14" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$BIG_FILE" == ${XYC_Y} ]; then
    echo "#set 4GB file weight limit" >> $OUTFILE
    echo "writew 0xC03A8520 0x2004" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$AAA" == ${XYC_Y} ]; then
    echo "#set AAA function" >> $OUTFILE
    echo "# -3a [ae][awb][af][adj]: turn on/off ae/awb/af/adj" >> $OUTFILE
    echo "#  ae = [0|1], 0:on 1:off AE" >> $OUTFILE
    echo "#  awb = [0|1], 0:on 1:off AWB" >> $OUTFILE
    echo "#  af  = [0|1], 0:on 1:off AF" >> $OUTFILE
    echo "#  adj = [0|1], 0:on 1:off ADJ" >> $OUTFILE
    echo "t ia2 -3a 1 1 0 1" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$INC_USER" == ${XYC_Y} ]; then
    if [[ -f "$USER_SETTINGS_FILE" && -r "$USER_SETTINGS_FILE" ]]; then
    echo "#User settings imported from $USER_SETTINGS_FILE" >> $OUTFILE
      cat $USER_SETTINGS_FILE >> $OUTFILE
      echo "#End user settings" >> $OUTFILE
      echo "" >> $OUTFILE
    else
      echo "${XYC_CANNOT_READ} $USER_SETTINGS_FILE"
      echo "#${XYC_CANNOT_READ} $USER_SETTINGS_FILE" >> $OUTFILE
    fi
  fi

  echo "#set buzzer volume 1-150" >> $OUTFILE
  echo "t pwm 1 set_level 75" >> $OUTFILE
  echo "" >> $OUTFILE
  echo "#front led blink" >> $OUTFILE
  echo "t gpio 6 sw out1" >> $OUTFILE         #front blue on
  echo "sleep 1" >> $OUTFILE
  echo "t gpio 6 sw out0" >> $OUTFILE         #front blue off
  echo "t gpio 54 sw out1" >> $OUTFILE        #front red on
  echo "sleep 1" >> $OUTFILE
  echo "t gpio 54 sw out0" >> $OUTFILE        #front red off
  echo "#short beep & front leds" >> $OUTFILE
  echo "t gpio 6 sw out1" >> $OUTFILE         #front blue on
  echo "t gpio 54 sw out1" >> $OUTFILE        #front red on
  echo "t pwm 1 enable" >> $OUTFILE           #beep on
  echo "sleep 1" >> $OUTFILE
  echo "t gpio 6 sw out0" >> $OUTFILE         #front blue off
  echo "t gpio 54 sw out0" >> $OUTFILE        #front red off
  echo "t pwm 1 disable" >> $OUTFILE          #beep off
  echo "" >> $OUTFILE

  if [ -n "$AUTAN" ]; then
    if [ $TLMODE -eq 2 2> /dev/null ]; then
      echo "#Time-lapse: $TLMODE $TLDELAY" >> $OUTFILE
      echo "while true; do" >> $OUTFILE
      echo "" >> $OUTFILE
    fi

    echo "#HDRParams: $AUTAN $HDR1 $HDR2 $HDR3" >> $OUTFILE
    echo "sleep 10" >> $OUTFILE
    echo "t ia2 -ae still_shutter $HDR1" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    echo "t app key shutter_rel" >> $OUTFILE
    getDelaySuggestion $HDR1
    echo "sleep $?" >> $OUTFILE
    if [ $AUTAN -eq 1 ]; then
      echo "t ia2 -ae still_shutter 1100" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 1100
      echo "sleep $?" >> $OUTFILE
      echo "t ia2 -ae still_shutter 1405" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 1405
      echo "sleep $?" >> $OUTFILE
    elif [ $AUTAN -eq 2 ]; then
      echo "t ia2 -ae still_shutter 100" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 100
      echo "sleep $?" >> $OUTFILE
      echo "t ia2 -ae still_shutter 200" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 200
      echo "sleep $?" >> $OUTFILE
    fi
    echo "t ia2 -ae still_shutter $HDR2" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    echo "t app key shutter_rel" >> $OUTFILE
    getDelaySuggestion $HDR2
    echo "sleep $?" >> $OUTFILE
    if [ $AUTAN -eq 1 ]; then
      echo "t ia2 -ae still_shutter 1700" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 1700
      echo "sleep $?" >> $OUTFILE
    elif [ $AUTAN -eq 2 ]; then
      echo "t ia2 -ae still_shutter 590" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      getDelaySuggestion 590
      echo "sleep $?" >> $OUTFILE
    fi
    echo "t ia2 -ae still_shutter $HDR3" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    echo "t app key shutter_rel" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "" >> $OUTFILE

    if [ $TLMODE -eq 2 2> /dev/null ]; then
      echo "  sleep $TLDELAY" >> $OUTFILE
      echo "done" >> $OUTFILE
      echo "" >> $OUTFILE
    fi
  fi

  if [ $TLMODE -eq 1 2> /dev/null ]; then
    echo "#Time-lapse: $TLMODE $TLDELAY" >> $OUTFILE
    echo "sleep 10" >> $OUTFILE
    echo "while true; do" >> $OUTFILE
    echo "  t app key shutter" >> $OUTFILE
    echo "  t app key shutter_rel" >> $OUTFILE
    echo "  sleep $TLDELAY" >> $OUTFILE
    echo "done" >> $OUTFILE
    echo "" >> $OUTFILE
  elif [ $TLMODE -eq 0 2> /dev/null ]; then
    echo "#Time-lapse: $TLMODE $TLDELAY $TLNUM $TLONCE $TLOFF" >> $OUTFILE
    echo "sleep 10" >> $OUTFILE
    for i in $(seq 1 $TLNUM); do
      echo "t app key shutter" >> $OUTFILE
      echo "t app key shutter_rel" >> $OUTFILE
      echo "sleep $TLDELAY" >> $OUTFILE
    done
    if [ "$TLONCE" == ${XYC_Y} ]; then
      echo "#remove time-lapse after first usage" >> $OUTFILE
      echo "lu_util exec '$THIS_SCRIPT -t'" >> $OUTFILE
    fi
    if [ "$TLOFF" == ${XYC_Y} ]; then
      echo "poweroff yes" >> $OUTFILE
    fi
    echo "" >> $OUTFILE
  fi
  
  if [ "$WIFI_CLIENT" == ${XYC_Y} ]; then
    echo "sleep 10" >> $OUTFILE
    echo "t pwm 1 enable" >> $OUTFILE
    echo "sleep .5" >> $OUTFILE
    echo "t pwm 1 disable" >> $OUTFILE
    echo "lu_util exec '/tmp/fuse_d/wifi/sta.sh'" >> $OUTFILE
    echo "t pwm 1 enable" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t pwm 1 disable" >> $OUTFILE
  fi
  if [ "$WIFI_WATCHDOG" == ${XYC_Y} ]; then
    echo "lu_util exec '/tmp/fuse_d/wifi/watchdog.sh'" >> $OUTFILE
  fi

  echo ${XYC_RESTART_TO_APPLY}
  echo ""
}

updateXYC ()
{
  local REPLY
  read -p "${XYC_UPDATE_NOW_PROMPT} [${XYC_ENTER}=n]: " REPLY
  if [[ -z "$REPLY" || "$REPLY" == ${XYC_N} ]]; then
    return 1;
  fi
  echo ""
  echo " *********************************** "
  echo " *                                 * "
  echo " *        ${XYC_UPDATING_NOW}...          * "
  echo " *                                 * "
  echo " *********************************** "
  echo ""
  sleep 1
  clear
  cd $SCRIPT_DIR
  local URL="https://raw.githubusercontent.com/alex-agency/XYC/master/xyc.sh"
  if which wget >/dev/null; then
    if wget -S --spider $URL 2>&1 | grep 'HTTP/1.1 200 OK'; then
      wget -O xyc.sh $URL
      return;
    else
      echo ""
      echo " ${XYC_NO_INTERNET}"
      echo " ${XYC_UPDATE_ERROR}"
    fi
  elif which curl >/dev/null; then
    if curl -sSf $URL >/dev/null; then
      curl $URL > xyc.sh
      return;
    else
      echo ""
      echo " ${XYC_NO_INTERNET}"
      echo " ${XYC_UPDATE_ERROR}"
    fi
  else
    echo ""
    echo " wget: command not found "
    echo " curl: command not found "
    echo " ${XYC_UPDATE_ERROR}"
  fi
  return 1;
}


#Main program
parseExistingAutoexec
parseCommandLine $*
setMissingValues
welcome
showMainMenu

if [ "$EXITACTION" == "update" ]; then
  if updateXYC; then
    echo ""
    echo " ${XYC_UPDATE_COMPLETE}"
  else
    echo ""
    echo " ${XYC_UPDATE_MANUAL}:"
    echo " https://github.com/alex-agency/XYC.git "
  fi
  echo ""
  read -p "[${XYC_ENTER}]"
  sh $SCRIPT_DIR/xyc.sh
elif [ "$EXITACTION" == "reboot" ]; then
  echo "The camera might be freezed after restart via telnet."
  echo "If you have this issue restart camera manualy."
  echo ""
  read -p "[${XYC_ENTER}]"
  clear
  echo ""
  echo " *********************************** "
  echo " *                                 * "
  echo " *        ${XYC_REBOOTING_NOW}...         * "
  echo " *                                 * "
  echo " *********************************** "
  echo ""
  sleep 1
  reboot yes
elif [ "$EXITACTION" == "poweroff" ]; then
  echo ""
  echo " *********************************** "
  echo " *                                 * "
  echo " *      ${XYC_SHUTTING_DOWN_NOW}...       * "
  echo " *                                 * "
  echo " *********************************** "
  echo ""
  sleep 1
  poweroff yes
fi
