#!/bin/bash
# @file create_example_pages.sh
# @brief create a super-resolution example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-28

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi

if [ "$2" = "" ]; then
	echo "no html filename given"
	exit -1
fi

if [ "$3" = "" ]; then
	echo "no destination directory given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .ppm)
html_fn=$2
img_dir=$3

make_link () {
	echo "<a href=\"$1\" title=\"Upsampling method comparison\"><img src=\"$2/$3.thumb.png\"></a>" >> $4
}

make_page () {
	echo "<!--#include virtual=\"../open_example.shtml\" -->" > $1
	echo "<img src=\"$2.input.png\">" >> $1
	echo "<br>" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

make_link $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn
make_page $img_dir/$img_bn.compare.shtml $img_bn
