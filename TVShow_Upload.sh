#!/bin/bash
# This script will upload all files in /mnt/TVShows to Amazon Cloud Drive using acd_cli to /Video/TV Shows
# It will skip already uploaded files by comparing hashes

/home/drew/acd_cli/acd_cli.py upload /mnt/TVShows/* /Video/TV\ Shows/
