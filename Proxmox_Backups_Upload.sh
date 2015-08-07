#!/bin/bash
# This script will upload file in /mnt/Proxmox_VM_ISO/dump folder to Amazon Cloud Storage /Proxmox/Backups
# Each Vm will upload in its own folder (Example, VM 109 will upload to /Proxmox/Backups/109
# It will skip already uploaded files by comparing hashes

# Set path to acd_cli
acd_cli=/home/drew/acd_cli/acd_cli.py

# Set path to backups
backups=/mnt/ProxmoxBackups/dump

# Maximum size of file in GB (Gigabytes) to upload
maxsizeGB=50

############################## END config parameters #########################


# Convert max file size from GB to bytes
maxsize=`expr $maxsizeGB \* 1073741824`

# Sync ACD first. This is a quick sync, not a full sync
$acd_cli sync

# Find all files in the dump folder and parse out which VMs they belong to
find $backups -type f -name '*' -print0 | while IFS= read -r -d '' file; do

        vm_name=${file#*-*-}
   	vm_number=${vm_name:0:3}
        printf '%s\n' "Making $vm_number Directory In ACD"



	# Making directories for each VM found in the dump folder
	$acd_cli mkdir /Proxmox/Backups/$vm_number

	# Check the file size limit, dont upload if larger than specified size
	actualsize=$(wc -c <"$file")
	#printf '%s\n' "The size of the file is $actualsize"
	actualsizeGB=$(echo "scale=2; $actualsize/1073741824" | bc -l) 

	if [ $actualsize -lt $maxsize ]; then
		
		# Start uploading all the VM files to the respective VM folders
		printf '%s\n' "[INFO] - File size $actualsizeGB GB < $maxsizeGB GB"
		$acd_cli upload $file /Proxmox/Backups/$vm_number/
	else
		printf '%s\n' "[WARNING] - File size larger than specified"
	fi
			
done
