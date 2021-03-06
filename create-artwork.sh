#!/bin/sh

#rm -rf artwork
mkdir -p artwork

NAME=`cat config.txt | grep "name=" | sed 's/name=//'`
TITLE_OVERLAY=`cat config.txt | grep "TITLE_OVERLAY=" | sed 's/TITLE_OVERLAY=//'`

# OVERLAY
if test "x${TITLE_OVERLAY}" = "x1";
then
	convert -size 1280x720 xc:transparent \
		-gravity SouthEast -stroke black -fill white -font "FreeSans-Medium" -pointsize 32 \
		-annotate +10+10 "$NAME" \
		artwork/overlay.png
fi

# TITLE
convert -size 1280x720 xc:black \
	-gravity south -stroke white -fill white -font "FreeSans-Medium" -pointsize 72 \
	-annotate +0+30 "$NAME" \
	/tmp/title-temp.jpg

convert -resize 750x500 config/title-image.jpg \
	/tmp/title-image-temp.jpg

composite -compose blend /tmp/title-image-temp.jpg \
	-gravity center -geometry +0-50 /tmp/title-temp.jpg \
	artwork/title.jpg

cd artwork
for i in `seq 100 199`; do ln -s title.jpg title$i.jpg; done
cd ..

# END
convert -background black \
	-gravity center -stroke white -fill white -font "FreeSans-Medium" -pointsize 72 \
	-size 600x caption:"$NAME" /tmp/label.jpg

convert -size 1280x720  xc:black /tmp/temp-end.jpg

composite -size 1280x270 -compose blend /tmp/label.jpg \
	-gravity east -geometry +80-50 /tmp/temp-end.jpg \
	/tmp/temp-end.jpg

composite -size 1280x270 -compose blend osm-logo.png \
	-gravity west -geometry +70-50 /tmp/temp-end.jpg \
	/tmp/temp-end.jpg

convert /tmp/temp-end.jpg \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Bold" -pointsize 28 -annotate +20+80 "data:" \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Bold" -pointsize 28 -annotate +20+50 "visuals:" \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Bold" -pointsize 28 -annotate +20+20 "music:" \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Medium" -pointsize 28 -annotate +170+80 "OpenStreetMap (http://openstreetmap.org) and contributors (ODbL)" \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Medium" -pointsize 28 -annotate +170+50 "Derick Rethans (http://derickrethans.nl) (cc-by-sa)" \
	-gravity southwest -stroke none -fill white -font "FreeSerif-Medium" -pointsize 28 -annotate +170+20 "Artifact - Kevin MacLeod (incompetech.com) (cc-by 3.0)" \
	artwork/end.jpg

cd artwork
for i in `seq 100 199`; do ln -s end.jpg end$i.jpg; done
cd ..
