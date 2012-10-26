#!/bin/bash
# @file create_dn_example_stats.sh
# @brief create denoise stats for each example image
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

img_fn=$1
img_bn=$(basename $1 .original.ppm)
img_dir=$2

bin=~/Projects/point_prediction

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
	echo "</tr>" >> $1
	echo "<tr>" >> $1
	echo "<td>" >> $1
	echo "method" >> $1
	echo "</td>" >> $1
	echo "<td>" >> $1
	echo "$4" >> $1
	echo "</td>" >> $1
	echo "</tr>" >> $1
	echo "<tr>" >> $1
	echo "<td>" >> $1
	echo "mse" >> $1
	echo "</td>" >> $1
	echo "<td>" >> $1
	echo "$3" >> $1
	echo "</td>" >> $1
	echo "</tr>" >> $1
	echo "</table>" >> $1
	echo "</div>" >> $1
}

output $img_dir/$img_bn.original.stats.shtml $img_dir/$img_bn.original.ppm "---" "---"
output $img_dir/$img_bn.noisy.stats.shtml $img_dir/$img_bn.original.ppm `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.noisy.ppm` "---"
output $img_dir/$img_bn.rcm.stats.shtml $img_dir/$img_bn.original.ppm  `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.rcm.ppm` "RCM"
output $img_dir/$img_bn.wiener.stats.shtml $img_dir/$img_bn.original.ppm `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.wiener.ppm` "Wiener"
output $img_dir/$img_bn.im.stats.shtml $img_dir/$img_bn.original.ppm `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.im.ppm` "IM"
output $img_dir/$img_bn.cbm3d.stats.shtml $img_dir/$img_bn.original.ppm `$bin/mse $img_dir/$img_bn.original.ppm $img_dir/$img_bn.cbm3d.ppm` "CBM3D"
