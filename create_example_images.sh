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

convert_original () {
	convert -gamma 2.2 $1 $2/$3.original.png
	convert -gamma 1.0 $1 $2/$3.original.ppm
}

convert_downsampled () {
	convert -resize $1% -filter gaussian -define filter:support=1.5 -define filter:sigma=0.85 $2/$3.original.png $2/$3.downsampled.png
	convert -resize $1% -filter gaussian -define filter:support=1.5 -define filter:sigma=0.85 $2/$3.original.ppm $2/$3.downsampled.ppm
}

convert_input () {
	convert -resize $1% -filter point $2/$3.downsampled.png $2/$3.input.png
	convert -resize $1% -filter point $2/$3.downsampled.ppm $2/$3.input.ppm
}

convert_biprior () {
	convert -resize $1% -filter point $2/$3.downsampled.png $2/$3.biprior.png
	convert -resize $1% -filter point $2/$3.downsampled.ppm $2/$3.biprior.ppm
}

convert_bilinear () {
	convert -resize $1% -filter triangle $2/$3.downsampled.png $2/$3.bilinear.png
	convert -resize $1% -filter triangle $2/$3.downsampled.ppm $2/$3.bilinear.ppm
}

convert_spline () {
	convert -resize $1% -filter cubic $2/$3.downsampled.png $2/$3.spline.png
	convert -resize $1% -filter cubic $2/$3.downsampled.ppm $2/$3.spline.ppm
}

convert_bicubic () {
	convert -resize $1% -filter lagrange $2/$3.downsampled.png $2/$3.bicubic.png
	convert -resize $1% -filter lagrange $2/$3.downsampled.ppm $2/$3.bicubic.ppm
}

convert_lanczos () {
	convert -resize $1% -filter lanczos $2/$3.downsampled.png $2/$3.lanczos.png
	convert -resize $1% -filter lanczos $2/$3.downsampled.ppm $2/$3.lanczos.ppm
}

convert_pr7 () {
	convert -resize $1% -filter point $2/$3.downsampled.png $2/$3.pr7.png
	convert -resize $1% -filter point $2/$3.downsampled.ppm $2/$3.pr7.ppm
}

convert_thumb () {
	convert -resize 42x28 $1/$2.original.png $1/$2.thumb.png
	convert -resize 42x28 $1/$2.original.ppm $1/$2.thumb.ppm
}

convert_original $img_fn $img_dir $img_bn
convert_downsampled $((100/$scale)) $img_dir $img_bn
convert_input $((100*$scale)) $img_dir $img_bn
convert_biprior $((100*$scale)) $img_dir $img_bn
convert_bilinear $((100*$scale)) $img_dir $img_bn
convert_spline $((100*$scale)) $img_dir $img_bn
convert_bicubic $((100*$scale)) $img_dir $img_bn
convert_lanczos $((100*$scale)) $img_dir $img_bn
convert_pr7 $((100*$scale)) $img_dir $img_bn
convert_thumb $img_dir $img_bn
