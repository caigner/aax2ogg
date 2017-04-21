#!/bin/bash

# Convert aax to oog
#
# This script converts aax-files to ogg-files.
#
# Parameter: <none> ... convert all aax-files in current directory
# Parameter: <filename.aax> ... convert only filename.aax 

FFMPEG=/usr/bin/ffmpeg
FFPROBE=/usr/bin/ffprobe

# next add your own activation-code 
# You can extract it with the followin tool: https://github.com/inAudible-NG/audible-activator
ACTIVATION_BYTES="xxxxxxxx"


function convert {
    # extract some meta data from the input file 
	TITLE=`$FFPROBE -show_format "$1" 2>/dev/null | grep TAG:title | cut -d '=' -f 2 | sed 's/:/ -/g'`
	ARTIST=`$FFPROBE -show_format "$1" 2>/dev/null | grep TAG:artist | cut -d '=' -f 2`
	
	if [[ ! -d "$ARTIST" ]]; then
		mkdir "$ARTIST"
	fi
	
	echo "Converting $TITLE ..."
	
	time $FFMPEG -v error -stats -activation_bytes $ACTIVATION_BYTES -i "$1" -vn -qscale:a 4 "$ARTIST/$TITLE".ogg -n
}

if [[ -z "$1" ]]; then
	# if there is no parameter then convert all aax-files
	for f in `find -type f -iname "*.aax"`
	do
		convert "$f"
	done
else
	# only convert one file
	convert "$1"
fi
