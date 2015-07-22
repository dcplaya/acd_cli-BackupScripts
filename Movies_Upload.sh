#!/bin/bash
# This script will upload all files in $local_location to Amazon Cloud Drive using acd_cli to $remote_location
# It will skip already uploaded files by comparing hashes

#Set to true if you want to run acd_cli with verbose
verbose=true

#Set location of acd_cli
acd_cli=/home/drew/acd_cli/acd_cli.py

#Set local location of files to upload. Everything in this folder will be uploaded but no the folder itself
local_location=/mnt/Movies/

#Set remote location on ACD
remote_location=/Video/Movies/

#Set location of where to store log file as well as the name
log_location=/home/drew/acd_cli-BackupScripts/Movies_Upload.log






# Start of actual code!
################################################################################################################################################
#Sync to make sure we have the most up to date file structure


if [ "$verbose" == true ]				
then
	echo "Verbose enabled!"
	"$acd_cli" -v sync										# Syncs with ACD before uploading to make sure we have the most up to date info
	"$acd_cli" -v upload -x 4 "$local_location"* "$remote_location" 2> >(tee "$log_location" >&2)	# Starts uploading with the locations set at the top of this script
else
	"$acd_cli" -v sync                                              				# Syncs with ACD before uploading to make sure we have the most up to date info
	"$acd_cli" -v upload -x 4 "$local_location"* "$remote_location"       				# Starts uploading with the locations set at the top of this script
fi


exit 0
