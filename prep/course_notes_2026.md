## Running notes/problems from FA26 BCMB Bootcamp
- Disk size needs to be expanded prior to day1 (Azure default of 30GB is too small))
- Need to actually _execute_ the `create_azure_users.sh` and `install_hg19_reference.sh` scripts prior to day1 (they are not executed automatically).
- Day 1 requires push of data files to user accounts since they have not done git module yet.
    - `for f in /home/*; do sudo cp test.fa $f/ ; done;`
    - `for f in /home/*; do sudo cp /home/loyal/bcmb_bootcamp/day1/notebooks/data $f/; done;`
- Need to auto install python OR live-instruct on how to install python
- Need to confirm that `mamba`, `python`and Python VSCode extension(s) ('Python' and 'Python Environment', etc.) are installed EARLY ON, because troubleshooting mid week is a pain.
- Prefer 'Minimamba Envs' over buggy 'Python Environments' in VSCode for managing environments.
    - Also requires complete restart of VSCode or 'Developer: Reload Window' to see the environments.