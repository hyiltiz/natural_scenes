#!/bin/bash
# @file create_ccp_example_stats.sh
# @brief create color channel prediction stats for each example image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2014-11-26

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

output $img_dir/$img_bn.cropped.stats.shtml $img_dir/$img_bn.cropped.ppm "---" "---"

output $img_dir/$img_bn.gb.stats.shtml $img_dir/$img_bn.cropped.ppm `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.gb.ppm` "---"
output $img_dir/$img_bn.rcm.gb.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.rcm.gb.ppm` "RCM R"
output $img_dir/$img_bn.mlr.gb.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.mlr.gb.ppm` "MLR R"

output $img_dir/$img_bn.rb.stats.shtml $img_dir/$img_bn.cropped.ppm `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.rb.ppm` "---"
output $img_dir/$img_bn.rcm.rb.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.rcm.rb.ppm` "RCM G"
output $img_dir/$img_bn.mlr.rb.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.mlr.rb.ppm` "MLR G"

output $img_dir/$img_bn.rg.stats.shtml $img_dir/$img_bn.cropped.ppm `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.rg.ppm` "---"
output $img_dir/$img_bn.rcm.rg.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.rcm.rg.ppm` "RCM B"
output $img_dir/$img_bn.mlr.rg.stats.shtml $img_dir/$img_bn.cropped.ppm  `$bin/mse $img_dir/$img_bn.cropped.ppm $img_dir/$img_bn.mlr.rg.ppm` "MLR B"
