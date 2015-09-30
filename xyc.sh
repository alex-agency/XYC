# Xiaomi Yi Configurator
# http://www.tawbaware.com
# (c) Tawbaware software, 2015
#
# Description: This script runs inside the Xiaomi Yi camera and allows the user
# to enable RAW file creation, and change photographic options such as
# exposure, ISO, whitebalance, etc.  In addition, a photographic time-lapse
# feature is also available.  It is designed to be executed and accessed via
# a telnet client running on any phone, computer, tablet, etc.
#
#
# Installation:
#
# 1. Install script at top level of SD card and ensure execute permissions:
#        chmod 755 /tmp/fuse_d/xyc.sh
# 2  Optional.  If you have custom settings (e.g. bitrate, video size, etc.)
#    that you want to be included in the autoexec.ash file, store these commands
#    in a  file named autoexec.xyc in the same directory as xyc.sh.  Also, using
#    XYC, set the "Custom Photo Settings" ->  "Import additional settings..."
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
# 0.3.3 (Oct 2015) - Added support for 2560x1440 30fps
# by Alex          - Added support file weight limit to 4GB
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

VERS="0.3.3 Alex"
FUSED=/tmp/fuse_d
#FUSED=`pwd`
AASH=${FUSED}/autoexec.ash
PRAWNCONF=${FUSED}/goprawn.config
CORCONF=${FUSED}/coring.config
SCRIPT_DIR=$(cd `dirname "$0"` && pwd)
THIS_SCRIPT="$SCRIPT_DIR/`basename "$0"`"
LANGUAGE_FILE="$SCRIPT_DIR/xyc_strings.sh"
USER_SETTINGS_FILE="$SCRIPT_DIR/autoexec.xyc"

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
XYC_VIEW_SETTINGS="View custom photo settings"
XYC_EDIT_SETTINGS="Edit custom photo settings"
XYC_VIEW_EDIT_SETTINGS="View/Edit camera settings"
XYC_RESET_SETTINGS="Reset/Delete camera settings"
XYC_CURRENT_SETTINGS="Current custom photo settings"
XYC_CREATE_TIME_LAPSE="Create/Run time-lapse script"
XYC_SHOW_CARD_SPACE="Show SD card space usage"
XYC_RESTART_CAMERA="Restart camera"
XYC_EXIT="Exit"
XYC_BACK="Back"
XYC_SAVE_AND_BACK="<- Save & Back"
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
XYC_REDUCE_NR="Reduce NR"
XYC_IMPORT_USER_SETTINGS="Import additional settings from"
XYC_YES="Yes"
XYC_NO="No"
XYC_Y="y"
XYC_N="n"
XYC_ON="On"
XYC_OFF="Off"
XYC_TIME_LAPSE_PARAMS="TLParams"
XYC_AUTO="Auto"
XYC_ENTER="Enter"
XYC_CHOOSE="Choose"
XYC_ENTER_AWB_PROMPT="Auto-Whitebalance (y/n)"
XYC_REDUCE_NR_PROMPT="Reduce noise-reduction (y/n)"
XYC_CREATE_RAW_PROMPT="Create RAW files (y/n)"
XYC_ENTER_NUM_SHOTS_MENU="Number of images (0=off)"
XYC_ENTER_NUM_SHOTS_PROMPT="Enter number of images (0=off, 1-9999)"
XYC_RUN_ONCE_ONLY_MENU="One-time script"
XYC_RUN_ONCE_ONLY_PROMPT="Run once only? (y=once/n=multi)"
XYC_POWEROFF_WHEN_COMPLETE_MENU="Poweroff when complete"
XYC_POWEROFF_WHEN_COMPLETE_PROMPT="Poweroff when complete (y/n)"
XYC_DELAY_BETWEEN_SHUTTER_MENU="Delay between shutter"
XYC_DELAY_BETWEEN_SHUTTER_PROMPT="Delay between shutter press (secs)"
XYC_RESTART_NOW_PROMPT="Restart camera now (y/n)"
XYC_REBOOTING_NOW="Rebooting now"
XYC_SHUTTING_DOWN_NOW="Shutting down now"
XYC_WRITING="Writing"
XYC_DELETING="Deleting"
XYC_CREATE_HDR="Create/Run HDR script"
XYC_PHOTO_SETTINGS_MENU="Custom Photo Settings Menu"
XYC_CAMERA_SETTINGS_MENU="Camera Settings Menu"
XYC_INCLUDE_USER_SETTINGS_PROMPT="Import additional settings from autoexec.xyc (y/n)"
XYC_TIME_LAPSE_MENU="Time Lapse Menu"
XYC_HDR_MENU="HDR Settings Menu"
XYC_CANNOT_READ="WARNING: Cannot read/access"
XYC_YIMAX_MOVIE="YiMax Movie"
XYC_USER_IMPORT="User Import"
XYC_YIMAX_PROMPT="YiMax Image Optimization (y/n)"
XYC_EXPOSURE_MENU="Exposure Setting"
XYC_ISO_MENU="ISO Setting"
XYC_SEC="sec"
XYC_REMOVING="Removing"
XYC_DELETE_VIDEO_PREVIEW_PROMPT="Delete All Video Preview files (y/n)"
XYC_DELETE_RAW_PROMPT="Delete All RAW files (y/n)"
XYC_HDR="HDR"
XYC_HDR_AUTO_DAY="HDR Auto"
XYC_HDR_AUTO_NIGHT="HDR Auto Night"
XYC_HDR_ADVANCED="HDR Advanced"
XYC_HDR_RESET="Delete HDR"
XYC_HDR_AFTER_RESTART="HDR photos will take after restart!"
XYC_HDR_EXPOSURE="HDR picture Exposure"
XYC_THIRD="Third"
XYC_SECOND="Second"
XYC_FIRST="First"
XYC_AVOID_LIGHT="*AVOID LIGHT*"
XYC_VIDEO_QUALITY="Video Quality"
XYC_DEFAULT="Default"
XYC_VIDEO_RESOLUTION="Video Resolution"
XYC_VIDEO_FREQUENCY="Video Frequency"
XYC_VIDEO_BITRATE="Video Bitrate"
XYC_SHADOW="Shadow Adj"
XYC_SHADOW_PROMPT="Shadow/Highlight/Gamma clipping adjustments (y/n)"
XYC_SHARPNESS="Sharpness"
XYC_SHARPNESS_MENU="Sharpness Menu"
XYC_SHARPNESS_MODE="Sharpness Mode"
XYC_SHARPNESS_FIR="Digital Filter"
XYC_SHARPNESS_COR="Coring"
XYC_RESET_DEFAULT="Reset to Default"
XYC_SHR_MODE_VIDEO="Video"
XYC_SHR_MODE_FAST="Fast Still"
XYC_SHR_MODE_LOWISO="LowISO Still"
XYC_SHR_MODE_HIGHISO="HighISO Still"
XYC_SHARPNESS_FIR_PROMPT="Coefficients of Digital Filter"
XYC_SHARPNESS_COR_PROMPT="Coefficients of Coring (1-255)"
XYC_BIG_FILE="4Gb files"
XYC_BIG_FILE_PROMPT="Expand file weight limit to 4GB (y/n)"

