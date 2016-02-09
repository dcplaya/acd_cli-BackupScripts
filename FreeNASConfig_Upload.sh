#!/bin/bash
# This script will upload all files in /mnt/TVShows to Amazon Cloud Drive using acd_cli to /Video/TV Shows
# It will skip already uploaded files by comparing hashes

#Set to true if you want to run acd_cli with verbose
verbose=true

#Set location of acd_cli
acd_cli=/home/drew/acd_cli/acd_cli.py

#Set local location of files to upload. Everything in this folder will be uploaded but no the folder itself
local_location=/mnt/ERLBackups/freenas/

#Set remote location on ACD
remote_location=/FreeNAS/Config/

#Set location of where to store log file as well as the name
log_location=/home/drew/acd_cli-BackupScripts/FreeNASConfig_Upload.log






# Start of actual code!
################################################################################################################################################
#Sync to make sure we have the most up to date file structure
python3 "$acd_cli" sync

# Check for target folder location, create it if it doesn't exist
if [ -z "$(python3 "$acd_cli" resolve "$remote_location")" ]
then
	echo "Creating "$remote_location" In Amazon Cloud Drive"
	python3 "$acd_cli" create -p "$remote_location"
else
	echo ""$remote_location" Already Exists"
fi


if [ "$verbose" == true ]				
then
	echo "Verbose enabled!"
	python3 "$acd_cli" -v sync										# Syncs with ACD before uploading to make sure we have the most up to date info
	python3 "$acd_cli" -v upload "$local_location"* "$remote_location" 2> >(tee "$log_location" >&2)	# Starts uploading with the locations set at the top of this script
else
	python3 "$acd_cli" -v sync                                              				# Syncs with ACD before uploading to make sure we have the most up to date info
	python3 "$acd_cli" -v upload "$local_location"* "$remote_location"       				# Starts uploading with the locations set at the top of this script
fi


exit 0
