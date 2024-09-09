#!/bin/bash




#############################################################################################################
#                                      Created by Raf Vandelaer                                             #
#                                                                                                           #
#                                                                                                           #
#                                                                                                           #
#                This script checks if the user has OneDrive configured.									#
#                 If so and OneDrive isn't running, it will start it.                               		#
#                  This version to use WITH MDM										                        #
#																											#
#                   Logs can be found in /var/log/onedrive-kickstart                                        #
#                                                                                                           #
#############################################################################################################
# Tweaked from: https://github.com/soundsnw/mac-sysadmin-resources/blob/master/extension-attributes/onedrive-syncfailures.sh

########################################### Parameters to modify #########################################################

		#for example "/Users/johndoe/OneDrive - mycompany" 
		oneDriveFolder="/Users/johndoe/OneDrive - Company"

	#DO NOT FORGET to do the following:

		#Save the script in a good location
		#open crontab and create a new task every 15 minutes: */15 * * * *
		#Create the log folder and give read/write permissions to everyone.
	

########################################### Parameters to modify /end #########################################################
fixlog="/private/var/log/onedrive-kickstart/onedrive-kickstart.log"
readonly fixlog

logging () {
	echo $fixdate": " $1 | tee -a "$fixlog"
}

#Create log
fixdate="$(date +%d%m%Y-%H:%M)"

[[ -d "/private/var/log/onedrive-kickstart" ]] || mkdir "/private/var/log/onedrive-kickstart"



# Check if the OneDrive folder is present

if [ -d "$oneDriveFolder" ]; then
    logging "User has configured OneDrive."
else
	logging "User hasn't set up OneDrive, aborting."
	exit 1;
fi

# Check if OneDrive is running

if [[ ! $(/usr/bin/pgrep -x "OneDrive") ]]; then
	logging "OneDrive is inactive, restarting client."
	open "/Applications/OneDrive.app"
else
         logging "OneDrive is already running."
fi


exit 0
