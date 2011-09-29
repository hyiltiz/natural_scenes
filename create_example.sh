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
	echo "no destination directory given"
	exit -1
fi

fn=$1
bn=$(basename $fn .ppm)
dest=$2

echo "basename: $bn"
