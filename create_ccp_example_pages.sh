#!/bin/bash
# @file create_ccp_example_pages.sh
# @brief create a color channel prediction example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2014-11-19

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
img_bn=$(basename $1 .original.ppm)
html_fn=$2
img_dir=$3
title=$4

make_link_rg () {
	echo "<a href=\"$1\" class=\"example_link\"><img src=\"$2/$3.thumb.rg.png\"></a>" >> $4
}

make_link_rb () {
	echo "<a href=\"$1\" class=\"example_link\"><img src=\"$2/$3.thumb.rb.png\"></a>" >> $4
}

make_link_gb () {
	echo "<a href=\"$1\" class=\"example_link\"><img src=\"$2/$3.thumb.gb.png\"></a>" >> $4
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
	echo "<a href=\"../applications.shtml#ccp\">Previous Page</a>" >> $1
	echo "<ul>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.compare.shtml'\">Original</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.gb.shtml'\">Red Removed</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.rcm.gb.shtml'\">RCM Red</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.mlr.gb.shtml'\">MLR Red</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.rb.shtml'\">Green Removed</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.rcm.rb.shtml'\">RCM Green</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.mlr.rb.shtml'\">MLR Green</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.rg.shtml'\">Blue Removed</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.rcm.rg.shtml'\">RCM Blue</button>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<button onclick=\"location.href='$2.mlr.rg.shtml'\">MLR Blue</button>" >> $1
	echo "</li>" >> $1
	echo "</ul>" >> $1
	echo "</div>" >> $1
	echo "<!--#include virtual=\"$2.$3.stats.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../footer.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

# get rng
N=$[ RANDOM % 3 ]

if [ $N == 0 ]; then
    make_link_rg $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn
elif [ $N == 1 ]; then
    make_link_rb $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn
else
    make_link_gb $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn
fi

make_page $img_dir/$img_bn.compare.shtml $img_bn cropped "$title"
make_page $img_dir/$img_bn.gb.shtml $img_bn gb "$title"
make_page $img_dir/$img_bn.rcm.gb.shtml $img_bn rcm.gb "$title"
make_page $img_dir/$img_bn.mlr.gb.shtml $img_bn mlr.gb "$title"
make_page $img_dir/$img_bn.rb.shtml $img_bn rb "$title"
make_page $img_dir/$img_bn.rcm.rb.shtml $img_bn rcm.rb "$title"
make_page $img_dir/$img_bn.mlr.rb.shtml $img_bn mlr.rb "$title"
make_page $img_dir/$img_bn.rg.shtml $img_bn rg "$title"
make_page $img_dir/$img_bn.rcm.rg.shtml $img_bn rcm.rg "$title"
make_page $img_dir/$img_bn.mlr.rg.shtml $img_bn mlr.rg "$title"
