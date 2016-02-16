# LFTP-Upload-and-Install

LFTP script I created to be called by other scripts.  It was created to distribute files to large numbers of iMacs on a private network.
The install option only works with pkg files on os x.
This works best when used with SSH using shared keys.
Requires lftp

Examples of usage:


`uploader.sh /my/source/file.pkg /the/destination/file.pkg h 192.168.0.1 jdoe JohnsPass y`

Will upload the file.pkg to 192.168.0.1, username jdow, password JohnsPass, and install when completed.
    
If the 3rd flag is f, then it will expect the 4th flag to be the path to a text file containing one IP address per line.
I generate this using the following command to pull all active IP addresses for my network:

`sudo nmap -n -sn 192.168.0.1/23 -oG - | awk '/Up$/{print $2}' > host_ips.txt`

then the usage for this script would look like this

`uploader.sh /my/source/file.pkg /the/destination/file.pkg f /my/source/host_ips.txt jdoe JohnsPass y`

The 7th argument will only trigger 'installer -pkg $destination -target /' if the value is 'y'.  All other values are treated as 'no'
