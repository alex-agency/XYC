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
# 0.2.0 (Aug 2015) - Added support for alternate langauges
#                  - Added support for user settings
#                  - Standardized menu interface
# 0.1.0 (Aug 2015) - Initial release
# Disclaimer: This software is not created or endorsed by Xiaomi; it relies on
# undocumented features of the Xiaomi Yi. Using this software may void your
# camera's warranty and possibly damage your camera.  Use at your own risk!

VERS="0.2.0"
FUSED=/tmp/fuse_d
AASH=${FUSED}/autoexec.ash
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
XYC_VIEW_EDIT_SETTINGS="View/Edit custom photo settings"
XYC_RESET_SETTINGS="Reset/Delete custom photo settings"
XYC_CURRENT_SETTINGS="Current custom photo settings"
XYC_CREATE_TIME_LAPSE="Create/Run time-lapse script"
XYC_SHOW_CARD_SPACE="Show SD card space usage"
XYC_RESTART_CAMERA="Restart camera"
XYC_EXIT="Exit"
XYC_BACK="Back"
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
XYC_YES="yes"
XYC_NO="no"
XYC_Y="y"
XYC_N="n"
XYC_ON="on"
XYC_OFF="off"
XYC_TIME_LAPSE_PARAMS="TLParams"
XYC_AUTO="Auto"
XYC_ENTER="Enter"
XYC_CHOOSE="Choose"
XYC_ENTER_EXPOSURE_PROMPT_2="Enter 0-2047 to select exposure"
XYC_ENTER_EXPOSURE_PROMPT="Exposure: ?(help), 0-2047"
XYC_ENTER_ISO_PROMPT="ISO: 0(auto), 100-25600"
XYC_ENTER_AWB_PROMPT="Auto-Whitebalance (y/n)"
XYC_REDUCE_NR_PROMPT="Reduce noise-reduction (y/n)"
XYC_CREATE_RAW_PROMPT="Create RAW files (y/n)"
XYC_ENTER_NUM_SHOTS_MENU="Number of images (0=off)"
XYC_ENTER_NUM_SHOTS_PROMPT="Enter number of images (0=off, 1-9999)"
XYC_RUN_ONCE_ONLY_MENU="One-time script"
XYC_RUN_ONCE_ONLY_PROMPT="Run once only? (y=once/n=multi)"
XYC_POWEROFF_WHEN_COMPLETE_MENU="Poweroff when complete"
XYC_POWEROFF_WHEN_COMPLETE_PROMPT="Poweroff when complete (y/n)"
XYC_DELAY_BETWEEN_SHUTTER_MENU="Delay between shutter press"
XYC_DELAY_BETWEEN_SHUTTER_PROMPT="Delay between shutter press (secs)"
XYC_RESTART_NOW_PROMPT="Restart camera now (y/n)"
XYC_REBOOTING_NOW="Rebooting now"
XYC_SHUTTING_DOWN_NOW="Shutting down now"
XYC_WRITING="Writing"

XYC_PHOTO_SETTINGS_MENU="Custom Photo Settings Menu"
XYC_INCLUDE_USER_SETTINGS_PROMPT="Import additional settings from autoexec.xyc (y/n)"
XYC_TIME_LAPSE_MENU="Time Lapse Menu"
XYC_CANNOT_READ="WARNING: Cannot read/access"

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
  echo "   **************************** "
  echo "   *  Xiaomi Yi Configurator  * "
  echo "   *  8/23/2015        ${VERS}  * "
  echo "   **************************** "
  echo ""
}


