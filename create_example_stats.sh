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

echo "$img_fn input stats" > $2/$img_bn.input.stats.shtml
echo "$img_fn biprior stats" > $2/$img_bn.biprior.stats.shtml
echo "$img_fn bilinear stats" > $2/$img_bn.bilinear.stats.shtml
echo "$img_fn spline stats" > $2/$img_bn.spline.stats.shtml
echo "$img_fn bicubic stats" > $2/$img_bn.bicubic.stats.shtml
echo "$img_fn perfect resize 7.0 stats" > $2/$img_bn.pr7.stats.shtml
