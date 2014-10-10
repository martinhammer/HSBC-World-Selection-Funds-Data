#!/bin/bash


# path where files will be downloaded to
WDOWNLOAD_PATH="/home/martin/bin/downloads"
# today's date as yyyy-mm-dd
DATE=`date +"%F"`
# download the file and store it with today's date
wget -a $WDOWNLOAD_PATH/fund.log -O $WDOWNLOAD_PATH/fund.js.$DATE https://www.hsbcoffshoreinteractive.com/dailyupdates/fund.js 
# retrieve the file we want and append it to history file
grep HWS4U $WDOWNLOAD_PATH/fund.js.$DATE | sed s/"var HWS4U = new Array("// | sed s/");"// >> $WDOWNLOAD_PATH/HWS4U.hist
# start javascript file
echo "var data = [" > $WDOWNLOAD_PATH/HWS4U.js
# transform the history file to javascript format
uniq $WDOWNLOAD_PATH/HWS4U.hist | cut -d "," -f 5,6,9 | sed s/[[:space:]\"]//g | sed -e 's/\([0-9]*\.[0-9]*\),\([0-9]*\.[0-9]*\),\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)/,\{x:new Date\(20\5,\4-1,\3\),bid:\1,offer:\2\}/g' >> $WDOWNLOAD_PATH/HWS4U.js
# remove the first comma from javascript file
sed -i "2s/^,/ /" $WDOWNLOAD_PATH/HWS4U.js
# closing the javascript stuff
echo "];" >> $WDOWNLOAD_PATH/HWS4U.js

