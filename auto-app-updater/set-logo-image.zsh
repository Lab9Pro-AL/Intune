#!/bin/zsh

#############################################################################################################
#                                      Created by Raf Vandelaer                                             #
#                                                                                                           #
#                   Script to deploy icns for app-updater with base64                                       #
#                       Run script as signed-in user : No                                                   #
#                       Hide script notifications on devices : Yes                                          #
#                       Script frequency : Not configured                                                   #
#                       Number of times to retry if script fails : 3                                        #
#                                                                                                           #
#                                                                                                           #
#############################################################################################################

logo=""

path="/Users/Shared/company-logo.icns"

echo $logo | /usr/bin/base64 --decode > $path

#check if file is in place, exit 0
if [ -f "$path" ]; then
    exit 0
else 
    exit 1
fi


#/usr/bin/openssl base64 -in $logo -out $path