#If language file exists, source it to override English language UI strings
if [[ -s "$LANGUAGE_FILE" && -r "$LANGUAGE_FILE" ]]; then
  source $LANGUAGE_FILE
fi

#=============================================================================

#Time-lapse params:
TLNUM=10
TLONCE=${XYC_N}
TLOFF=${XYC_Y}
TLDELAY=12
NOUI=0

#Other settings
unset EXITACTION

welcome ()
{
  clear
  echo ""
  echo " *  Xiaomi Yi Configurator  * "
  echo " *  10/1/2015   ${VERS}  * "
  echo ""
}

showMainMenu ()
{
  local REPLY=0
  while [ "$EXITACTION" == "" ]
  do
    echo "    ====== ${XYC_MAIN_MENU} ====="
    echo " [1] $XYC_VIEW_EDIT_SETTINGS"
    echo " [2] $XYC_CREATE_TIME_LAPSE"
    echo " [3] $XYC_CREATE_HDR"
    echo " [4] $XYC_RESET_SETTINGS"
    echo " [5] $XYC_SHOW_CARD_SPACE"
    echo " [6] $XYC_RESTART_CAMERA"
    echo " [7] $XYC_EXIT"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    clear
    case $REPLY in
      0) cat $AASH;;
      1) showSettingsMenu; writeAutoexec $AASH "settings";;
      2) showTimeLapseMenu; writeAutoexec $AASH "timelapse";;
      3) showHDRMenu; writeAutoexec $AASH "hdr";;
      4) removeAutoexec; resetCameraSettings;;
      5) showSpaceUsage;;
      6) EXITACTION="reboot";;
      7) EXITACTION="nothing";;
      *) echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac

  done
}


showSettingsMenu ()
{
  local REPLY=0
  while [[ $REPLY -gt -1 && $REPLY -lt 13 ]]
  do
    echo "    == ${XYC_CAMERA_SETTINGS_MENU} =="
    if [ $EXP -eq 0 ]; then 
      echo " [1] ${XYC_EXPOSURE}     : ${XYC_AUTO}" 
    else 
      expView $EXP
      echo " [1] ${XYC_EXPOSURE}     : $EXPVIEW"
    fi
    if [ $ISO -eq 0 ]; then 
      echo " [2] ${XYC_ISO}          : ${XYC_AUTO}"
    else 
      echo " [2] ${XYC_ISO}          : $ISO"
    fi
    if [ $AWB == ${XYC_Y} ]; then 
      echo " [3] ${XYC_AWB}          : ${XYC_ON}" 
    else 
      echo " [3] ${XYC_AWB}          : ${XYC_OFF}"
    fi
    if [ $RNR == ${XYC_Y} ]; then 
      echo " [4] ${XYC_REDUCE_NR}    : ${XYC_YES}"
    else 
      echo " [4] ${XYC_REDUCE_NR}    : ${XYC_NO}" 
    fi
    if [ $SHADOW == ${XYC_Y} ]; then 
      echo " [5] ${XYC_SHADOW}   : ${XYC_YES}"
    else 
      echo " [5] ${XYC_SHADOW}   : ${XYC_NO}" 
    fi
    if [[ ! -z $SHR ]]; then 
      echo " [6] ${XYC_SHARPNESS}    : $SHR $FIR $COR"
    else 
      echo " [6] ${XYC_SHARPNESS}    : ${XYC_DEFAULT}" 
    fi
    if [ $YIMAX == ${XYC_Y} ]; then 
      echo " [7] ${XYC_YIMAX_MOVIE}  : ${XYC_YES}" 
    else 
      echo " [7] ${XYC_YIMAX_MOVIE}  : ${XYC_NO}"
    fi
    if [ $RAW == ${XYC_Y} ]; then 
      echo " [8] ${XYC_CREATE_RAW}   : ${XYC_YES}" 
    else 
      echo " [8] ${XYC_CREATE_RAW}   : ${XYC_NO}"
    fi
    if [ $RES -eq 0 ]; then 
      echo " [9] ${XYC_VIDEO_QUALITY}: ${XYC_DEFAULT}" 
    else
      echo " [9] ${XYC_VIDEO_QUALITY}: $RESVIEW"
    fi
    if [ $BIG_FILE == ${XYC_Y} ]; then 
      echo " [10] ${XYC_BIG_FILE}   : ${XYC_YES}" 
    else
      echo " [10] ${XYC_BIG_FILE}   : ${XYC_NO}"
    fi
    if [ $INC_USER == ${XYC_Y} ]; then 
      echo " [11] ${XYC_USER_IMPORT} : ${XYC_YES}" 
    else 
      echo " [11] ${XYC_USER_IMPORT} : ${XYC_NO}"
    fi
    echo " [12] ${XYC_SAVE_AND_BACK}"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getExposureInput; clear;;
      2) getISOInput; clear;;
      3) getAWBInput; clear;;
      4) getNRInput; clear;;
      5) getShadowInput; clear;;
      6) getSharpnessInput; clear;;
      7) getYiMaxInput; clear;;
      8) getRawInput; clear;;
      9) getVideoInput; clear;;
      10) getBigFileInput; clear;;
      11) getIncludeUserSettings; clear;;
      12) clear; return 0;;
      *) clear; echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac
  done
}

showTimeLapseMenu ()
{
  local REPLY=0
  resetDelaySuggestion
  while [[ $REPLY -gt -1 && $REPLY -lt 6 ]]
  do
    echo "    ===== ${XYC_TIME_LAPSE_MENU} ====="
    echo " [1] ${XYC_ENTER_NUM_SHOTS_MENU} : $TLNUM"
    echo " [2] ${XYC_DELAY_BETWEEN_SHUTTER_MENU}    : $TLDELAY"
    echo " [3] ${XYC_POWEROFF_WHEN_COMPLETE_MENU}   : $TLOFF"
    echo " [4] ${XYC_RUN_ONCE_ONLY_MENU}          : $TLONCE"
    echo " [5] $XYC_SAVE_AND_BACK"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getTLNumShots; clear;;
      2) getTLDelay; clear;;
      3) getTLOff; clear;;
      4) getTLOnce; clear;;
      5) clear; return 0;;
      *) clear; echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac
  done

  clear
}

