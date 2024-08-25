#!/bin/bash

# Define default password
DEFAULT_PASSWORD="bootcamp2024"  # Replace with your actual password

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
  "etimp"
)

# Function to set up Mambaforge and ipykernel for a user
setup_user_environment() {
  USERNAME="$1"
  
  # Switch to the user's home directory
  cd /home/$USERNAME
  
  # Install Mamba Miniforge
  wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O Mambaforge.sh
  bash Mambaforge.sh -b -p /home/$USERNAME/mambaforge
  
  # Initialize Mambaforge
  /home/$USERNAME/mambaforge/bin/conda init bash
  
  # Install ipykernel directly in the base environment using Mamba
  /home/$USERNAME/mambaforge/bin/mamba install -y ipykernel
  
  # Register ipykernel with Jupyter
  /home/$USERNAME/mambaforge/bin/python -m ipykernel install --user --name base --display-name "Python (base)"
}

# Loop to create users and set up their environments
for USERNAME in "${USERNAMES[@]}"; do

  # Create user with home directory
  sudo useradd -m -s /bin/bash "$USERNAME"
  
  # Set default password for the user
  echo "$USERNAME:$DEFAULT_PASSWORD" | sudo chpasswd
  
  echo "Created user: $USERNAME"
  
  # Give ownership of the home directory to the new user
  sudo chown -R "$USERNAME":"$USERNAME" "/home/$USERNAME"
  
  # Run the environment setup function as the new user
  sudo -u "$USERNAME" bash -c "$(declare -f setup_user_environment); setup_user_environment $USERNAME"

  echo "Mambaforge installed and ipykernel set up in base environment for user: $USERNAME"

done

echo "All users created and configured!"
