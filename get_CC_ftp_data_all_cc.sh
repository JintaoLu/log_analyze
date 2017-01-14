#!/bin/bash
#This shell is used to download CC's Lulog file on ftp.
cd `dirname $0`
FATHERPATH=/Android_CC2/Rtv_Engine/normal
DATE=$(date +%Y%m%d)_cc
mkdir -p ${DATE}
HOMEPATHNEW=$(pwd)/${DATE}
lftp huangxw:Huangxw2013@113.106.204.11:61721 << EOF
cd ${FATHERPATH}
lcd ${HOMEPATHNEW}
mirror -c 
bye
EOF
