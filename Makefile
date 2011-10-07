# @file Makefile
# @brief make file collections
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-27

SRC=/media/sunbright/nikond700db/original
DEST=/var/local/point_prediction/nikond700db/srgb_ahd_16bit

all: convert_examples create_examples

convert_ppm:
	@mkdir -p $(DEST)
	@find $(SRC) -name "*.nef" | xargs --verbose -P12 -I{} sh -c "dcraw -c -v -4 -o 1 -q 3 {} > $(DEST)/\`basename {} .nef\`.ppm"

WEB=/var/local/point_prediction/web
DB=$(WEB)/db

file_sets:
	@ls $(DEST) | cut -b 1-11 | uniq > file_sets.txt

PPM_SRC=$(DEST)
EXIF_SRC=/var/local/point_prediction/nikond700db/exif/
JPEG_SRC=/var/local/point_prediction/nikond700db/jpeg/

exifzips: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P12 -I{} sh -c "find $(EXIF_SRC) -name '{}*.exif' | zip -j -@ $(DB)/{}.exif.zip"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.exif.zip

ppmzips: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P12 -I{} sh -c "find $(PPM_SRC) -name '{}*.ppm' | zip -j -@ $(DB)/{}.ppm.zip"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.ppm.zip

copytocvis:
	@cp -v $(DB)/*.zip /mnt/cvis/natural_scenes
	@touch /mnt/cvis/natural_scenes/*.zip

THUMBS_DEST=/var/local/point_prediction/nikond700db/thumbs

thumbs: file_sets
	@mkdir -p $(THUMBS_DEST)
	@find $(DEST) -name "*.ppm" | xargs --verbose -P12 -I{} sh -c "convert -contrast-stretch 2%x1% -resize 42x28 -gamma 2.2 {} $(THUMBS_DEST)/\`basename {} .ppm\`.thumb.png"

montages: file_sets
	@cat file_sets.txt | xargs --verbose -P1 -I{} sh -c "montage -geometry 42x28+1+1 -tile 12x \`find $(THUMBS_DEST) -name '{}*.png'\` {}.montage.png"

EXAMPLESSRC1=$(WEB)/images1/*.nef
EXAMPLESDEST1=super_resolution_images1
CONVERT_CMD1="dcraw -6 -q 3 -o 1 -g 1 1 -v -c {} | convert -crop 1024x768+1630+1038 -contrast-stretch 2%x1% -depth 8 - $(EXAMPLESDEST1)/\`basename {} .nef\`.ppm"

EXAMPLESSRC2=$(WEB)/images2/*.cropped.ppm
EXAMPLESDEST2=super_resolution_images2
CONVERT_CMD2="convert -crop 1024x768+0+0 -contrast-stretch 2%x1% -depth 8 {} $(EXAMPLESDEST2)/\`basename {} .cropped.ppm\`.ppm"

EXAMPLESSRC3=$(WEB)/images3/*.ppm
EXAMPLESDEST3=super_resolution_images3

convert_examples:
	mkdir -p $(EXAMPLESDEST1)
	rm -f $(EXAMPLESDEST1)/*
	find $(EXAMPLESSRC1) | xargs -P12 -I{} sh -c $(CONVERT_CMD1)
	mkdir -p $(EXAMPLESDEST2)
	rm -f $(EXAMPLESDEST2)/*
	find $(EXAMPLESSRC2) | xargs -P12 -I{} sh -c $(CONVERT_CMD2)
	mkdir -p $(EXAMPLESDEST3)
	rm -f $(EXAMPLESDEST3)/*
	cp $(EXAMPLESSRC3) $(EXAMPLESDEST3)

EXAMPLES2x2=super_resolution_examples_2x2
EXAMPLES4x4=super_resolution_examples_4x4

create_example_images:
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -P12 -I{} ./create_example_images.sh {} $(EXAMPLES2x2) 2
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -P12 -I{} ./create_example_images.sh {} $(EXAMPLES2x2) 2
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -P12 -I{} ./create_example_images.sh {} $(EXAMPLES4x4) 4
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -P12 -I{} ./create_example_images.sh {} $(EXAMPLES4x4) 4
	find $(EXAMPLESDEST3) -name "*.ppm" | xargs -P12 -I{} ./create_example_images_noref.sh {} $(EXAMPLES4x4) 4

get_other_4x4_images:
	cp $(WEB)/images3/*.fattal.png $(EXAMPLES4x4)
	cp $(WEB)/images3/*.glasner.png $(EXAMPLES4x4)
	find $(WEB)/images3/*.fattal.png | xargs --verbose -I{} sh -c "convert {} $(EXAMPLES4x4)/\`basename {} .png\`.ppm"
	find $(WEB)/images3/*.glasner.png | xargs --verbose -I{} sh -c "convert {} $(EXAMPLES4x4)/\`basename {} .png\`.ppm"

clean_example_pages:
	mkdir -p $(EXAMPLES2x2)
	mkdir -p $(EXAMPLES4x4)
	rm -f $(EXAMPLES2x2)/*.shtml
	rm -f $(EXAMPLES4x4)/*.shtml
	rm -f sr1_2x2.shtml
	rm -f sr2_2x2.shtml
	rm -f sr1_4x4.shtml
	rm -f sr2_4x4.shtml
	rm -f sr3_4x4.shtml
	cp style.css $(EXAMPLES2x2)
	cp style.css $(EXAMPLES4x4)

create_example_pages: clean_example_pages
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -I{} ./create_example_pages.sh {} sr1_2x2.shtml $(EXAMPLES2x2) "2x Super-resolution"
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -I{} ./create_example_pages.sh {} sr2_2x2.shtml $(EXAMPLES2x2) "2x Super-resolution"
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -I{} ./create_example_pages.sh {} sr1_4x4.shtml $(EXAMPLES4x4) "4x Super-resolution"
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -I{} ./create_example_pages.sh {} sr2_4x4.shtml $(EXAMPLES4x4) "4x Super-resolution"
	find $(EXAMPLESDEST3) -name "*.ppm" | sort -h | xargs -I{} ./create_example_pages_noref.sh {} sr3_4x4.shtml $(EXAMPLES4x4) "4x Super-resolution"

# get files onto wsglab for conversion
#
# you have to convert the pr7 files before you can generate stats
pr7_upload:
	mkdir -p /mnt/wsglab/Users/Perry/tmp
	mkdir -p /mnt/wsglab/Users/Perry/tmp/2x2
	mkdir -p /mnt/wsglab/Users/Perry/tmp/4x4
	cp -v super_resolution_examples_2x2/*.downsampled.png /mnt/wsglab/Users/Perry/tmp/2x2
	cp -v super_resolution_examples_4x4/*.downsampled.png /mnt/wsglab/Users/Perry/tmp/4x4
	ls /mnt/wsglab/Users/Perry/tmp/2x2/*.downsampled.png | wc
	ls /mnt/wsglab/Users/Perry/tmp/4x4/*.downsampled.png | wc

# get converted files from wsglab
pr7_download:
	cp /mnt/wsglab/Users/Perry/tmp/2x2/*.pr7.png super_resolution_examples_2x2
	cp /mnt/wsglab/Users/Perry/tmp/4x4/*.pr7.png super_resolution_examples_4x4
	rename .downsampled.pr7 .pr7 super_resolution_examples_2x2/*.pr7.png
	rename .downsampled.pr7 .pr7 super_resolution_examples_4x4/*.pr7.png
	chmod -x super_resolution_examples_2x2/*.pr7.png
	chmod -x super_resolution_examples_4x4/*.pr7.png
	find super_resolution_examples_2x2/*.pr7.png | xargs -I{} convert {} {}.ppm
	find super_resolution_examples_4x4/*.pr7.png | xargs -I{} convert {} {}.ppm
	rename .png.ppm .ppm super_resolution_examples_2x2/*.pr7.png.ppm
	rename .png.ppm .ppm super_resolution_examples_4x4/*.pr7.png.ppm

create_example_stats:
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -P12 -I{} ./create_example_stats.sh {} $(EXAMPLES2x2)
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -P12 -I{} ./create_example_stats.sh {} $(EXAMPLES2x2)
	find $(EXAMPLESDEST1) -name "*.ppm" | xargs -P12 -I{} ./create_example_stats.sh {} $(EXAMPLES4x4)
	find $(EXAMPLESDEST2) -name "*.ppm" | xargs -P12 -I{} ./create_example_stats.sh {} $(EXAMPLES4x4)
	find $(EXAMPLESDEST3) -name "*.ppm" | xargs -P12 -I{} ./create_example_stats_noref.sh {} $(EXAMPLES4x4)

publish:
	scp -r style.css *.shtml *.png *.pdf logo.gif pixel_sensitivities.txt super_resolution_examples* cps:/var/www/html/natural_scenes/

clean:
	rm -f file_sets.txt
	rm -f *.montage.png
	rm -f *.montage.png
	rm -f sr?_2x2.shtml
	rm -f sr?_4x4.shtml
	rm -f $(EXAMPLES2x2)/*
	rm -f $(EXAMPLES4x4)/*
