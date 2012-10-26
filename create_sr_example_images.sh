#!/bin/bash
# @file create_sr_example_images.sh
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
	convert -gamma 2.2 $1 $2/$3.original.ppm
}

convert_downsampled () {
	case $1 in
	2)
	convert -resize 50% -filter gaussian -define filter:support=1.5 -define filter:sigma=0.85 $2/$3.original.png $2/$3.downsampled.png
	convert -resize 50% -filter gaussian -define filter:support=1.5 -define filter:sigma=0.85 $2/$3.original.ppm $2/$3.downsampled.ppm
	;;
	4)
	convert -resize 25% -filter gaussian -define filter:support=3.5 -define filter:sigma=1.7 $2/$3.original.png $2/$3.downsampled.png
	convert -resize 25% -filter gaussian -define filter:support=3.5 -define filter:sigma=1.7 $2/$3.original.ppm $2/$3.downsampled.ppm
	;;
	*)
	echo "unknown scale"
	exit -1
	esac
}

bin=~/Projects/point_prediction

convert_downsampled_odd () {
	case $1 in
	2)
	$bin/gaussian_blur 3 0.85 2 < $2/$3.original.ppm > $2/$3.downsampled.odd.ppm
	convert $2/$3.downsampled.odd.ppm $2/$3.downsampled.odd.png
	;;
	4)
	tmp=`mktemp`
	$bin/gaussian_blur 3 0.85 2 < $2/$3.original.ppm > $tmp
	$bin/gaussian_blur 3 0.85 2 < $tmp > $2/$3.downsampled.odd.ppm
	convert $2/$3.downsampled.odd.ppm $2/$3.downsampled.odd.png
	;;
	*)
	echo "unknown scale"
	exit -1
	;;
	esac
}

convert_input () {
	convert -resize $1% -filter point $2/$3.downsampled.png $2/$3.input.png
	convert -resize $1% -filter point $2/$3.downsampled.ppm $2/$3.input.ppm
}

bin2=~/Projects/point_prediction/super_resolution

convert_biprior () {
	case $1 in
	2)
	$bin2/upsample2x2yuv $bin2/2x2yuv.lut < $2/$3.downsampled.odd.ppm > $2/$3.biprior.ppm
	convert $2/$3.biprior.ppm $2/$3.biprior.png
	;;
	4)
	tmp=`mktemp`
	$bin2/upsample2x2yuv $bin2/2x2yuv.lut < $2/$3.downsampled.odd.ppm > $tmp
	$bin2/upsample2x2yuv $bin2/2x2yuv.lut < $tmp > $2/$3.biprior.ppm
	convert $2/$3.biprior.ppm $2/$3.biprior.png
	;;
	*)
	echo "unknown scale"
	exit -1
	;;
	esac
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

convert_thumb () {
	convert -resize 42x28 $1/$2.original.png $1/$2.thumb.png
	convert -resize 42x28 $1/$2.original.ppm $1/$2.thumb.ppm
}

convert_original $img_fn $img_dir $img_bn
convert_downsampled $scale $img_dir $img_bn
convert_downsampled_odd $scale $img_dir $img_bn
convert_input $((100*$scale)) $img_dir $img_bn
convert_biprior $scale $img_dir $img_bn
convert_bilinear $((100*$scale)) $img_dir $img_bn
convert_spline $((100*$scale)) $img_dir $img_bn
convert_bicubic $((100*$scale)) $img_dir $img_bn
convert_lanczos $((100*$scale)) $img_dir $img_bn
convert_thumb $img_dir $img_bn
