#!/bin/bash
# @file create_sr_example_pages.sh
# @brief create a super-resolution example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-28

if [ "$1" = "" ]; then
	echo "no filename given"
	exit -1
fi

if [ "$2" = "" ]; then
	echo "no html filename given"
	exit -1
fi

if [ "$3" = "" ]; then
	echo "no destination directory given"
	exit -1
fi

if [ "$4" = "" ]; then
	echo "no title given"
	exit -1
fi

img_fn=$1
img_bn=$(basename $1 .ppm)
html_fn=$2
img_dir=$3
title=$4

make_link () {
	echo "<a href=\"$1\" class=\"example_link\"><img src=\"$2/$3.thumb.png\"></a>" >> $4
}

make_page () {
	echo "<!--#include virtual=\"../open_example.shtml\" -->" > $1
	echo "<div class=\"example_image\">" >> $1
	echo "<img src=\"$2.$3.png\">" >> $1
	echo "</div>" >> $1
	echo "<div class=\"example_title\">" >> $1
	echo "<h3>" >> $1
	echo "$4" >> $1
	echo "</h3>" >> $1
	echo "</div>" >> $1
	echo "<div class=\"example_menu\">" >> $1
	echo "<a href=\"../applications.shtml\">Previous Page</a>" >> $1
	echo "<ul>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.compare.shtml'\">Input</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.biprior.shtml'\">Biprior (RCM)</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.bilinear.shtml'\">Bilinear</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.spline.shtml'\">Spline</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.bicubic.shtml'\">Bicubic</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.lanczos.shtml'\">Lanczos</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.pr7.shtml'\">Perfect Resize 7.0</button>" >> $1
	echo "</li>" >> $1
	echo "</ul>" >> $1
	echo "</div>" >> $1
	echo "<!--#include virtual=\"$2.$3.stats.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../footer.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

make_link $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn

make_page $img_dir/$img_bn.compare.shtml $img_bn input "$title"
make_page $img_dir/$img_bn.biprior.shtml $img_bn biprior "$title"
make_page $img_dir/$img_bn.bilinear.shtml $img_bn bilinear "$title"
make_page $img_dir/$img_bn.spline.shtml $img_bn spline "$title"
make_page $img_dir/$img_bn.bicubic.shtml $img_bn bicubic "$title"
make_page $img_dir/$img_bn.lanczos.shtml $img_bn lanczos "$title"
make_page $img_dir/$img_bn.pr7.shtml $img_bn pr7 "$title"