showHDRMenu ()
{
  local REPLY=0
  while [[ $REPLY -gt -1 && $REPLY -lt 6 ]]
  do
    if [[ ! -z $AUTAN ]]; then
      if [ $ISO -eq 0 ]; then 
        echo " * ${XYC_ISO}     : ${XYC_AUTO}"
      else 
        echo " * ${XYC_ISO}     : $ISO"
      fi
      if [ $AUTAN -eq 2 ]; then
        echo " * ${XYC_HDR}1    : 7.9 sec   "
        echo " * ${XYC_HDR}2    : 5.4 sec   "
        echo " * ${XYC_HDR}3    : 3.5 sec   "
        echo " * ${XYC_HDR}4    : 1.8 sec   "
        echo " * ${XYC_HDR}5    : 1.0 sec   "
        echo " * ${XYC_HDR}6    : 1/15 sec  "
        echo ""
      elif [ $AUTAN -eq 1 ]; then
        echo " * ${XYC_HDR}1    : 1/15 sec  "
        echo " * ${XYC_HDR}2    : 1/50 sec  "
        echo " * ${XYC_HDR}3    : 1/245 sec "
        echo " * ${XYC_HDR}4    : 1/520 sec "
        echo " * ${XYC_HDR}5    : 1/1630 sec"
        echo " * ${XYC_HDR}6    : 1/8147 sec"
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
    echo " [1] ${XYC_HDR_AUTO_NIGHT}"
    echo " [2] ${XYC_HDR_AUTO_DAY}"
    echo " [3] ${XYC_HDR_ADVANCED}"
    echo " [4] ${XYC_HDR_RESET}"
    echo " [5] $XYC_SAVE_AND_BACK"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) AUTAN=2; HDR1=1; HDR2=300; HDR3=900; getISOInput; clear;;
      2) AUTAN=1; HDR1=900; HDR2=1550; HDR3=2047; getISOInput; clear;;
      3) AUTAN=0; getHDRInput; getISOInput; clear;;
      4) unset AUTAN; clear; return 0;;
      5) clear; return 0;;
      *) clear; echo "$XYC_INVALID_CHOICE"; REPLY=0;;
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

getCleanUpInput ()
{
 read -p "${XYC_DELETE_VIDEO_PREVIEW_PROMPT} [${XYC_ENTER}=n]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    removeAllPreviews
  fi
 read -p "${XYC_DELETE_RAW_PROMPT} [${XYC_ENTER}=n]: " REPLY
  if [ "$REPLY" == ${XYC_Y} ]; then
    removeAllRAWs
  fi
}

