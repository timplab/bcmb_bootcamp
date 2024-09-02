#!/bin/bash

# Define the destination directory for zip files
DEST_DIR="/home/timp/studentzips"

# List of usernames derived from email addresses
USERNAMES=(
  "marnol30"
  "aatkin31"
  "cbereda1"
  "pcann1"
  "schan102"
  "achen94"
  "adavid33"
  "odimowo1"
  "adumm1"
  "ngurley2"
  "nhagger1"
  "hhuan131"
  "dhunt22"
  "vjiang2"
  "nle25"
  "emahone9"
  "tmandl2"
  "gmarti85"
  "pnguye55"
  "mquint10"
  "jskidmo2"
  "mstoppl1"
  "cvalade1"
  "pwhite37"
  "ewinnic1"
  "jwong82"
  "fzhong3"
)

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Loop through each user and compress their home directory
for USERNAME in "${USERNAMES[@]}"; do
  # Source home directory
  USER_HOME="/home/$USERNAME"
  
  # Destination zip file
  ZIP_FILE="$DEST_DIR/${USERNAME}.zip"
  
  # Check if the user's home directory exists
  if [ -d "$USER_HOME" ]; then
    # Compress the user's home directory into a zip file excluding 'working' and 'mambaforge' directories
    sudo zip -y -r "$ZIP_FILE" "$USER_HOME" -x "$USER_HOME/working/*" "$USER_HOME/mambaforge/*"
    echo "Compressed $USER_HOME to $ZIP_FILE excluding 'working' and 'mambaforge' directories"
  else
    echo "Home directory for user $USERNAME does not exist, skipping."
  fi
done

echo "All home directories have been compressed into $DEST_DIR."