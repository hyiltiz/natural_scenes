#!/bin/bash
# @file create_dn_example_pages.sh
# @brief create a denoising example from an image
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2012-10-26

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

img_bn=$(basename $1 .original.ppm)
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
	echo "<a href=\"$2.compare.shtml\"><button>Original</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.noisy.shtml\"><button>Noisy</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.rcm.shtml\"><button>RCM</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.wiener.shtml\"><button>Adaptive Wiener</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.im.shtml\"><button>IM</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.cbm3d.shtml\"><button>Color BM3D</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "</div>" >> $1
	echo "<!--#include virtual=\"$2.$3.stats.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../footer.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

make_link $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn

make_page $img_dir/$img_bn.compare.shtml $img_bn original "$title"
make_page $img_dir/$img_bn.noisy.shtml $img_bn noisy "$title"
make_page $img_dir/$img_bn.rcm.shtml $img_bn rcm "$title"
make_page $img_dir/$img_bn.wiener.shtml $img_bn wiener "$title"
make_page $img_dir/$img_bn.im.shtml $img_bn im "$title"
make_page $img_dir/$img_bn.cbm3d.shtml $img_bn cbm3d "$title"