showMainMenu ()
{
  local REPLY=0
  while [[ $REPLY -gt -1 && $REPLY -lt 5 ]]
  do
    echo "    ==== ${XYC_MAIN_MENU} ===="
    echo " [1] $XYC_VIEW_EDIT_SETTINGS"
    echo " [2] $XYC_RESET_SETTINGS"
    echo " [3] $XYC_CREATE_TIME_LAPSE"
    echo " [4] $XYC_SHOW_CARD_SPACE"
    echo " [5] $XYC_RESTART_CAMERA"
    echo " [6] $XYC_EXIT"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    clear
    case $REPLY in
      0) cat $AASH;;
      1) showSettingsMenu; writeAutoexec $AASH "settings";;
      2) removeAutoexec; resetCameraSettings;;
      3) showTimeLapseMenu; if [ $TLNUM -gt 0 ]; then writeAutoexec $AASH "timelapse"; promptToRestart; else writeAutoexec $AASH; fi;;
      4) showSpaceUsage;;
      5) EXITACTION="reboot";;
      6) EXITACTION="nothing";;
      *) echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac

  done
  clear
}


showSettingsMenu ()
{
  local REPLY=0
  while [[ $REPLY -gt -1 && $REPLY -lt 8 ]]
  do
    echo "    ==== ${XYC_PHOTO_SETTINGS_MENU} ===="
    echo " [1] ${XYC_EXPOSURE} [Current=$EXP]"
    echo " [2] ${XYC_ISO} [Current=$ISO]"
    echo " [3] ${XYC_AWB} [Current=$AWB]"
    echo " [4] ${XYC_REDUCE_NR} [Current=$RNR]"
    echo " [5] ${XYC_CREATE_RAW} [Current=$RAW]"
    echo " [6] ${XYC_IMPORT_USER_SETTINGS} ${USER_SETTINGS_FILE} [Current=${INC_USER}]"
    echo " [7] $XYC_BACK"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getExposureInput; clear;;
      2) getISOInput; clear;;
      3) getAWBInput; clear;;
      4) getNRInput; clear;;
      5) getRawInput; clear;;
      6) getIncludeUserSettings; clear;;
      7) return 0;;
      *) clear; echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac
  done

  clear
}

showTimeLapseMenu ()
{
  local REPLY=0
  resetDelaySuggestion
  while [[ $REPLY -gt -1 && $REPLY -lt 6 ]]
  do
    echo "    ==== ${XYC_TIME_LAPSE_MENU} ===="
    echo " [1] ${XYC_ENTER_NUM_SHOTS_MENU} [Current=$TLNUM]"
    echo " [2] ${XYC_DELAY_BETWEEN_SHUTTER_MENU} [Current=$TLDELAY]"
    echo " [3] ${XYC_POWEROFF_WHEN_COMPLETE_MENU} [Current=$TLOFF]"
    echo " [4] ${XYC_RUN_ONCE_ONLY_MENU} [Current=$TLONCE]"
    echo " [5] $XYC_BACK"

    read -p "${XYC_SELECT_OPTION}: " REPLY
    case $REPLY in
      1) getTLNumShots; clear;;
      2) getTLDelay; clear;;
      3) getTLOff; clear;;
      4) getTLOnce; clear;;
      5) return 0;;
      *) clear; echo "$XYC_INVALID_CHOICE"; REPLY=0;;
    esac
  done

  clear
}

showSpaceUsage ()
{
    local JPEG_COUNT=`find ${FUSED} -name *.jpg | wc -l`
    local RAW_COUNT=`find ${FUSED} -name *.RAW | wc -l`
    local MP4_COUNT=`find ${FUSED} -name *.mp4 | wc -l`

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
	echo "  JPEG=$JPEG_COUNT, RAW=$RAW_COUNT, MP4=$MP4_COUNT"
	echo ""
	echo "${XYC_ESTIMATED_REMAINING}:"
	echo "  JPEG=$JPEG_LEFT, RAW=$RAW_LEFT, MP4=$MP4_LEFT ${XYC_MINUTES}"
	echo ""
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
}


resetCameraSettings ()
{
  unset ISO EXP AWB RAW RNR INC_USER
  setMissingValues
}

setMissingValues ()
{
  #Set reasonable defaults for any missing values
  if [ -z "$ISO" ]; then ISO=0; fi
  if [ -z "$EXP" ]; then EXP=0; fi
  if [[ "$AWB" != ${XYC_Y} && "$AWB" != ${XYC_N} ]]; then AWB=${XYC_Y}; fi
  if [[ "$RNR" != ${XYC_Y} && "$RNR" != ${XYC_N} ]]; then RNR=${XYC_N}; fi
  if [[ "$RAW" != ${XYC_Y} && "$RAW" != ${XYC_N} ]]; then RAW=${XYC_N}; fi
  if [[ "${INC_USER}" != ${XYC_Y} && "${INC_USER}" != ${XYC_N} ]]; then INC_USER=${XYC_N}; fi
}


