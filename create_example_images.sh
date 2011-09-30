#!/bin/bash
# @file create_example_images.sh
# @brief create a super-resolution example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-28

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi
if [ "$2" = "" ]; then
	echo "no destination directory given"
	exit -1
fi
if [ "$3" = "" ]; then
	echo "no scale given"
	exit -1
fi


img_fn=$1
img_bn=$(basename $1 .ppm)
img_dir=$2
scale=$3

convert_input () {
	convert -gamma 2.2 -resize $400% -filter point $1 $2/$3.input.png
}

convert_biprior () {
	convert -gamma 2.2 -resize $400% -filter point $1 $2/$3.biprior.png
}

convert_bilinear () {
	convert -gamma 2.2 -resize $400% -filter point $1 $2/$3.bilinear.png
}

convert_spline () {
	convert -gamma 2.2 -resize $400% -filter point $1 $2/$3.spline.png
}

convert_bicubic () {
	convert -gamma 2.2 -resize $400% -filter point $1 $2/$3.bicubic.png
}

convert_thumb () {
	convert -gamma 2.2 -resize 42x28 $1 $2/$3.thumb.png
}

convert_input $img_fn $img_dir $img_bn $scale
convert_biprior $img_fn $img_dir $img_bn $scale
convert_bilinear $img_fn $img_dir $img_bn $scale
convert_spline $img_fn $img_dir $img_bn $scale
convert_bicubic $img_fn $img_dir $img_bn $scale
convert_thumb $img_fn $img_dir $img_bn
