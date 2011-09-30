#!/bin/bash
# @file create_example.sh
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

img_fn=$1
img_bn=$(basename $1 .ppm)
html_fn=$2
img_dir=$3

#echo "filename: $img_fn"
#echo "basename: $img_bn"
#echo "html filename: $html_fn"
#echo "image directory: $img_dir"
#echo "image html filename: $img_html_fn"

convert_input () {
	convert -gamma 2.2 -resize 400% -filter point $1 $2/$3.input.png
	convert -resize 42x28 $2/$3.input.png $2/$3.input.thumb.png
}

convert_biprior () {
	convert -gamma 2.2 -resize 400% -filter point $1 $2/$3.biprior.png
	convert -resize 42x28 $2/$3.biprior.png $2/$3.biprior.thumb.png
}

convert_bilinear () {
	convert -gamma 2.2 -resize 400% -filter point $1 $2/$3.bilinear.png
	convert -resize 42x28 $2/$3.bilinear.png $2/$3.bilinear.thumb.png
}

convert_spline () {
	convert -gamma 2.2 -resize 400% -filter point $1 $2/$3.spline.png
	convert -resize 42x28 $2/$3.spline.png $2/$3.spline.thumb.png
}

convert_bicubic () {
	convert -gamma 2.2 -resize 400% -filter point $1 $2/$3.bicubic.png
	convert -resize 42x28 $2/$3.bicubic.png $2/$3.bicubic.thumb.png
}

make_thumb () {
	echo "<a href=\"$1\" title=\"$2\"><img src=\"$3/$4\"></a>" >> $5
}

make_page () {
	echo "<!--#include virtual=\"../open_example.shtml\" -->" > $1
	echo "<img src=\"$2\">" >> $1
	echo "<br>" >> $1
	echo "$3" >> $1
	echo "<!--#include virtual=\"../close.shtml\" -->" >> $1
}

convert_input $img_fn $img_dir $img_bn
convert_biprior $img_fn $img_dir $img_bn
convert_bilinear $img_fn $img_dir $img_bn
convert_spline $img_fn $img_dir $img_bn
convert_bicubic $img_fn $img_dir $img_bn

echo "<div class=\"example_set\">" >> $html_fn
make_thumb $img_dir/$img_bn.input.shtml Input $img_dir $img_bn.input.thumb.png $html_fn
make_thumb $img_dir/$img_bn.biprior.shtml Biprior $img_dir $img_bn.biprior.thumb.png $html_fn
make_thumb $img_dir/$img_bn.bilinear.shtml Bilinear $img_dir $img_bn.bilinear.thumb.png $html_fn
make_thumb $img_dir/$img_bn.spline.shtml Spline $img_dir $img_bn.spline.thumb.png $html_fn
make_thumb $img_dir/$img_bn.bicubic.shtml Bicubic $img_dir $img_bn.bicubic.thumb.png $html_fn
echo "</div>" >> $html_fn

make_page $img_dir/$img_bn.input.shtml $img_bn.input.png Input
make_page $img_dir/$img_bn.biprior.shtml $img_bn.biprior.png Biprior
make_page $img_dir/$img_bn.bilinear.shtml $img_bn.bilinear.png Bilinear
make_page $img_dir/$img_bn.spline.shtml $img_bn.spline.png Spline
make_page $img_dir/$img_bn.bicubic.shtml $img_bn.bicubic.png Bicubic
