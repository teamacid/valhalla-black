#!/bin/bash
input_file="installer.zip"
remote_dir="/sdcard"
remote_file="update.zip"

if [ "$1" == "backup" ]; then
  adb push tools/data-backup /tmp/
  adb push tools/data-restore /tmp/
  adb push system/xbin/busybox /tmp/
  adb shell 'chmod +x /tmp/*'
  exit
fi

# Main script
echo "Creating zip file"
zip --quiet -r -9 $input_file data META-INF system tools updates

echo "Transferring installer"
adb push $input_file $remote_dir/$remote_file

if [ "$?" == "0" ]; then
  echo ""
  echo "Installer transfered!"
fi
