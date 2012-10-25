#!/bin/bash
# @file create_sr_example_stats_noref.sh
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
	echo "<div class=\"example_stats\">" > $1
	echo "<table>" >> $1
	echo "<tr>" >> $1
	echo "<td>" >> $1
	echo "input" >> $1
	echo "</td>" >> $1
	echo "<td>" >> $1
	echo "`identify $2 | cut -f3 -d' '`" >> $1
	echo "</td>" >> $1
	echo "</tr>" >> $1
	echo "<tr>" >> $1
	echo "<td>" >> $1
	echo "output" >> $1
	echo "</td>" >> $1
	echo "<td>" >> $1
	echo "`identify $3 | cut -f3 -d' '`" >> $1
	echo "</td>" >> $1
	echo "</tr>" >> $1
	echo "<tr>" >> $1
	echo "<td>" >> $1
	echo "method" >> $1
	echo "</td>" >> $1
	echo "<td>" >> $1
	echo "$4" >> $1
	echo "</td>" >> $1
	echo "</tr>" >> $1
	echo "</table>" >> $1
	echo "</div>" >> $1
}

output $img_dir/$img_bn.input.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.downsampled.ppm "---"
output $img_dir/$img_bn.biprior.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.biprior.ppm "Biprior"
output $img_dir/$img_bn.bilinear.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.bilinear.ppm "Bilinear"
output $img_dir/$img_bn.spline.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.spline.ppm "Spline"
output $img_dir/$img_bn.bicubic.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.bicubic.ppm "Bicubic"
output $img_dir/$img_bn.lanczos.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.lanczos.ppm "Lanczos"
output $img_dir/$img_bn.pr7.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.pr7.ppm "PR7"

if [ -e $img_dir/$img_bn.fattal.ppm ]
then
	output $img_dir/$img_bn.fattal.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.fattal.ppm "Fattal"
	output $img_dir/$img_bn.glasner.stats.shtml $img_dir/$img_bn.downsampled.ppm $img_dir/$img_bn.glasner.ppm "Glasner"
fi
