#!/bin/zsh

#############################################################################################################
#                                      Created by Raf Vandelaer                                             #
#                                                                                                           #
#                 Script to install the third party tools in Intune.                                        #
#                  This script checks the version of the script and downloads                               #
#                  a newer version if available. Connfig as follows:                                        #
#                       Run script as signed-in user : No                                                   #
#                       Hide script notifications on devices : Yes                                          #
#                       Script frequency : Every week                                                       #
#                       Number of times to retry if script fails : 3                                        #
#                                                                                                           #
#                   Logs can be found in /var/log/intune                                                    #
#                                                                                                           #
#############################################################################################################


main() {
    #Main function of this script
    
    # Installs the latest release of dockutil from Github
    if [[ -f "/usr/local/bin/dockutil" ]]; then
		logging "Dockutil installed, checking version..."
        checkAppVersion "Dockutil" $dockutilRepo
	else 
        logging "Installing Dockutil"
	    installApp "Dockutil" $dockutilRepo
	fi
    # Installs the latest release of Desktoppr from Github
    if [[ -f "/usr/local/bin/desktoppr" ]]; then
		logging "Desktoppr installed, checking version..."
        checkAppVersion "Desktoppr" $desktopprRepo
	else 
        logging "Installing Desktoppr"
	    installApp "Desktoppr" $desktopprRepo
	fi
    # Installs the latest release of Installomator from Github
    if [ -f "/usr/local/Installomator/Installomator.sh" ]; then
		logging "installomator installed, checking version..."
        checkAppVersion "installomator" $installomatorRepo

	else 
        logging "Installing installomator"
	    installApp "Installomator" $installomatorRepo
	fi
}

#logging
logging () {
    fixdate="$(date +%d%m%Y-%H:%M)"
	echo $fixdate": " $1 | tee -a "$fixlog"
}
installApp(){
    APP=$1
    repo=$2

    # Download latest release PKG from Github
    curl -s $repo \
    | grep "https*.*pkg" | cut -d : -f 2,3 | tr -d \" \
    | xargs curl -SL --output /tmp/$APP.pkg
    
    # Install PKG to root volume
    installer -pkg /tmp/$APP.pkg -target /
    
    # Cleanup
    rm /tmp/$APP.pkg

}
#checking if app version is newer at github. If so -> Downloading and installing newer version
checkAppVersion(){
    APP=$1
    scriptURL=$2
    #checking old and new MD5 of file
    storedMD5=$(<"$dir/$APP.md5")
    newMD5=$(curl -sL $scriptURL |  grep '"tag_name":')
    if [[ "$storedMD5" == "$newMD5" ]]; then
        logging "Same file version on server for $APP, no need to do anything..."
        #if md5 are the same, no need to download again.
    else
        logging "OTHER file version on server for $APP, downloading..."
        #other md5 -> need to download newer script and change the stored MD5
        curl -sL $scriptURL |   grep '"tag_name":' > $dir/$APP.md5
        installApp $APP $scriptURL
    fi

}
#base vars
logFolder="/var/log/intune"
dir="/Users/Shared/Lab9Pro/md5check"
mkdir $dir
installomatorRepo="https://api.github.com/repos/Installomator/Installomator/releases/latest"
dockutilRepo="https://api.github.com/repos/kcrawford/dockutil/releases/latest"
desktopprRepo="https://api.github.com/repos/scriptingosx/desktoppr/releases/latest"

[[ -d $logFolder ]] || mkdir $logFolder
chmod 755 $logFolder
fixlog=$logFolder"/intune-fundamentals-install.log"
touch $fixlog
readonly fixlog
main;