showExposureValues ()
{
  #TODO: Make these choices more intuitive to photographers
  printf "${XYC_ENTER_EXPOSURE_PROMPT_2}:\n"
  printf "%s\t%s\t%s\n" "0=auto-exp " "1=8s       " "8=7.7s"
  printf "%s\t%s\t%s\n" "50=6.1s    " "84=5.s     " "100=4.6s"
  printf "%s\t%s\t%s\n" "200=2.7s   " "400=1s     " "500=1s"
  printf "%s\t%s\t%s\n" "590=1/3    " "600=1/5    " "700=1/5"
  printf "%s\t%s\t%s\n" "800=1/10   " "900=1/15   " "1000=1/30"
  printf "%s\t%s\t%s\n" "1100=1/50  " "1145=1/60  " "1200=1/80"
  printf "%s\t%s\t%s\n" "1275=1/125 " "1300=1/140 " "1405=1/250"
  printf "%s\t%s\t%s\n" "1450=1/320 " "1500=1/420 " "1531=1/500"
  printf "%s\t%s\t%s\n" "1600=1/624 " "1607=1/752 " "1660=1/1002"
  printf "%s\t%s\t%s\n" "1700=1/1244" "1750=1/1630" "1800=1/2138"
  printf "%s\t%s\t%s\n" "1825=1/2448" "1850=1/2803" "1900=1/3675"
  printf "%s\t%s\t%s\n" "2000=1/6316" "2047=1/8147"
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
  local REPLY=$EXP
  read -p "${XYC_ENTER_EXPOSURE_PROMPT} [${XYC_ENTER}=$EXP]: " REPLY
  if [ -n "$REPLY" ]; then
    if [ "$REPLY" == "s" ]; then
      SKIP=1
    elif [ "$REPLY" == "?" ]; then
      showExposureValues
      getExposureInput
    elif [[ $REPLY -gt -1 && $REPLY -lt 2048 ]]; then
      EXP=$REPLY
    fi
  fi
}

getISOInput ()
{
  local REPLY=$ISO
  read -p "${XYC_ENTER_ISO_PROMPT} [${XYC_ENTER}=$ISO]: " REPLY
  if [ -n "$REPLY" ]; then
    if [ "$REPLY" == "s" ]; then
      SKIP=1
    elif [[ $REPLY -eq 0 || $REPLY -eq 100 || $REPLY -eq 200 ||  $REPLY -eq 400 || $REPLY -eq 800 || $REPLY -eq 1600 || $REPLY -eq 3200 || $REPLY -eq 6400 || $REPLY -eq 12800 || $REPLY -eq 25600 ]]; then
      ISO=$REPLY
    else
      echo "${XYC_CHOOSE}: 0,100,200,400...25600"
      getISOInput
    fi
  fi
}

getAWBInput ()
{
  local REPLY=$AWB
  read -p "${XYC_ENTER_AWB_PROMPT} [${XYC_ENTER}=$AWB]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then AWB=$REPLY; fi
}

getNRInput ()
{
  local REPLY=$RNR
  read -p "${XYC_REDUCE_NR_PROMPT} [${XYC_ENTER}=$RNR]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then RNR=$REPLY; fi
}

getRawInput ()
{
  local REPLY=$RAW
  read -p "${XYC_CREATE_RAW_PROMPT} [${XYC_ENTER}=$RAW]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then RAW=$REPLY; fi
}

getIncludeUserSettings ()
{
  local REPLY=$INC_USER
  read -p "${XYC_INCLUDE_USER_SETTINGS_PROMPT} [${XYC_ENTER}=$REPLY]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then INC_USER=$REPLY; fi
}


