#!/bin/bash
# This script will upload file in /mnt/Proxmox_VM_ISO/dump folder to Amazon Cloud Storage /Proxmox/Backups
# Each Vm will upload in its own folder (Example, VM 109 will upload to /Proxmox/Backups/109
# It will skip already uploaded files by comparing hashes

# Set path to acd_cli
acd_cli=/home/drew/acd_cli/acd_cli.py

#vm_number="109"

# Sync ACD first. This is a quick sync, not a full sync
$acd_cli sync

# Find all files in the dump folder and parse out which VMs they belong to
find /mnt/Proxmox_VM_ISO/dump -type f -name '*' -print0 | while IFS= read -r -d '' file; do

        vm_name=${file#*-*-}
   	vm_number=${vm_name:0:3}
        printf '%s\n' "Making $vm_number Directory In ACD"



	# Making directories for each VM found in the dump folder
	$acd_cli mkdir /Proxmox/Backups/$vm_number

	# Start uploading all the VM files to the respective VM folders
	$acd_cli upload $file /Proxmox/Backups/$vm_number/
done
