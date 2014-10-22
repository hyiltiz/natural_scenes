#!/bin/bash
# @file create_ccp_example_images.sh
# @brief create a color channel prediction example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2014-10-15

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi
if [ "$2" = "" ]; then
	echo "no destination directory given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .nef)
img_dir=$2

# convert from nef to ppm and label with 'original'
echo "dcraw -c $img_fn > $2/$img_bn.original.ppm"
dcraw -c $img_fn > $2/$img_bn.original.ppm

# crop and convert to png
# im can fail if too many threads try to execute
imopts="-limit thread 1"
convert $imopts -crop 1024x768+1630+1038 $2/$img_bn.original.ppm $2/$img_bn.original.cropped.ppm
convert $imopts $2/$img_bn.original.cropped.ppm $2/$img_bn.original.cropped.png

# convert to a thumbnail
convert $imopts -resize 42x28 $2/$img_bn.original.cropped.png $2/$img_bn.cropped.thumb.png

# create image with R,G,B channels missing
convert $imopts $2/$img_bn.original.cropped.ppm -channel R -fx 0 $2/$img_bn.original.cropped.bg.ppm
convert $imopts $2/$img_bn.original.cropped.png -channel R -fx 0 $2/$img_bn.original.cropped.bg.png
convert $imopts $2/$img_bn.original.cropped.ppm -channel G -fx 0 $2/$img_bn.original.cropped.br.ppm
convert $imopts $2/$img_bn.original.cropped.png -channel G -fx 0 $2/$img_bn.original.cropped.br.png
convert $imopts $2/$img_bn.original.cropped.ppm -channel B -fx 0 $2/$img_bn.original.cropped.rg.ppm
convert $imopts $2/$img_bn.original.cropped.png -channel B -fx 0 $2/$img_bn.original.cropped.rg.png

# create image with R channel restored using OPP
# create image with R channel restored using linear estimate
