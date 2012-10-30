#!/bin/bash
# @file create_sr_example_pages_noref.sh
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
	echo "<a href=\"$2.compare.shtml\"><button>Input</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.biprior.shtml\"><button>Biprior (RCM)</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.bilinear.shtml\"><button>Bilinear</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.spline.shtml\"><button>Spline</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.bicubic.shtml\"><button>Bicubic</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.lanczos.shtml\"><button>Lanczos</button></a>" >> $1
	echo "</li>" >> $1
	echo "<li>" >> $1
	echo "<a href=\"$2.pr7.shtml\"><button>Perfect Resize 7.0</button></a>" >> $1
	echo "</li>" >> $1
	if [ "$5" == "yes" ]
	then
		echo "<li>" >> $1
		echo "<a href=\"$2.fattal.shtml\"><button>Fattal</button></a>" >> $1
		echo "</li>" >> $1
		echo "<li>" >> $1
		echo "<a href=\"$2.glasner.shtml\"><button>Glasner</button></a>" >> $1
		echo "</li>" >> $1
	fi
	echo "</ul>" >> $1
	echo "</div>" >> $1
	echo "<!--#include virtual=\"$2.$3.stats.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../footer.shtml\" -->" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

make_link $img_dir/$img_bn.compare.shtml $img_dir $img_bn $html_fn

if [ -e $img_dir/$img_bn.fattal.ppm ]
then
	extra_pages=yes
fi
make_page $img_dir/$img_bn.compare.shtml $img_bn input "$title" $extra_pages
make_page $img_dir/$img_bn.biprior.shtml $img_bn biprior "$title" $extra_pages
make_page $img_dir/$img_bn.bilinear.shtml $img_bn bilinear "$title" $extra_pages
make_page $img_dir/$img_bn.spline.shtml $img_bn spline "$title" $extra_pages
make_page $img_dir/$img_bn.bicubic.shtml $img_bn bicubic "$title" $extra_pages
make_page $img_dir/$img_bn.lanczos.shtml $img_bn lanczos "$title" $extra_pages
make_page $img_dir/$img_bn.pr7.shtml $img_bn pr7 "$title" $extra_pages

if [ "$extra_pages" == "yes" ]
then
	make_page $img_dir/$img_bn.fattal.shtml $img_bn fattal "$title" $extra_pages
	make_page $img_dir/$img_bn.glasner.shtml $img_bn glasner "$title" $extra_pages
fi
