#!/bin/bash
# @file create_example_stats.sh
# @brief create super-resolution stats for each example image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-10-01

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi
if [ "$2" = "" ]; then
	echo "no destination directory given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .ppm)
img_dir=$2

bin=~/projects/point_prediction

output () {
	echo "<ul>" > $1
	echo "<li>" >> $1
	echo "input: `identify $2 | cut -f3 -d' '`" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "output: `identify $3 | cut -f3 -d' '`" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "mse: $4" >> $1
	echo "</li>" >> $1
	echo "</ul>" >> $1
}

output $2/$img_bn.input.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm "---"
output $2/$img_bn.biprior.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm  `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.biprior.ppm`
output $2/$img_bn.bilinear.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.bilinear.ppm`
output $2/$img_bn.spline.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm   `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.spline.ppm`
output $2/$img_bn.bicubic.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm  `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.bicubic.ppm`
output $2/$img_bn.lanczos.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm  `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.lanczos.ppm`
output $2/$img_bn.pr7.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.original.ppm      `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.pr7.ppm`
