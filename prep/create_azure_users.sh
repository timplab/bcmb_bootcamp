#!/bin/bash

USERNAME_FILE="${1:-}"

if [[ -z "$USERNAME_FILE" || ! -f "$USERNAME_FILE" ]]; then
  echo "Usage: $0 /path/to/usernames.txt" >&2
  exit 1
fi

# Read one username per line. Blank lines are ignored.
USERNAMES=()
while IFS= read -r USERNAME || [[ -n "$USERNAME" ]]; do
  USERNAME="${USERNAME%$'\r'}"
  [[ -z "$USERNAME" ]] && continue
  USERNAMES+=("$USERNAME")
done < "$USERNAME_FILE"

if [[ ${#USERNAMES[@]} -eq 0 ]]; then
  echo "Error: no usernames found in $USERNAME_FILE." >&2
  exit 1
fi

# Prompt once for the shared initial password without displaying it.
read -r -s -p "Enter the shared initial password for all bootcamp users: " SHARED_PASSWORD
echo
read -r -s -p "Confirm the shared initial password: " SHARED_PASSWORD_CONFIRM
echo

if [[ -z "$SHARED_PASSWORD" ]]; then
  echo "Error: password cannot be empty." >&2
  exit 1
fi

if [[ "$SHARED_PASSWORD" != "$SHARED_PASSWORD_CONFIRM" ]]; then
  echo "Error: passwords do not match." >&2
  exit 1
fi

unset SHARED_PASSWORD_CONFIRM


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
  printf '%s:%s\n' "$USERNAME" "$SHARED_PASSWORD" | sudo chpasswd
  
  echo "Created user: $USERNAME"
  
  # Give ownership of the home directory to the new user
  sudo chown -R "$USERNAME":"$USERNAME" "/home/$USERNAME"
  
  # Run the environment setup function as the new user
  sudo -u "$USERNAME" bash -c "$(declare -f setup_user_environment); setup_user_environment $USERNAME"

  echo "Miniforge installed and ipykernel set up in base environment for user: $USERNAME"

done

unset SHARED_PASSWORD

echo "All users created and configured!"