getTLNumShots()
{
  local REPLY=$TLNUM
  read -p "${XYC_ENTER_NUM_SHOTS_PROMPT} [${XYC_ENTER}=$TLNUM]: " REPLY
  if [ -n "$REPLY" ]; then TLNUM=$REPLY; fi
}

getTLOnce()
{
  local REPLY=$TLONCE
  read -p "${XYC_RUN_ONCE_ONLY_PROMPT} [${XYC_ENTER}=$TLONCE]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then TLONCE=$REPLY; fi
}

getTLOff()
{
  local REPLY=$TLOFF
  read -p "${XYC_POWEROFF_WHEN_COMPLETE_PROMPT} [${XYC_ENTER}=$TLOFF]: " REPLY
  if [[ "$REPLY" == ${XYC_Y} || "$REPLY" == ${XYC_N} ]]; then TLOFF=$REPLY; fi
}

getTLDelay()
{
  #resetDelaySuggestion
  #TLDELAY=$?
  local REPLY=$TLOFF
  read -p "${XYC_DELAY_BETWEEN_SHUTTER_PROMPT} [${XYC_ENTER}=$TLDELAY]: " REPLY
  if [ -n "$REPLY" ]; then TLDELAY=$REPLY; fi
}


removeAutoexec ()
{
  #Note: This works in "t": rm 'd:\autoexec.ash'
  rm -f ${FUSED}/autoexec.ash
}

writeAutoexec ()
{
  OUTFILE=${1:-$AASH}
  SCRIPT_TYPE=${2:-"settings"}

  echo "${XYC_WRITING} $OUTFILE"

  #Write any necessary script commands to autoexec.ash
  echo "#Script created by xyc.sh ${VERS}" > $OUTFILE
  echo "#CameraParams: $ISO $EXP $AWB $RNR $RAW" >> $OUTFILE
  echo "#UserSettings: $INC_USER" >> $OUTFILE
  echo "#TimeLapseParams: $TLNUM $TLONCE $TLOFF $TLDELAY" >> $OUTFILE
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

  if [[ $ISO -ne 0 || $EXP -ne 0 ]]; then
    echo "#Set ISO and exposure" >> $OUTFILE
    echo "t ia2 -ae exp $ISO $EXP" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ $AWB == ${XYC_N} ]; then
    echo "#Set auto-whitebalance" >> $OUTFILE
    echo "t ia2 -awb off" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  if [ $RNR == ${XYC_Y} ]; then
    echo "#Reduce noise reduction as much as possible" >> $OUTFILE
    echo "t ia2 -adj tidx -1 -1 -1" >> $OUTFILE
    echo "" >> $OUTFILE
  fi


  if [ $RAW == ${XYC_Y} ]; then
    echo "#Create RAW files" >> $OUTFILE
    echo "t app test debug_dump 14" >> $OUTFILE
    echo "" >> $OUTFILE
  fi

  echo "" >> $OUTFILE

  #If requested, write time-lapse script
  if [ $SCRIPT_TYPE == "timelapse" ]; then
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

    if [ $TLONCE == ${XYC_Y} ]; then
      #rewrite a new autoexec.ash with current photo params
      echo "lu_util exec '$THIS_SCRIPT -i $ISO -e $EXP -w $AWB -n $RNR -r $RAW -u $INC_USER -q'" >> $OUTFILE
      echo "" >> $OUTFILE
    fi

    if [ $TLOFF == ${XYC_Y} ]; then
      echo "poweroff yes" >> $OUTFILE
      echo "" >> $OUTFILE
    fi
  fi
}


promptToRestart ()
{
  local REPLY=${XYC_N}
  read -p "${XYC_RESTART_NOW_PROMPT}? [${XYC_ENTER}=$REPLY]: " REPLY
  if [ -n $REPLY ]; then
    if [ $REPLY == ${XYC_Y} ]; then EXITACTION="reboot"; fi
  fi
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
  echo "${XYC_REBOOTING_NOW}..."
  sleep 1
  reboot yes
elif [ "$EXITACTION" == "poweroff" ]; then
  echo "${XYC_SHUTTING_DOWN_NOW}..."
  sleep 1
  poweroff yes
fi
