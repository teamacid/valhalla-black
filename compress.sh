#!/bin/bash
input_file="installer.zip"
remote_dir="/sdcard"
remote_file="update.zip"

clear

if [ "$1" == "update" ]; then
  # This is where we update the apps. Normally you'll want to update the app on
  # the VB install on your phone, then run this.
  
  # TitaniumBackup is the only app that we'll grab from the web
  #wget -O data/app/com.keramidas.TitaniumBackupPro-1.apk http://matrixrewriter.com/android/files/TitaniumBackup_latest.apk

  # All these apps we're going to pull from the phone
  cd data/app
  apps=(
    com.alensw.PicFolder-1.apk
    neldar.bln.control.free-1.apk
    com.boatbrowser.free-2.apk
    com.jb.gosms-2.apk
    com.gau.go.launcherex-2.apk
    kov.theme.ics-2.apk
    com.mxtech.ffmpeg.v7_neon-2.apk
    com.mxtech.videoplayer.ad-2.apk
    QuickBoot.apk
    com.touchtype.swiftkey.phone.trial-1.apk
    name.markus.droesser.tapeatalk-1.apk
    jackpal.androidterm-2.apk
    org.projectvoodoo.controlapp-1.apk
  )

  # Now we go through each app in the list and pull it off the phone
  for app in "${apps[@]}"; do
    echo "Pulling ${app}"
    adb pull /data/app/${app}
  done

  echo "Update complete. Exiting."
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
