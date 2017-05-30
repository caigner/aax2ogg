#!/bin/bash

# Convert aax to oog

FFMPEG=/usr/bin/ffmpeg
FFPROBE=/usr/bin/ffprobe
ACTIVATION_BYTES="a74be906"


function convert {
  
	TITLE=`$FFPROBE -show_format "$1" 2>/dev/null | grep TAG:title | cut -d '=' -f 2 | sed 's/:/ -/g'`
	ARTIST=`$FFPROBE -show_format "$1" 2>/dev/null | grep TAG:artist | cut -d '=' -f 2`
	
	if [[ ! -d "$ARTIST" ]]; then
		mkdir "$ARTIST"
	fi
	
	# skip convertion if file already exists
    if [[ ! -e "$ARTIST/$TITLE.ogg" ]]; then
		echo "Converting $TITLE ..."
		time $FFMPEG -v error -stats -activation_bytes $ACTIVATION_BYTES -i "$1" -vn -qscale:a 4 "$ARTIST/$TITLE".ogg -n
	else
		echo "File already exists!"
	fi	
}

if [[ -z "$1" ]]; then
	# kein Parameter, daher werden alle AAX-Dateien in MP4 umgewandelt
	for f in `find -type f -iname "*.aax"`
	do
		convert "$f"
	done
else
	# eine Datei wurde angegeben, und die wird jetzt umgewandelt
	convert "$1"
fi
