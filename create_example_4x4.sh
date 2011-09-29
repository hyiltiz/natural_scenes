#!/bin/bash
# @file create_example.sh
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
img_bn=$(basename $img_fn .ppm)
html_fn=$2
img_dir=$3
img_html_fn=$img_dir/$img_bn.input.shtml

echo "filename: $img_fn"
echo "basename: $img_bn"
echo "html filename: $html_fn"
echo "image directory: $img_dir"
echo "image html filename: $img_html_fn"

convert -gamma 2.2 -resize 400% -filter point $img_fn $img_dir/$img_bn.input.png
convert -resize 42x28 $img_dir/$img_bn.input.png $img_dir/$img_bn.input.thumb.png
cp style.css $img_dir

echo "<a href=\"$img_html_fn\"><img src=\"$img_dir/$img_bn.input.thumb.png\"></a>" >> $html_fn
echo "<br>" >> $html_fn

echo "<!--#include virtual=\"../open_example.shtml\" -->" > $img_html_fn
echo "<img src=\"$img_bn.input.png\">" >> $img_html_fn
echo "<br>" >> $img_html_fn
echo "Input" >> $img_html_fn
echo "<!--#include virtual=\"../close.shtml\" -->" >> $img_html_fn
