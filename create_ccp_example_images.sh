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
echo "dcraw -6 -q 3 -o 1 -v -c $img_fn > $2/$img_bn.original.ppm"
dcraw -c $img_fn > $2/$img_bn.original.ppm

# crop and convert to png
# im can fail if too many threads try to execute
imopts="-limit thread 1"
convert $imopts -crop 1024x768+1630+1038 $2/$img_bn.original.ppm $2/$img_bn.cropped.ppm
convert $imopts $2/$img_bn.cropped.ppm $2/$img_bn.cropped.png

# convert to a thumbnail
convert $imopts -resize 42x28 $2/$img_bn.cropped.png $2/$img_bn.thumb.png

# create image with R,G,B channels missing
convert $imopts $2/$img_bn.cropped.ppm -channel R -fx 0 $2/$img_bn.gb.ppm
convert $imopts $2/$img_bn.cropped.png -channel R -fx 0 $2/$img_bn.gb.png
convert $imopts $2/$img_bn.cropped.ppm -channel G -fx 0 $2/$img_bn.rb.ppm
convert $imopts $2/$img_bn.cropped.png -channel G -fx 0 $2/$img_bn.rb.png
convert $imopts $2/$img_bn.cropped.ppm -channel B -fx 0 $2/$img_bn.rg.ppm
convert $imopts $2/$img_bn.cropped.png -channel B -fx 0 $2/$img_bn.rg.png

bin=~/Projects/point_prediction/color_prediction
$bin/reconstruct 0 $bin/red.lut < $2/$img_bn.gb.ppm > $2/$img_bn.rcm.gb.ppm
$bin/reconstruct 1 $bin/green.lut < $2/$img_bn.rb.ppm > $2/$img_bn.rcm.rb.ppm
$bin/reconstruct 2 $bin/blue.lut < $2/$img_bn.rg.ppm > $2/$img_bn.rcm.rg.ppm

convert $imopts $2/$img_bn.rcm.gb.ppm $2/$img_bn.rcm.gb.png
convert $imopts $2/$img_bn.rcm.rb.ppm $2/$img_bn.rcm.rb.png
convert $imopts $2/$img_bn.rcm.rg.ppm $2/$img_bn.rcm.rg.png

$bin/mlr 0   8.320029 0.965737 0.065177  < $2/$img_bn.gb.ppm > $2/$img_bn.mlr.gb.ppm
$bin/mlr 1   7.436007 0.161544 0.766225  < $2/$img_bn.rb.ppm > $2/$img_bn.mlr.rb.ppm
$bin/mlr 2 -22.862778 0.181187 0.566007  < $2/$img_bn.rg.ppm > $2/$img_bn.mlr.rg.ppm

convert $imopts $2/$img_bn.mlr.gb.ppm $2/$img_bn.mlr.gb.png
convert $imopts $2/$img_bn.mlr.rg.ppm $2/$img_bn.mlr.rg.png
convert $imopts $2/$img_bn.mlr.rb.ppm $2/$img_bn.mlr.rb.png

exit 0