removeAllPreviews ()
{
  echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*.THM"
  rm -f ${FUSED}/DCIM/100MEDIA/*.THM
  echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*thm.mp4"
  rm -f ${FUSED}/DCIM/100MEDIA/*thm.mp4
}

removeAllRAWs ()
{
  echo "${XYC_REMOVING} ${FUSED}/DCIM/100MEDIA/*.RAW"
  rm -f ${FUSED}/DCIM/100MEDIA/*.RAW
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
      -n) RNR=$2; shift;;
      -r) RAW=$2; shift;;
      -y) YIMAX=$2; shift;;
      -s) SHADOW=$2; shift;;
      -b) BIG_FILE=$2; shift;;
      -u) INC_USER=$2; shift;;
      -q) NOUI=1;;
       *) echo "${XYC_UNKNOWN_OPTION}: $key"; shift;;
    esac
    shift # past argument or value
  done
}

parseExistingAutoexec ()
{
  #Parse existing values from autoexec.ash
  ISO=`grep "t ia2 -ae exp" $AASH 2>/dev/null | cut -d " " -f 5`
  EXP=`grep "t ia2 -ae exp" $AASH 2>/dev/null | cut -d " " -f 6`

  grep -q "t ia2 -awb off" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then AWB=${XYC_N}; fi

  grep -q "t ia2 -adj tidx -1 -1 -1" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RNR=${XYC_Y}; fi

  grep -q "t app test debug_dump 14" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RAW=${XYC_Y}; fi

  grep -q "#UserSettings: y" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then INC_USER=${XYC_Y}; fi

  grep -q "#TimeLapseParams:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    TLNUM=`grep "#TimeLapseParams:" $AASH | cut -d " " -f 2`
    TLONCE=`grep "#TimeLapseParams:" $AASH | cut -d " " -f 3`
    TLOFF=`grep "#TimeLapseParams:" $AASH | cut -d " " -f 4`
    TLDELAY=`grep "#TimeLapseParams:" $AASH | cut -d " " -f 5`
  fi

  grep -q "#HDRParams:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    AUTAN=`grep "#HDRParams:" $AASH | cut -d " " -f 2`
    HDR1=`grep "#HDRParams:" $AASH | cut -d " " -f 3`
    HDR2=`grep "#HDRParams:" $AASH | cut -d " " -f 4`
    HDR3=`grep "#HDRParams:" $AASH | cut -d " " -f 5`
  fi

  grep -q "#Sharpness:" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then
    SHR=`grep "#Sharpness:" $AASH | cut -d " " -f 2`
    FIR=`grep "#Sharpness:" $AASH | cut -d " " -f 3`
    COR=`grep "#Sharpness:" $AASH | cut -d " " -f 4`
  fi

  grep -q "#YiMAX-movie script" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then YIMAX=${XYC_Y}; fi

  grep -q "t ia2 -adj autoknee" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then SHADOW=${XYC_Y}; fi

  grep -q "writeb 0xC06CC426 0x11" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x0F" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x34" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=1; FPS=3; fi
  grep -q "writeb 0xC06CC426 0x17" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x16" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=2; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x0D" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x0C" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=3; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x06" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x03" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=4; FPS=2; fi
  grep -q "writeb 0xC06CC426 0x02" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=5; FPS=1; fi
  grep -q "writeb 0xC06CC426 0x00" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then RES=6; FPS=1; fi

  grep -q "0x41A0" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT=1; fi
  grep -q "0x41C8" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT=2; fi
  grep -q "0x41F0" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT=3; fi
  grep -q "0x420C" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIT=4; fi

  grep -q "writew 0xC03A8520 0x2004" $AASH 2>/dev/null
  if [ $? -eq 0 ]; then BIG_FILE=${XYC_Y}; fi
}

resetCameraSettings ()
{
  unset RES FPS BIT
  unset AWB RNR SHR FIR COR YIMAX SHADOW BIG_FILE
  unset ISO EXP RAW
  unset INC_USER
  setMissingValues
  promptToRestart
}

setMissingValues ()
{
  #Set reasonable defaults for any missing values
  if [ -z "$ISO" ]; then ISO=0; fi
  if [ -z "$EXP" ]; then EXP=0; fi
  if [[ "$AWB" != ${XYC_Y} && "$AWB" != ${XYC_N} ]]; then AWB=${XYC_Y}; fi
  if [[ "$RNR" != ${XYC_Y} && "$RNR" != ${XYC_N} ]]; then RNR=${XYC_N}; fi
  if [[ "$RAW" != ${XYC_Y} && "$RAW" != ${XYC_N} ]]; then RAW=${XYC_N}; fi
  if [[ "$BIG_FILE" != ${XYC_Y} && "$BIG_FILE" != ${XYC_N} ]]; then BIG_FILE=${XYC_N}; fi
  if [[ "${INC_USER}" != ${XYC_Y} && "${INC_USER}" != ${XYC_N} ]]; then INC_USER=${XYC_N}; fi
  if [[ "$YIMAX" != ${XYC_Y} && "$YIMAX" != ${XYC_N} ]]; then YIMAX=${XYC_N}; fi
  if [[ "$SHADOW" != ${XYC_Y} && "$SHADOW" != ${XYC_N} ]]; then SHADOW=${XYC_N}; fi
  if [ -z "$RES" ]; then RES=0; FPS=1; BIT=2; else setRESView; fi
}

resetDelaySuggestion ()
{
  #Delay should be sum of file write time (WT) and exposure time (ET)
  #if delay is too short, then the camera doesn't write the RAW file...
  #make delay longer as necessary, depending on shutter speed and SD card
  #performance
  local WT=12
  local ET=0
  if [ -n $EXP ]; then
    if [ $EXP -eq 0 ]; then ET=1;
    elif [ $EXP -lt 30 ]; then ET=8;
    elif [ $EXP -lt 50 ]; then ET=7;
    elif [ $EXP -lt 90 ]; then ET=6;
    elif [ $EXP -lt 150 ]; then ET=5;
    elif [ $EXP -lt 200 ]; then ET=4;
    elif [ $EXP -lt 300 ]; then ET=3;
    elif [ $EXP -lt 400 ]; then ET=2;
    elif [ $EXP -lt 1000 ]; then ET=1;
    else ET=0;
    fi
  fi

  return `expr $WT + $ET`
}

getExposureInput ()
{
  clear
  echo " ******** ${XYC_EXPOSURE_MENU} ********* "
  echo " * (0)=Auto (12)=1/10  (24)=1/624  * "
  echo " * (1)=7.9  (13)=1/15  (25)=1/752  * "
  echo " * (2)=7.7  (14)=1/30  (26)=1/1002 * "
  echo " * (3)=6.1  (15)=1/50  (27)=1/1244 * "
  echo " * (4)=5    (16)=1/60  (28)=1/1630 * "
  echo " * (5)=4.6  (17)=1/80  (29)=1/2138 * "
  echo " * (6)=2.7  (18)=1/125 (30)=1/2448 * "
  echo " * (7)=1    (19)=1/140 (31)=1/2803 * "
  echo " * (8)=1    (20)=1/250 (32)=1/3675 * "
  echo " * (9)=1/3  (21)=1/320 (33)=1/6316 * "
  echo " * (10)=1/5 (22)=1/420 (34)=1/8147 * "
  echo " * (11)=1/5 (23)=1/500      ${XYC_SEC}    * "
  echo " *********************************** "
  local REPLY=$EXP
  read -p "${XYC_SELECT_OPTION}: 0-34: " REPLY
  case $REPLY in
    0) EXP=0;;
    1) EXP=1;;
    2) EXP=8;;
    3) EXP=50;;
    4) EXP=84;;
    5) EXP=100;;
    6) EXP=200;;
    7) EXP=400;;
    8) EXP=500;;
    9) EXP=590;;
    10) EXP=600;;
    11) EXP=700;;
    12) EXP=800;;
    13) EXP=900;;
    14) EXP=1000;;
    15) EXP=1100;;
    16) EXP=1145;;
    17) EXP=1200;;
    18) EXP=1275;;
    19) EXP=1300;;
    20) EXP=1405;;
    21) EXP=1450;;
    22) EXP=1500;;
    23) EXP=1531;;
    24) EXP=1600;;
    25) EXP=1607;;
    26) EXP=1660;;
    27) EXP=1700;;
    28) EXP=1750;;
    29) EXP=1800;;
    30) EXP=1825;;
    31) EXP=1850;;
    32) EXP=1900;;
    33) EXP=2000;;
    34) EXP=2047;;
  esac
}

expView ()
{
  case $1 in 
    0) EXPVIEW="Auto";;
    1) EXPVIEW="7.9 sec";;
    8) EXPVIEW="7.7 sec";;
    50) EXPVIEW="6.1 sec";;
    84) EXPVIEW="5 sec";;
    100) EXPVIEW="4.6 sec";;
    200) EXPVIEW="2.7 sec";;
    400) EXPVIEW="1 sec";;
    500) EXPVIEW="1 sec";;
    590) EXPVIEW="1/3 sec";;
    600) EXPVIEW="1/5 sec";;
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
    1500) EXPVIEW="1/420 sec";;
    1531) EXPVIEW="1/500 sec";;
    1600) EXPVIEW="1/624 sec";;
    1607) EXPVIEW="1/752 sec";;
    1660) EXPVIEW="1/1002 sec";;
    1700) EXPVIEW="1/1244 sec";;
    1750) EXPVIEW="1/1630 sec";;
    1800) EXPVIEW="1/2138 sec";;
    1825) EXPVIEW="1/2448 sec";;
    1850) EXPVIEW="1/2803 sec";;
    1900) EXPVIEW="1/3675 sec";;
    2000) EXPVIEW="1/6316 sec";;
    2047) EXPVIEW="1/8147 sec";;
  esac
}

getISOInput ()
{
  clear
  if [[ -z $AUTAN ]]; then
    expView $EXP
    echo " * ${XYC_EXPOSURE}: $EXPVIEW "
  elif [ $AUTAN -eq 2 ]; then
    echo " * ${XYC_HDR}1    : 7.9 sec   "
    echo " * ${XYC_HDR}2    : 5.4 sec   "
    echo " * ${XYC_HDR}3    : 3.5 sec   "
    echo " * ${XYC_HDR}4    : 1.8 sec   "
    echo " * ${XYC_HDR}5    : 1.0 sec   "
    echo " * ${XYC_HDR}6    : 1/15 sec  "
  elif [ $AUTAN -eq 1 ]; then
    echo " * ${XYC_HDR}1    : 1/15 sec  "
    echo " * ${XYC_HDR}2    : 1/50 sec  "
    echo " * ${XYC_HDR}3    : 1/245 sec "
    echo " * ${XYC_HDR}4    : 1/520 sec "
    echo " * ${XYC_HDR}5    : 1/1630 sec"
    echo " * ${XYC_HDR}6    : 1/8147 sec"
  elif [ $AUTAN -eq 0 ]; then
    expView $HDR1
    echo " * ${XYC_HDR}1    : $EXPVIEW  "
    expView $HDR2
    echo " * ${XYC_HDR}2    : $EXPVIEW  "
    expView $HDR3
    echo " * ${XYC_HDR}3    : $EXPVIEW  "
  fi
  echo ""
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
    0) ISO=0;;
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
  local REPLY=$AWB
  read -p "${XYC_ENTER_AWB_PROMPT} [${XYC_ENTER}=$AWB]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then AWB=$REPLY; fi
}

getNRInput ()
{
  clear 
  local REPLY=$RNR
  read -p "${XYC_REDUCE_NR_PROMPT} [${XYC_ENTER}=$RNR]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then RNR=$REPLY; fi
}

getShadowInput ()
{
  clear 
  local REPLY=$SHADOW
  read -p "${XYC_SHADOW_PROMPT} [${XYC_ENTER}=$SHADOW]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then SHADOW=$REPLY; fi
}

getRawInput ()
{
  clear 
  local REPLY=$RAW
  read -p "${XYC_CREATE_RAW_PROMPT} [${XYC_ENTER}=$RAW]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then RAW=$REPLY; fi
}

getSharpnessInput ()
{
  clear
  echo " ********** ${XYC_SHARPNESS_MODE} ********* "
  echo " * (0) ${XYC_DEFAULT}                     * "
  echo " * (1) ${XYC_SHR_MODE_VIDEO}                       * "
  echo " * (2) ${XYC_SHR_MODE_FAST}                  * "
  echo " * (3) ${XYC_SHR_MODE_LOWISO}                * "
  echo " * (4) ${XYC_SHR_MODE_HIGHISO}               * "
  echo " *********************************** "
  local REPLY=$SHR
  read -p "${XYC_SELECT_OPTION}: " REPLY
  case $REPLY in 
    0) unset SHR return;;
    1) SHR=0;; 
    2) SHR=1;; 
    3) SHR=2;; 
    4) SHR=3;;
  esac
  if [[ ! -z $SHR ]]; then 
    getSharpFirInput
  fi
}

getSharpFirInput ()
{
  clear  
  local REPLY=$FIR
  read -p "${XYC_SHARPNESS_FIR_PROMPT} [${XYC_ENTER}=$FIR]: " REPLY
  if [ -n "$REPLY" ]; then 
    FIR=$REPLY; 
  elif [ -z "$FIR" ]; then
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
  elif [ -z "$COR" ]; then
    COR=104; 
  fi
}

getYiMaxInput ()
{
  clear 
  local REPLY=$YIMAX
  read -p "${XYC_YIMAX_PROMPT} [${XYC_ENTER}=$YIMAX]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then YIMAX=$REPLY; fi
}

getVideoInput ()
{
  clear
  echo " ********* ${XYC_VIDEO_RESOLUTION} ******** "
  echo " * (0) ${XYC_DEFAULT}   (4) 1920x1080     * "
  echo " * (1) 1280x720  (5) 2304x1296     * "
  echo " * (2) 1280x960  (6) 2560x1440     * "
  echo " * (3) 1600x1200                   * "  
  echo " *********************************** "
  local REPLY=$RES
  read -p "${XYC_SELECT_OPTION}: " REPLY
  case $REPLY in 
    0) RES=0; return;;
    1) RES=1;;
    2) RES=2;;
    3) RES=3;;
    4) RES=4;;
    5) RES=5;;
    6) RES=6;;
  esac
  if [[ $RES -eq 5 || $RES -eq 6 ]]; then
    FPS=1; getVideoBitrateInput
  else
    getVideoFrequencyInput
  fi
}

getVideoFrequencyInput ()
{
  clear
  echo " ********* ${XYC_VIDEO_FREQUENCY} ********* "
  echo " * (1) 30 FPS                      * "
  echo " * (2) 60 FPS                      * "
  if [ $RES -eq 1 ]; then 
    echo " * (3) 120 FPS                     * "
  fi
  echo " *********************************** "
  local REPLY
  read -p "${XYC_SELECT_OPTION}: " REPLY
  if [ -ne $REPLY ]; then
    REPLY=$FPS
  fi
  case $REPLY in 
    1) FPS=1;;
    2) FPS=2;;
    3)  if [ $RES -eq 1 ]; then 
          FPS=3 
        else 
          FPS=1 
        fi;;
  esac
  getVideoBitrateInput
}

getVideoBitrateInput ()
{
  clear
  echo " ********** ${XYC_VIDEO_BITRATE} ********** "
  echo " * (1) 20 Mb/s                     * "
  echo " * (2) 25 Mb/s                     * "
  echo " * (3) 30 Mb/s                     * "
  echo " * (4) 35 Mb/s                     * "
  echo " *********************************** "
  local REPLY
  read -p "${XYC_SELECT_OPTION}: " REPLY
  if [ -n "$REPLY" ]; then 
    BIT=$REPLY; 
  fi
  setRESView
}

setRESView ()
{
  if [ $RES -eq 1 ]; then 
    RESVIEW="720p" 
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 2 ]; then 
      RESVIEW="$RESVIEW@60"
    elif [ $FPS -eq 3 ]; then 
      RESVIEW="$RESVIEW@120"
    fi
  elif [ $RES -eq 2 ]; then 
    RESVIEW="960p" 
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 2 ]; then 
      RESVIEW="$RESVIEW@60"
    fi
  elif [ $RES -eq 3 ]; then 
    RESVIEW="HD" 
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 2 ]; then 
      RESVIEW="$RESVIEW@60"
    fi 
  elif [ $RES -eq 4 ]; then 
    RESVIEW="1080p" 
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    elif [ $FPS -eq 2 ]; then 
      RESVIEW="$RESVIEW@60"
    fi
  elif [ $RES -eq 5 ]; then 
    RESVIEW="1296p"
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    fi
  elif [ $RES -eq 6 ]; then 
    RESVIEW="1440p"
    if [ $FPS -eq 1 ]; then 
      RESVIEW="$RESVIEW@30"
    fi
  fi

  if [ $RES -ne 0 ]; then
    case $BIT in 
      1) RESVIEW="$RESVIEW 20Mb";;
      2) RESVIEW="$RESVIEW 25Mb";;
      3) RESVIEW="$RESVIEW 30Mb";;
      4) RESVIEW="$RESVIEW 35Mb";;
    esac
  fi
}

getBigFileInput ()
{
  clear 
  local REPLY=$BIG_FILE
  read -p "${XYC_BIG_FILE_PROMPT} [${XYC_ENTER}=$BIG_FILE]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then BIG_FILE=$REPLY; fi
}

getIncludeUserSettings ()
{
  clear  
  local REPLY=$INC_USER
  read -p "${XYC_INCLUDE_USER_SETTINGS_PROMPT} [${XYC_ENTER}=$REPLY]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then INC_USER=$REPLY; fi
}


getTLNumShots()
{
  clear  
  local REPLY=$TLNUM
  read -p "${XYC_ENTER_NUM_SHOTS_PROMPT} [${XYC_ENTER}=$TLNUM]: " REPLY
  if [ -n "$REPLY" ]; then TLNUM=$REPLY; fi
}

getTLOnce()
{
  clear  
  local REPLY=$TLONCE
  read -p "${XYC_RUN_ONCE_ONLY_PROMPT} [${XYC_ENTER}=$TLONCE]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then TLONCE=$REPLY; fi
}

getTLOff()
{
  clear  
  local REPLY=$TLOFF
  read -p "${XYC_POWEROFF_WHEN_COMPLETE_PROMPT} [${XYC_ENTER}=$TLOFF]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then TLOFF=$REPLY; fi
}

getTLDelay()
{
  clear  
  #resetDelaySuggestion
  #TLDELAY=$?
  local REPLY=$TLOFF
  read -p "${XYC_DELAY_BETWEEN_SHUTTER_PROMPT} [${XYC_ENTER}=$TLDELAY]: " REPLY
  if [ -n "$REPLY" ]; then TLDELAY=$REPLY; fi
}

getHDRInput ()
{
  clear
  local REPLY=0
  while [ $REPLY -eq 0 ]
  do
    echo " *** ${XYC_FIRST} ${XYC_HDR_EXPOSURE} **** "
    echo " * (1)=1/50   (3)=1/80   (5)=1/140 * "    
    echo " * (2)=1/60   (4)=1/125  (6)=1/250 * "
    echo " *********************************** "
    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) HDR1=1100; HEHE1=1; clear;;
      2) HDR1=1145; HEHE1=2; clear;;
      3) HDR1=1200; HEHE1=3; clear;;
      4) HDR1=1275; HEHE1=4; clear;;
      5) HDR1=1300; HEHE1=5; clear;;
      6) HDR1=1405; HEHE1=6; clear;;
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
    echo " *** ${XYC_SECOND} ${XYC_HDR_EXPOSURE} *** "
    echo " * (1)=1/420  (3)=1/624 (5)=1/1002 * "    
    echo " * (2)=1/500  (4)=1/752 (6)=1/1244 * "
    echo " *********************************** "
    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) HDR2=1500; HEHE2=1; clear;;
      2) HDR2=1531; HEHE2=2; clear;;
      3) HDR2=1600; HEHE2=3; clear;;
      4) HDR2=1607; HEHE2=4; clear;;
      5) HDR2=1660; HEHE2=5; clear;;
      6) HDR2=1700; HEHE2=6; clear;;
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
    echo " **** ${XYC_THIRD} ${XYC_HDR_EXPOSURE} **** "
    echo " * (1)=1/2138 (3)=1/2803 (5)=1/6316 * "    
    echo " * (2)=1/2448 (4)=1/3675 (6)=1/8147 * "
    echo " ************************************ "
    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) HDR3=1800; HEHE3=1; clear;;
      2) HDR3=1825; HEHE3=2; clear;;
      3) HDR3=1850; HEHE3=3; clear;;
      4) HDR3=1900; HEHE3=4; clear;;
      5) HDR3=2000; HEHE3=5; clear;;
      6) HDR3=2047; HEHE3=6; clear;;
      *) clear; echo "${XYC_INVALID_CHOICE}"; REPLY=0;;
    esac
  done
}

removeAutoexec ()
{
  #Note: This works in "t": rm 'd:\autoexec.ash'
  echo "${XYC_DELETING} $AASH" 
  rm -f $AASH
  if [[ "$PRAWNCONF" && -r "$PRAWNCONF" ]]; then
    echo "${XYC_DELETING} $PRAWNCONF" 
    rm -f $PRAWNCONF
  fi
  if [[ "$CORCONF" && -r "$CORCONF" ]]; then
    echo "${XYC_DELETING} $CORCONF" 
    rm -f $CORCONF
  fi
}

writeAutoexec ()
{
  OUTFILE=${1:-$AASH}
  SCRIPT_TYPE=${2:-"settings"}
  echo "${XYC_WRITING} $OUTFILE"

  #Write any necessary script commands to autoexec.ash
  echo "#Script created `date`" > $OUTFILE
  echo "#VideoResolution: $RES $FPS $BIT" >> $OUTFILE
  echo "#CameraParams: $AWB $RNR $YIMAX $SHADOW $BIG_FILE" >> $OUTFILE
  echo "#PhotoParams: $ISO $EXP $RAW" >> $OUTFILE
  echo "#Sharpness: $SHR $FIR $COR " >> $OUTFILE  
  echo "#UserSettings: $INC_USER" >> $OUTFILE
  echo "#TimeLapseParams: $TLNUM $TLONCE $TLOFF $TLDELAY" >> $OUTFILE
  echo "#HDRParams: $AUTAN $HDR1 $HDR2 $HDR3" >> $OUTFILE
  echo "" >> $OUTFILE

  #Add user settings first, so that changes made by this script overwrite
  #any conflicting settings that might be specified in user file
  if [ "$INC_USER" == ${XYC_Y} ]; then
    if [[ "$USER_SETTINGS_FILE" && -r "$USER_SETTINGS_FILE" ]]; then
    echo "#User settings imported from ${USER_SETTINGS_FILE}:" >> $OUTFILE
      cat $USER_SETTINGS_FILE >> $OUTFILE
      echo "#End user settings" >> $OUTFILE
      echo "" >> $OUTFILE
    else
      echo "${XYC_CANNOT_READ} $USER_SETTINGS_FILE"
      echo "#${XYC_CANNOT_READ} $USER_SETTINGS_FILE" >> $OUTFILE
    fi
  fi

  if [ "$YIMAX" == ${XYC_Y} ]; then
    echo "#YiMAX-movie script by nutsey" >> $OUTFILE
    echo "#This script is for video mode!" >> $OUTFILE
    echo "t ia2 -adj ev 10 0 60 0 0 140 0" >> $OUTFILE
    echo "#this makes blacks not crushed" >> $OUTFILE
    echo "t ia2 -adj l_expo 163" >> $OUTFILE
    echo "#enable 14 scene mode" >> $OUTFILE
    echo "t cal -sc 14" >> $OUTFILE
    echo "#Set JPEG quality to 100%" >> $OUTFILE
    echo "writeb 0xC0BC205B 0x64" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$SHADOW" == ${XYC_Y} ]; then
    echo "#shadow/highlight clipping adjustments" >> $OUTFILE
    echo "t ia2 -adj autoknee 255" >> $OUTFILE
    echo "#set gamma level" >> $OUTFILE
    echo "t ia2 -adj gamma 220" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [[ $ISO -ne 0 || $EXP -ne 0 ]]; then
    echo "#Set ISO and exposure" >> $OUTFILE
    echo "t ia2 -ae exp $ISO $EXP" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$AWB" == ${XYC_N} ]; then
    echo "#Set auto-whitebalance" >> $OUTFILE
    echo "t ia2 -awb off" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$RNR" == ${XYC_Y} ]; then
    echo "#Reduce noise reduction as much as possible" >> $OUTFILE
    echo "t ia2 -adj tidx -1 -1 -1" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [[ ! -z $SHR ]]; then
    echo "#Sharpness" >> $OUTFILE
    echo "t is2 -shp mode $SHR" >> $OUTFILE
    echo "t is2 -shp fir $FIR 0 0 0 0 0 0" >> $OUTFILE
    echo "t is2 -shp max_change 5 5" >> $OUTFILE
    echo "t is2 -shp cor d:\coring.config" >> $OUTFILE
    echo "" >> $OUTFILE

    echo "Writing $CORCONF"
    echo "$COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR $COR" > $CORCONF
  fi

  if [ $RES -eq 1 ]; then
    echo "#set video resolution to 1280x720" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #1280x720 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x11" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C2152 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C2152 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C2152 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C2152 0x420C" >> $OUTFILE
      fi
    elif [ $FPS -eq 2 ]; then #1280x720 60fps
      echo "#set video frequency to 60fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x0F" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C2122 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C2122 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C2122 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C2122 0x420C" >> $OUTFILE
      fi
    elif [ $FPS -eq 3 ]; then #1280x720 120fps
      echo "#set video frequency to 120fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x34" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C2812 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C2812 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C2812 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C2812 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 2 ]; then
    echo "#set video resolution to 1280x960" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #1280x960 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x17" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C22A2 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C22A2 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C22A2 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C22A2 0x420C" >> $OUTFILE
      fi
    elif [ $FPS -eq 2 ]; then #1280x960 60fps
      echo "#set video frequency to 60fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x16" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C2272 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C2272 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C2272 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C2272 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 3 ]; then
    echo "#set video resolution to 1600x1200" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #1600x1200 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x0D" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C20C2 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C20C2 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C20C2 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C20C2 0x420C" >> $OUTFILE
      fi
    elif [ $FPS -eq 2 ]; then #1600x1200 60fps
      echo "#set video frequency to 60fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x0C" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C2092 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C2092 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C2092 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C2092 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 4 ]; then
    echo "#set video resolution to 1920x1080" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #1920x1080 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x06" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C1F72 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C1F72 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C1F72 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C1F72 0x420C" >> $OUTFILE
      fi
    elif [ $FPS -eq 2 ]; then #1920x1080 60fps
      echo "#set video frequency to 60fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x03" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EE2 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EE2 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EE2 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EE2 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 5 ]; then
    echo "#set video resolution to 2304x1296" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #2304x1296 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x02" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EB2 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EB2 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EB2 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C1EB2 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  elif [ $RES -eq 6 ]; then
    echo "#set video resolution to 2560x1440" >> $OUTFILE
    if [ $FPS -eq 1 ]; then #2560x1440 30fps
      echo "#set video frequency to 30fps" >> $OUTFILE
      echo "writeb 0xC06CC426 0x00" >> $OUTFILE
      if [ $BIT -eq 1 ]; then
        echo "#set bitrate to 20Mb/s" >> $OUTFILE
        echo "writew 0xC05C1E52 0x41A0" >> $OUTFILE
      fi
      if [ $BIT -eq 2 ]; then
        echo "#set bitrate to 25Mb/s" >> $OUTFILE
        echo "writew 0xC05C1E52 0x41C8" >> $OUTFILE
      fi
      if [ $BIT -eq 3 ]; then
        echo "#set bitrate to 30Mb/s" >> $OUTFILE
        echo "writew 0xC05C1E52 0x41F0" >> $OUTFILE
      fi
      if [ $BIT -eq 4 ]; then
        echo "#set bitrate to 35Mb/s" >> $OUTFILE
        echo "writew 0xC05C1E52 0x420C" >> $OUTFILE
      fi
    fi
    echo "" >> $OUTFILE
  fi

  if [ "$RAW" == ${XYC_Y} ]; then
    echo "#Create RAW files" >> $OUTFILE
    echo "t app test debug_dump 14" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$BIG_FILE" == ${XYC_Y} ]; then
    echo "#Set file weight limit to 4GB" >> $OUTFILE
    echo "writew 0xC03A8520 0x2004" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ "$YIMAX" == ${XYC_Y} ]; then
    echo "sleep 9" >> $OUTFILE
    echo "#load GoPrawn config" >> $OUTFILE
    echo "t cal -ituner load d:\goprawn.config" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "#fix ae/awb/adj locks" >> $OUTFILE
    echo "t ia2 -3a 1 1 0 1" >> $OUTFILE
    echo "" >> $OUTFILE

    echo "Writing $PRAWNCONF"
    #Write any necessary script commands to goprawn.config
    echo "#Script created `date`" > $PRAWNCONF
    echo "#GoPrawn config by nutsey" >> $PRAWNCONF
    echo "system.user_mode Normal" >> $PRAWNCONF
    echo "system.tuning_mode IMG_MODE_VIDEO" >> $PRAWNCONF
    echo "system.tuning_mode_ext SINGLE_SHOT" >> $PRAWNCONF
    echo "system.jpg_quality 100" >> $PRAWNCONF
    echo "#aaa_function.ae_op 1" >> $PRAWNCONF
    echo "#aaa_function.awb_op 1" >> $PRAWNCONF
    echo "#aaa_function.adj_op 1" >> $PRAWNCONF
    echo "static_bad_pixel_correction.enable 3" >> $PRAWNCONF
    echo "auto_bad_pixel_correction.enable 4" >> $PRAWNCONF
    echo "cfa_leakage_filter.enable 1" >> $PRAWNCONF
    echo "cfa_noise_filter.enable 0" >> $PRAWNCONF
    echo "#anti_aliasing.enable 1" >> $PRAWNCONF
    echo "chroma_median_filter.enable 1" >> $PRAWNCONF
    echo "chroma_median_filter.cb_strength 160" >> $PRAWNCONF
    echo "chroma_median_filter.cr_strength 128" >> $PRAWNCONF
    echo "demosaic.activity_thresh 3" >> $PRAWNCONF
    echo "demosaic.grad_noise_thresh 32" >> $PRAWNCONF
    if [[ -z $SHR ]]; then
        echo "sharpening_fir.fir_strength 64" >> $PRAWNCONF
        echo "sharpening_coring.coring_table 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14" >> $PRAWNCONF
        echo "directional_sharpening.enable 0" >> $PRAWNCONF
    fi
    echo "spatial_filter.mode 0" >> $PRAWNCONF
    echo "video_mctf.enable 1" >> $PRAWNCONF
    echo "chromatic_aberration_correction.enable 1" >> $PRAWNCONF
    echo "chroma_filt.enable 0" >> $PRAWNCONF
  fi
  
  #If requested, write time-lapse script
  if [ "$SCRIPT_TYPE" == "timelapse" ]; then
    echo "#Timelapse Script:" >> $OUTFILE
    #Pause to allow camera to boot up before starting
    echo "sleep 10" >> $OUTFILE

    CTR=0
    while [ $CTR -lt $TLNUM ];  do
      echo "t app key shutter" >> $OUTFILE
      echo "sleep $TLDELAY" >> $OUTFILE
      CTR=`expr $CTR + 1`
    done
    echo "" >> $OUTFILE

    if [ "$TLONCE" == ${XYC_Y} ]; then
      #rewrite a new autoexec.ash with current photo params
      echo "lu_util exec '$THIS_SCRIPT -i $ISO -e $EXP -w $AWB -n $RNR -r $RAW -u $INC_USER -q'" >> $OUTFILE
      echo "" >> $OUTFILE
    fi

    if [ "$TLOFF" == ${XYC_Y} ]; then
      echo "poweroff yes" >> $OUTFILE
      echo "" >> $OUTFILE
    fi
  fi

  #If requested, write hdr script
  if [[ "$SCRIPT_TYPE" == "hdr" && ! -z $AUTAN ]]; then
    echo "#HDR script by nutsey" >> $OUTFILE
    echo "sleep 7" >> $OUTFILE
    
    echo "#beep" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t pwm 1 enable" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t pwm 1 disable" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    
    echo "#beep" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t pwm 1 enable" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t pwm 1 disable" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE

    echo "t ia2 -ae still_shutter $HDR1" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    if [ $AUTAN -eq 2 ]; then
      echo "sleep 18" >> $OUTFILE
    else
      echo "sleep 3" >> $OUTFILE
    fi

    if [ $AUTAN -eq 1 ]; then
      echo "#1/50" >> $OUTFILE
      echo "t ia2 -ae still_shutter 1100" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 2" >> $OUTFILE
      
      echo "#1/245" >> $OUTFILE
      echo "t ia2 -ae still_shutter 1400" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 2" >> $OUTFILE
    elif [ $AUTAN -eq 2 ]; then
      echo "#5.4" >> $OUTFILE
      echo "t ia2 -ae still_shutter 70" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 15" >> $OUTFILE
      
      echo "#3.5" >> $OUTFILE
      echo "t ia2 -ae still_shutter 150" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 13" >> $OUTFILE
    fi

    echo "t ia2 -ae still_shutter $HDR2" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    if [ $AUTAN -eq 2 ]; then
      echo "sleep 12" >> $OUTFILE
    else
      echo "sleep 2" >> $OUTFILE
    fi

    if [ $AUTAN -eq 1 ]; then
      echo "#1/1630" >> $OUTFILE
      echo "t ia2 -ae still_shutter 1750" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 2" >> $OUTFILE
    elif [ $AUTAN -eq 2 ]; then
      echo "#1.0" >> $OUTFILE
      echo "t ia2 -ae still_shutter 500" >> $OUTFILE
      echo "sleep 1" >> $OUTFILE
      echo "t app key shutter" >> $OUTFILE
      echo "sleep 12" >> $OUTFILE
    fi

    echo "t ia2 -ae still_shutter $HDR3" >> $OUTFILE
    echo "sleep 1" >> $OUTFILE
    echo "t app key shutter" >> $OUTFILE
    if [ $AUTAN -eq 2 ]; then
      echo "sleep 10" >> $OUTFILE
    else
      echo "sleep 2" >> $OUTFILE
    fi
    
    echo "" >> $OUTFILE
  fi

  echo "#short beep" >> $OUTFILE
  echo "t pwm 1 enable" >> $OUTFILE
  echo "sleep 1" >> $OUTFILE
  echo "t pwm 1 disable" >> $OUTFILE
  echo "" >> $OUTFILE
  
  promptToRestart
}

promptToRestart ()
{
  echo "Restart your camera to apply settings."
  echo "The camera might be freezed after restart via telnet."
  echo "If you have this issue restart camera manualy."
  echo ""
  # reboot may not work on 1.2.12
  #local REPLY=${XYC_N}
  #read -p "${XYC_RESTART_NOW_PROMPT}? [${XYC_ENTER}=$REPLY]: " REPLY
  #if [ -n $REPLY ]; then
  #  if [ "$REPLY" == ${XYC_Y} ]; then EXITACTION="reboot"; fi
  #fi
  #clear
}


#Main program
parseExistingAutoexec
parseCommandLine $*
setMissingValues

if [ $NOUI -eq 1 ]; then
  writeAutoexec
else
  welcome
  showMainMenu
fi

if [ "$EXITACTION" == "reboot" ]; then
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
