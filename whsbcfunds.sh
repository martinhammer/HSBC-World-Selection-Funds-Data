#!/bin/bash

# path where files will be downloaded to
WDOWNLOAD_PATH="/home/martin/bin/downloads"
# path for publishing the file to web
WWEB_PATH="/usr/share/mini-httpd/www"
# human-readable timestamp
WDATETIME=`date +"%Y%m%d%H%M%S"`

# download the file and store it with today's date
wget -a $WDOWNLOAD_PATH/fund.log -O $WDOWNLOAD_PATH/fund.js.$WDATETIME https://www.hsbcoffshoreinteractive.com/dailyupdates/fund.js 

# retrieve the file we want and append it to history file
grep HWS3U $WDOWNLOAD_PATH/fund.js.$WDATETIME | sed s/"var HWS3U = new Array("// | sed s/");"// >> $WDOWNLOAD_PATH/HWS3U.hist
grep HWS4U $WDOWNLOAD_PATH/fund.js.$WDATETIME | sed s/"var HWS4U = new Array("// | sed s/");"// >> $WDOWNLOAD_PATH/HWS4U.hist
grep HWS5U $WDOWNLOAD_PATH/fund.js.$WDATETIME | sed s/"var HWS5U = new Array("// | sed s/");"// >> $WDOWNLOAD_PATH/HWS5U.hist

# start javascript file
echo "var data = [" > $WDOWNLOAD_PATH/HWS3U.js
echo "var data = [" > $WDOWNLOAD_PATH/HWS4U.js
echo "var data = [" > $WDOWNLOAD_PATH/HWS5U.js

# transform the history file to javascript format
uniq $WDOWNLOAD_PATH/HWS3U.hist | cut -d "," -f 5,6,9 | sed s/[[:space:]\"]//g | sed -e 's/\([0-9]*\.[0-9]*\),\([0-9]*\.[0-9]*\),\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)/,\{x:new Date\(20\5,\4-1,\3\),bid:\1,offer:\2\}/g' >> $WDOWNLOAD_PATH/HWS3U.js
uniq $WDOWNLOAD_PATH/HWS4U.hist | cut -d "," -f 5,6,9 | sed s/[[:space:]\"]//g | sed -e 's/\([0-9]*\.[0-9]*\),\([0-9]*\.[0-9]*\),\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)/,\{x:new Date\(20\5,\4-1,\3\),bid:\1,offer:\2\}/g' >> $WDOWNLOAD_PATH/HWS4U.js
uniq $WDOWNLOAD_PATH/HWS5U.hist | cut -d "," -f 5,6,9 | sed s/[[:space:]\"]//g | sed -e 's/\([0-9]*\.[0-9]*\),\([0-9]*\.[0-9]*\),\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{2\}\)/,\{x:new Date\(20\5,\4-1,\3\),bid:\1,offer:\2\}/g' >> $WDOWNLOAD_PATH/HWS5U.js

# remove the first comma from javascript file
sed -i "2s/^,/ /" $WDOWNLOAD_PATH/HWS3U.js
sed -i "2s/^,/ /" $WDOWNLOAD_PATH/HWS4U.js
sed -i "2s/^,/ /" $WDOWNLOAD_PATH/HWS5U.js

# closing the javascript stuff
echo "];" >> $WDOWNLOAD_PATH/HWS3U.js
echo "];" >> $WDOWNLOAD_PATH/HWS4U.js
echo "];" >> $WDOWNLOAD_PATH/HWS5U.js

# copy the javascript file to www folder
cp $WDOWNLOAD_PATH/HWS3U.js $WWEB_PATH
cp $WDOWNLOAD_PATH/HWS4U.js $WWEB_PATH
cp $WDOWNLOAD_PATH/HWS5U.js $WWEB_PATH

