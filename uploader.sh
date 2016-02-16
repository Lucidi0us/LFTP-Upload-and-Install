#!/bin/bash
source=$1
destination=$2
target=$4
uname=$5
pword=$6
installAfter=$5

case $1 in
?) #Help
	echo "Usage:"
	echo "advanced_uploader.sh SourceFile Destination [h|f host or input file] [IP Address | Input File] UserName PassWord [y|n run install after]"
	echo "Example: advance_uploader.sh /foo/bar.pkg /foo2/bar3/ h 192.168.0.2 root 1a2b3c4d y"
	;;
*) #Any other input
	case $3 in # Is input a file or single host IP?
		h) #Input is a single host
			echo "Adding SSH Key for $target"
			ssh -T -oStrictHostKeyChecking=no -oConnectTimeout=5 $uname@$target <<'EOF'
			date
EOF
		echo "Uploading $source to $target"
		lftp -u $uname,$pword sftp://$target << EOF
		put -O $destination $source
		quit >> uploader.log
EOF
		;;

	f)  #Input is a list of hosts in file
		while read host
		do
		echo "Adding SSH Key for $host"
		ssh -T -oStrictHostKeyChecking=no -oConnectTimeout=5 $uname@$host <<'EOF'
		date
EOF
		echo "Uploading $source to $host"
		lftp -u $uname,$pword sftp://$target << EOF 
		put -O $destination $source
		quit
EOF
		done < $target
		;;
	esac >> uploader.log
	
	case $5 in
	y) #run install command on uploaded file
	 	ssh -T -oStrictHostKeyChecking=no -oConnectTimeout=5 $uname@$target <<'EOF'
 		installer -pkg $destination -target /
EOF
	;;
 	*) #Any answer that is not y means no
 		echo "Installation not requested"
 	;;
 	esac
;;
esac
