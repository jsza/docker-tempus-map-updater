#!/bin/bash
umask 022
cd /srv/tempus_maps/

SERVERURL="http://tempus.site.nfoservers.com/server/maps/"

if [ -f index.html ]
then
        rm index.html
fi

if [ -n "$1" ]
then
        SERVERURL="$1"
        if [[ "$SERVERURL" != */ ]]
        then
                SERVERURL+='/'
        fi
fi

wget --no-remove-listing "${SERVERURL}"
if [ -f allmaps.txt ]
then
        rm allmaps.txt
fi
awk 'BEGIN{ RS="<a *href *= *\""} NR>2 {sub(/".*/,"");print; }' index.html >> converted.txt
grep '.bsp' converted.txt | awk -F".bz2" '{print $1}' >> allmaps.txt
for line in $(cat allmaps.txt)
do
        if [ ! -f $line ]
        then
                echo "Unable to find $line. Downloading..."
                wget "${SERVERURL}"$line.bz2
        fi
done

default="/srv/default_level_sounds.txt"
for file in *.bsp
do
        map="${file%.*}_level_sounds.txt"
        cp -f $default $map
done

for file2 in *level_sounds.txt
do
        text="${file2%_level_sounds.txt}.bsp"
        if [ ! -f $text ]
        then
        if [ "$file2" != "default_level_sounds.txt" ]
        then
                echo "Can't find $text, removing $file2"
                rm $file2
        fi
        fi
done

rm converted.txt
rm index.html

touch tempus_map_updater_run_once
