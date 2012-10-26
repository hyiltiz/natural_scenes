#!/bin/bash
# @file create_dn_example_images.sh
# @brief create a denoising example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2012-10-26

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi
if [ "$2" = "" ]; then
	echo "no destination directory given"
	exit -1
fi
if [ "$3" = "" ]; then
	echo "no iso given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .nef)
img_dir=$2
iso=$3
# im can fail if too many threads try to execute
imopts="-limit thread 1"

noise_images=~/Data/nikond700db/denoising

# This code relies upon the original images already having been converted by
# the denoising code.
copy_original () {
	convert $imopts -crop 1024x768+1630+1038 $noise_images/$2.ppm $1/$2.original.ppm
	convert $imopts $1/$2.original.ppm $1/$2.original.png
}

bin=~/Projects/point_prediction/rcm/build/release
shbin=~/Projects/point_prediction/denoising/
lut=~/Projects/point_prediction/rcm

# This code relies upon the noisy images already having been created.  Make sure
# the noise they contain is the correct type of noise!
copy_noisy () {
	convert $imopts -crop 1024x768+1630+1038 $noise_images/$3.iso$1.ppm $2/$3.noisy.ppm
	convert $imopts $2/$3.noisy.ppm $2/$3.noisy.png
}

convert_thumb () {
	convert $imopts -contrast-stretch 2%x1% -resize 42x28 $1/$2.original.png $1/$2.thumb.png
	convert $imopts -contrast-stretch 2%x1% -resize 42x28 $1/$2.original.ppm $1/$2.thumb.ppm
}

convert_im () {
	convert $imopts $1/$2.noisy.png -adaptive-blur 2 $1/$2.im.png
	convert $imopts $1/$2.noisy.ppm -adaptive-blur 2 $1/$2.im.ppm
}

convert_rcm () {
	$bin/denoise $lut/denoise.iso$1.lut < $2/$3.noisy.ppm > $2/$3.rcm.ppm
	convert $imopts $2/$3.rcm.ppm $2/$3.rcm.png
}

pwd=`pwd`
convert_wiener () {
	cd $shbin
	./wiener2_denoise_yuv.sh $pwd/$1/$2.noisy.ppm $pwd/$1/$2.wiener.ppm
	cd $pwd
	convert $imopts $1/$2.wiener.ppm $1/$2.wiener.png
}

convert_cbm3d () {
	cd $shbin
	./cbm3d_denoise.sh $pwd/$1/$2.noisy.ppm 13.41 $pwd/$1/$2.cbm3d.ppm
	cd $pwd
	convert $imopts $1/$2.cbm3d.ppm $1/$2.cbm3d.png
}

copy_original $img_dir $img_bn
copy_noisy $iso $img_dir $img_bn
convert_thumb $img_dir $img_bn
convert_im $img_dir $img_bn
convert_rcm $iso $img_dir $img_bn
convert_wiener $img_dir $img_bn
convert_cbm3d $img_dir $img_bn
