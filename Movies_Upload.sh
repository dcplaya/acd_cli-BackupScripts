#!/bin/bash
# This script will upload all files in /mnt/Movies to Amazon Cloud Drive using acd_cli to /Video/Movies
# It will skip already uploaded files by comparing hashes

/home/drew/acd_cli/acd_cli.py upload /mnt/Movies/* /Video/Movies/
