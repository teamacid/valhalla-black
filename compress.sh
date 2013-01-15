#!/bin/bash
input_file="installer.zip"
remote_dir="/sdcard"
remote_file="update.zip"
ROOT_DIR=$(pwd)

clear

if [ "$1" == "update" ]; then
  # This is where we update the apps. Normally you'll want to update the app on
  # the VB install on your phone, then run this.

  # We'll grab the following apps from the web
  wget -O data/app/com.keramidas.TitaniumBackupPro-1.apk http://matrixrewriter.com/android/files/TitaniumBackup_latest.apk
  wget -O system/app/UpdateMeSmartphone.apk http://dl.dropbox.com/u/3681387/UpdateMeSmartphone.apk
  wget -O data/app/com.alensw.PicFolder-1.apk http://alensw.com/attachment/QuickPic_2.8.1.apk

  # All these apps we're going to pull from the phone
  data_apps=(
    com.fevdev.nakedbrowser-1.apk
    com.jb.gosms-2.apk
    com.mxtech.ffmpeg.v7_neon-2.apk
    com.mxtech.videoplayer.ad-2.apk
    com.touchtype.swiftkey.phone.trial-1.apk
    jackpal.androidterm-2.apk
    name.markus.droesser.tapeatalk-2.apk
    neldar.bln.control.free-2.apk
    QuickBoot.apk
  )
  system_apps=(
    org.adw.launcher.apk
    Superuser.apk
    VisualVoicemail.apk
  )

  echo
  echo Pulling /data apps
  cd $ROOT_DIR/data/app
  # Now we go through each app in the list and pull it off the phone
  for app in "${data_apps[@]}"; do
    echo "Pulling ${app}"
    adb pull /data/app/${app}
  done

  echo
  echo Pulling /system apps
  cd $ROOT_DIR/system/app
  # Now we go through each app in the list and pull it off the phone
  for app in "${system_apps[@]}"; do
    echo "Pulling ${app}"
    adb pull /system/app/${app}
  done

  echo
  echo Updating su binary
  cd $ROOT_DIR/system/xbin
  # Now we go through each app in the list and pull it off the phone
  adb pull /system/xbin/su

  echo "Update complete, exiting."
  exit 0
fi

# Main script
echo "Removing old zip file"
rm -f $input_file

echo "Creating zip file"
zip -r -9 $input_file data META-INF system tools updates

echo "Transferring installer"
adb push $input_file $remote_dir/$remote_file

if [ "$?" == "0" ]; then
  echo ""
  echo "Installer transfered!"
fi

