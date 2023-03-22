## Add/Replace Cloudflare Subdomain Using Listed IPs

This script is a Bash script designed to modify Cloudflare DNS records for a particular subdomain. It reads Cloudflare credentials and A record modification details from the user, and then it deletes existing A records for the specified subdomain and adds new A records based on a list of IP addresses provided in a CSV file.

The script sets default values for the Cloudflare credentials and A record modification details, which can be overridden by user input. It also looks for a configuration file in the current directory, and loads any values from it if it exists.

The script uses the Cloudflare API to retrieve existing A records for the subdomain, delete them, and add new A records for each IP address listed in the CSV file.

Finally, the script saves the user input as default values in the configuration file.

To run the script, you need to have the following:

- A Cloudflare account with the API key, zone ID, and email address associated with it.
- A CSV file containing the list of new IP addresses for the subdomain.
- The script saved in a file with the ".sh" extension.
- The script file needs to be executable using the command "chmod +x cf-replace-ips.sh".

### MacOSX/Linux
To run the script in MacOSX/Linux terminal, download and unzip the script folder to your home directory, then go to the related folder, then do the following:
```
cd ~/cf-replace-ips
bash ./cf-replace-ips.sh
```

### Windows
For Windows, you need to install some package to run bash scripts, I recommend to install proper [Cygwin](https://www.cygwin.com) based on your windows version.
To run the script in Cygwin, download the script and copy the script folder to your home directory in Cygwin (Usually placed in `C:\Cygwin\home\yourname`), then execute Cygwin and do following steps:
```
cd ~/cf-replace-ips
bash ./cf-replace-ips.sh
```

When executed, the script will prompt the user for the Cloudflare credentials and A record modification details. If any default values are set, they will be displayed as prompts for the user.

The script should be used with caution, as it can modify DNS records for a subdomain, potentially affecting website availability. It's recommended to test it in a non-production environment first.
