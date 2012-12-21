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
	echo "no sigma given"
	exit -1
fi
if [ "$4" = "" ]; then
	echo "no source directory given"
	exit -1
fi
if [ "$5" = "" ]; then
	echo "no original extension given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .nef)
img_dir=$2
sigma=$3
noise_images=$4
orig_ext=$5
# im can fail if too many threads try to execute
imopts="-limit thread 1"

# This code relies upon the original images already having been converted by
# the denoising code.
copy_original () {

	if [ "$2" = "cps201009163510" ]
	then
		convert $imopts -crop 1024x768+2000+600 $noise_images/$2.$orig_ext $1/$2.original.ppm
	elif [ "$2" = "cps201104154614" ]
	then
		convert $imopts -crop 1024x768+600+1100 $noise_images/$2.$orig_ext $1/$2.original.ppm
	elif [ "$2" = "cps201104154611" ]
	then
		convert $imopts -crop 1024x768+2200+800 $noise_images/$2.$orig_ext $1/$2.original.ppm
	else
		convert $imopts -crop 1024x768+1630+1038 $noise_images/$2.$orig_ext $1/$2.original.ppm
	fi
	convert $imopts $1/$2.original.ppm $1/$2.original.png
}

bin=~/Projects/point_prediction/denoising/build/release
shbin=~/Projects/point_prediction/denoising/
lut=~/Projects/point_prediction/denoising

# This code relies upon the noisy images already having been created.  Make sure
# the noise they contain is the correct type of noise!
copy_noisy () {
	if [ "$3" = "cps201009163510" ]
	then
		convert $imopts -crop 1024x768+2000+600 $noise_images/$3.sigma$1.ppm $2/$3.noisy.ppm
	elif [ "$3" = "cps201104154614" ]
	then
		convert $imopts -crop 1024x768+600+1100 $noise_images/$3.sigma$1.ppm $2/$3.noisy.ppm
	elif [ "$3" = "cps201104154611" ]
	then
		convert $imopts -crop 1024x768+2200+800 $noise_images/$3.sigma$1.ppm $2/$3.noisy.ppm
	else
		convert $imopts -crop 1024x768+1630+1038 $noise_images/$3.sigma$1.ppm $2/$3.noisy.ppm
	fi
	convert $imopts $2/$3.noisy.ppm $2/$3.noisy.png
}

convert_thumb () {
	convert $imopts -resize 42x28 $1/$2.original.png $1/$2.thumb.png
	convert $imopts -resize 42x28 $1/$2.original.ppm $1/$2.thumb.ppm
}

convert_im () {
	convert $imopts $1/$2.noisy.png -adaptive-blur 2 $1/$2.im.png
	convert $imopts $1/$2.noisy.ppm -adaptive-blur 2 $1/$2.im.ppm
}

convert_rcm () {
	$bin/bpyuv $lut/yuv.sigma$1.lut < $2/$3.noisy.ppm > $2/$3.rcm.ppm
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
	./cbm3d_denoise.sh $pwd/$2/$3.noisy.ppm $1 $pwd/$2/$3.cbm3d.ppm
	cd $pwd
	convert $imopts $2/$3.cbm3d.ppm $2/$3.cbm3d.png
}

copy_original $img_dir $img_bn
copy_noisy $sigma $img_dir $img_bn
convert_thumb $img_dir $img_bn
convert_im $img_dir $img_bn
convert_rcm $sigma $img_dir $img_bn
convert_wiener $img_dir $img_bn
convert_cbm3d $sigma $img_dir $img_bn
