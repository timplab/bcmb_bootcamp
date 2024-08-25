#!/bin/bash

# Define default password
DEFAULT_PASSWORD="YourDefaultPassword"  # Replace with your actual password

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

# Loop to create users
for USERNAME in "${USERNAMES[@]}"; do

  # Create user with home directory
  sudo useradd -m -s /bin/bash "$USERNAME"
  
  # Set default password for the user
  echo "$USERNAME:$DEFAULT_PASSWORD" | sudo chpasswd
  
  echo "Created user: $USERNAME"
  
  # Switch to the user's home directory
  sudo -H -u "$USERNAME" bash << EOF
  
  # Install Mamba Miniforge
  wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O Mambaforge.sh
  bash Mambaforge.sh -b -p /home/$USERNAME/mambaforge
  
  # Initialize Mambaforge
  /home/$USERNAME/mambaforge/bin/conda init bash
  
  # Install ipykernel directly in the base environment using Mamba
  /home/$USERNAME/mambaforge/bin/mamba install -y ipykernel
  
  # Register ipykernel with Jupyter
  /home/$USERNAME/mambaforge/bin/python -m ipykernel install --user --name base --display-name "Python (base)"
EOF

  echo "Mambaforge installed and ipykernel set up in base environment for user: $USERNAME"

done

echo "All users created and configured!"
