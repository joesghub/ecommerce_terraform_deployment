#!/bin/bash
####       FRONTEND SERVER        #####

echo "${ssh_key}" > /home/ubuntu/.ssh/workload_5.pem
chmod 400 /home/ubuntu/.ssh/workload_5.pem
#This ensures that the file is owned by ubuntu, allowing the user to use it for SSH connections without permission errors.
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/workload_5.pem


kura_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSkMc19m28614Rb3sGEXQUN+hk4xGiufU9NYbVXWGVrF1bq6dEnAD/VtwM6kDc8DnmYD7GJQVvXlDzvlWxdpBaJEzKziJ+PPzNVMPgPhd01cBWPv82+/Wu6MNKWZmi74TpgV3kktvfBecMl+jpSUMnwApdA8Tgy8eB0qELElFBu6cRz+f6Bo06GURXP6eAUbxjteaq3Jy8mV25AMnIrNziSyQ7JOUJ/CEvvOYkLFMWCF6eas8bCQ5SpF6wHoYo/iavMP4ChZaXF754OJ5jEIwhuMetBFXfnHmwkrEIInaF3APIBBCQWL5RC4sJA36yljZCGtzOi5Y2jq81GbnBXN3Dsjvo5h9ZblG4uWfEzA2Uyn0OQNDcrecH3liIpowtGAoq8NUQf89gGwuOvRzzILkeXQ8DKHtWBee5Oi/z7j9DGfv7hTjDBQkh28LbSu9RdtPRwcCweHwTLp4X3CYLwqsxrIP8tlGmrVoZZDhMfyy/bGslZp5Bod2wnOMlvGktkHs="
echo "$kura_key"  >> /home/ubuntu/.ssh/authorized_keys

#1. Clone the repository from GitHub
cd /home/ubuntu/
git clone https://github.com/joesghub/ecommerce_terraform_deployment.git

#2. Change directory into the cloned repository
cd /home/ubuntu/ecommerce_terraform_deployment/

#3. Install Node.js and npm by running:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs

# The first command sets up the NodeSource repository, which contains the Node.js binaries for your system.
# This command uses curl to download a setup script from NodeSource, which is a repository that provides Node.js packages.
# -f: Fail silently on HTTP errors.
# -s: Silent mode; it won't show progress or error messages.
# -S: Show error messages if the command fails.
# -L: Follow redirects if the URL has moved.
# | sudo -E bash -: This part pipes the downloaded script into bash, executing it with superuser privileges (sudo). 
# The -E option preserves the user’s environment when running sudo, which can be important for certain environment variables.
# The script will configure the NodeSource repository on your system, allowing you to install the latest LTS (Long-Term Support) version of Node.js.
# The second command installs Node.js from that repository.

#4. Update "package.json" and modify the "proxy" field to point to the backend EC2 private IP: 

cd /home/ubuntu/ecommerce_terraform_deployment/frontend/
private_ip=$(hostname -I | awk '{print $1}')
sed -i "s|http://private_ec2_ip:8000|http://$private_ip:8000|" package.json
# sed -i 's/http:\/\/private_ec2_ip:8000/http:\/\/$private_ip:8000/' package.json

####     Issue 3: Modifying package.json to get the Private IP address from the backend server

#5. Install the dependencies by running:
npm i

#Using npm i is an essential step in setting up your Node.js project, as it ensures that all required packages are available for your application to run correctly.
# What npm i Does
# Installs Packages:
# When you run npm i, npm reads the package.json file in the current directory to determine which packages are required for your project.
# Dependencies:
# It installs both dependencies (packages your project needs to run) and devDependencies (packages needed for development, such as testing frameworks and build tools) listed in the package.json.
# Creates a node_modules Folder:
# npm creates a node_modules directory in your project folder where it installs all the packages. This folder contains all the libraries your project depends on.
# Creates/Updates package-lock.json
# npm will also create or update the package-lock.json file, which locks the versions of installed packages. This ensures that subsequent installations are consistent across different environments.

# by way of Jon W. - add logs
mkdir -p /home/ubuntu/logs && touch /home/ubuntu/logs/frontend.log
# start frontend server, redirect stdout & stderr to logs/frontend.log

#Set Node.js options for legacy compatibility and start the app:
export NODE_OPTIONS=--openssl-legacy-provider && npm start > /home/ubuntu/logs/frontend.log 2>&1 &

# export: This command sets an environment variable in the shell. The variable will be available to all processes spawned from that shell.
# NODE_OPTIONS: This is a special environment variable that Node.js recognizes. It allows you to pass command-line options to the Node.js process when it starts.
# --openssl-legacy-provider: This specific option allows Node.js to use legacy OpenSSL providers, which can be necessary if your application depends on older cryptographic algorithms 
# 	or if you encounter compatibility issues with certain libraries that haven't updated to support the latest OpenSSL changes.
