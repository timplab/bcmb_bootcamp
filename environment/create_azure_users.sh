#!/bin/bash

# Define default password
DEFAULT_PASSWORD="bootcamp2025"  # Replace with your actual password

# List of usernames derived from email addresses
USERNAMES=(
    "hayten1"
    "bcassat2"
    "ddu6"
    "cgardin8"
    "jgeszte1"
    "qmewbor1"
    "smorave1"
    "speralt1"
    "ariley27"
    "bveresk1"
    "zwei20"
    "ayanez1"
    "cyazzie4"
)


# Function to set up Mambaforge and ipykernel for a user
setup_user_environment() {
  USERNAME="$1"
  
  # Switch to the user's home directory
  cd /home/$USERNAME
  
  # Install Mamba Miniforge
  wget https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-Linux-x86_64.sh -O Miniforge.sh
  bash Miniforge.sh -b -p /home/$USERNAME/miniforge
  
  # Initialize Mambaforge
  /home/$USERNAME/miniforge/bin/conda init bash
  
  # Install ipykernel directly in the base environment using Mamba
  /home/$USERNAME/miniforge/bin/mamba install -y ipykernel
  
  # Register ipykernel with Jupyter
  /home/$USERNAME/miniforge/bin/python -m ipykernel install --user --name base --display-name "Python (base)"
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

  echo "Miniforge installed and ipykernel set up in base environment for user: $USERNAME"

done

echo "All users created and configured!"
