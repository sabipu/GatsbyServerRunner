#!/bin/bash
echo "<strong>Strating Run Gatsby</strong>"
theuser=$1
if [ -z $theuser ]; then
        echo "No user specified!"
        exit 10
fi
if [ -f "/home/$theuser/gatsby_run_$theuser" ]; then
        echo "<strong>Another build is running - exiting</strong>"
        exit 10
fi
if [ ! -d /home/$theuser/gatsby ]; then
        echo "<strong>This isn't a gatsby build!</strong>"
fi

touch /home/$theuser/gatsby_run_$theuser

find /home/$theuser/gatsby ! -user $theuser  -o ! -group $theuser -exec chown $theuser:$theuser {} \;
#echo "<strong>Starting gatsby clean!</strong>"
#cd /home/$theuser/gatsby && gatsby clean | tee /tmp/gatsby_run_$theuser
echo "<strong>Starting Gatsby build!</strong>"
cd /home/$theuser/gatsby && gatsby build |  tee /home/$theuser/gatsby_run_$theuser
if  grep -q "ERROR" /home/$theuser/gatsby_run_$theuser; then
        echo "there was an error"
        mailx -s "An error occured with the gatsby build." shayne@dilate.com.au,bipu@dilate.com.au < /tmp/gatsby_run_$theuser
else
        echo "Syncing files between public and public_html folders ... "
        rsync -r -a --delete --exclude '.htaccess' /home/$theuser/gatsby/public/ /home/$theuser/public_html
        echo "done.<br>Updating owner on public_html ..."
        find /home/$theuser/public_html ! -user $theuser  -exec chown $theuser {} \;
        find /home/$theuser/public_html ! -group $theuser  -exec chgrp $theuser {} \;
        echo "done.<br>"
        echo "<strong>Gatsby build has completed</strong>"
        echo "Gatsby was run successfully for the user $theuser" | mailx -s "Gatsby was run successfully" shayne@dilate.com.au,bipu@dilate.com.au
fi
rm -rf /home/$theuser/gatsby_run_$theuser
rm -rf /tmp/gatsby_run_$theuser