# @file Makefile
# @brief make file collections
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-27

SRC=~/Data/nikond700db/original
DEST=~/Data/nikond700db/rgb_ahd_16bit
# cbm3d fails if your thread count is too high
MAXPROCS=16

# You have to build the pages for each value of sigma by hand.
#SIGMA=5
#SIGMA=10
SIGMA=15
#SIGMA=25

all_dn: \
	create_dn_example_images \
	create_dn_example_pages \
	create_dn_example_stats

all_sr1: \
	convert_sr_examples \
	create_sr_example_images \
	get_other_4x4_images \
	create_sr_example_pages \
	pr7_upload

# now run pr7 on the 2x2 and 4x4 examples

all_sr2: \
	pr7_download \
	create_sr_example_stats

all_ccp: \
	clean_ccp_example_pages \
	create_ccp_example_images \
	create_ccp_example_pages \
	create_ccp_example_stats

image_sets: \
	convert_ppm \
	exifzips \
	ppmzips \
	exiftars \
	ppmtars \
	thumbs \
	montages \
	convert_ppm_jb \
	exifzips_jb \
	ppmzips_jb \
	thumbs_jb \
	montages_jb

asdf: \
	convert_ppm_human_made \
	exifzips_human_made \
	ppmzips_human_made \
	thumbs_human_made \
	montages_human_made

WEB=~/Data/web
DB=$(WEB)/db

convert_ppm:
	@mkdir -p $(DEST)
	@find $(SRC) -name "*.nef" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "dcraw -c -v -4 -o 0 -q 3 {} > $(DEST)/\`basename {} .nef\`.ppm"

file_sets:
	@ls $(DEST) | cut -b 1-11 | uniq > file_sets.txt

PPM_SRC=$(DEST)
EXIF_SRC=~/Data/nikond700db/exif/

exifzips: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P $(MAXPROCS) -I{} sh -c "find $(EXIF_SRC) -name '{}*.exif' | zip -j -@ $(DB)/{}.exif.zip"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.exif.zip

ppmzips: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P $(MAXPROCS) -I{} sh -c "find $(PPM_SRC) -name '{}*.ppm' | zip -j -@ $(DB)/{}.ppm.zip"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.ppm.zip

exiftars: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P $(MAXPROCS) -I{} sh -c "tar cvf $(DB)/{}.exif.tar \`find $(EXIF_SRC) -name '{}*.exif'\`"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.exif.tar

ppmtars: file_sets
	@mkdir -p $(DB)
	@cat file_sets.txt | xargs -P $(MAXPROCS) -I{} sh -c "tar cvf $(DB)/{}.ppm.tar \`find $(PPM_SRC) -name '{}*.ppm'\`"
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.ppm.tar

THUMBS_DEST=~/Data/nikond700db/thumbs

thumbs: file_sets
	@mkdir -p $(THUMBS_DEST)
	@find $(DEST) -name "*.ppm" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "convert -contrast-stretch 2%x1% -resize 42x28 -gamma 2.2 {} $(THUMBS_DEST)/\`basename {} .ppm\`.thumb.png"

montages: file_sets
	@cat file_sets.txt | xargs --verbose -P1 -I{} sh -c "montage -geometry 42x28+1+1 -tile 12x \`find $(THUMBS_DEST) -name '{}*.png'\` {}.montage.png"

#############################################
# support for Johannes' image set
#############################################

JBSRC=~/Data/nikond700db/jb
JBDEST=~/Data/nikond700db/jb_rgb_ahd_16bit

convert_ppm_jb:
	@mkdir -p $(JBDEST)
	@find $(JBSRC) -name "*.nef" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "dcraw -c -v -4 -o 0 -q 3 {} > $(JBDEST)/\`basename {} .nef\`.ppm"

exifzips_jb:
	find $(JBSRC) -name '*.exif' | zip -j -@ $(DB)/cps2010-2011.exif.zip
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.exif.zip

ppmzips_jb:
	find $(JBDEST) -name '*.ppm' | zip -j -@ $(DB)/cps2010-2011.ppm.zip
	@echo "Move these files to CVIS on homepage.psy.utexas.edu:"
	@ls -1 $(DB)/*.ppm.zip

JBTHUMBS_DEST=~/Data/nikond700db/jb_thumbs

thumbs_jb:
	@mkdir -p $(JBTHUMBS_DEST)
	@find $(JBDEST) -name "*.ppm" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "convert -contrast-stretch 2%x1% -resize 42x28 -gamma 2.2 {} $(JBTHUMBS_DEST)/\`basename {} .ppm\`.thumb.png"

montages_jb:
	@montage -geometry 42x28+1+1 -tile 12x `find $(JBTHUMBS_DEST) -name '*.png'` cps2010-2011.montage.png

#############################################
# support for humanmade image sets
#############################################

HMSRC=~/Data/nikond700db/human_made
HMDEST=~/Data/nikond700db/human_made_rgb_ahd_16bit

convert_ppm_human_made:
	@mkdir -p $(HMDEST)
	@find $(HMSRC) -name "*.nef" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "dcraw -c -v -4 -o 0 -q 3 {} > $(HMDEST)/\`basename {} .nef\`.ppm"

exifzips_human_made:
	find $(HMSRC) -name '*.exif' | zip -j -@ $(DB)/cps2014.exif.zip
	@ls -1 $(DB)/*.exif.zip

ppmzips_human_made:
	find $(HMDEST) -name '*.ppm' | zip -j -@ $(DB)/cps2014.ppm.zip
	@ls -1 $(DB)/*.ppm.zip

HMTHUMBS_DEST=~/Data/nikond700db/human_made_thumbs

thumbs_human_made:
	@mkdir -p $(HMTHUMBS_DEST)
	@find $(HMDEST) -name "*.ppm" | xargs --verbose -P $(MAXPROCS) -I{} sh -c "convert -contrast-stretch 2%x1% -resize 42x28 -gamma 2.2 {} $(HMTHUMBS_DEST)/\`basename {} .ppm\`.thumb.png"

montages_human_made:
	@montage -geometry 42x28+1+1 -tile 12x `find $(HMTHUMBS_DEST) -name '*.png'` cps2014.montage.png

#############################################

EXAMPLESSRC1=$(WEB)/images1/*.nef
SREXAMPLESDEST1=super_resolution_images1
SRCONVERT_CMD1="dcraw -6 -q 3 -o 0 -g 1 1 -v -c {} | convert -crop 1024x768+1630+1038 -contrast-stretch 2%x1% -depth 8 - $(SREXAMPLESDEST1)/\`basename {} .nef\`.ppm"

EXAMPLESSRC2=$(WEB)/images2/*.cropped.ppm
SREXAMPLESDEST2=super_resolution_images2
SRCONVERT_CMD2="convert -crop 1024x768+0+0 -contrast-stretch 2%x1% -depth 8 {} $(SREXAMPLESDEST2)/\`basename {} .cropped.ppm\`.ppm"

EXAMPLESSRC3=$(WEB)/images3/*.ppm
SREXAMPLESDEST3=super_resolution_images3

EXAMPLESSRC4=$(WEB)/images2/*.nef

convert_sr_examples:
	mkdir -p $(SREXAMPLESDEST1)
	rm -f $(SREXAMPLESDEST1)/*
	find $(EXAMPLESSRC1) | xargs -P $(MAXPROCS) -I{} sh -c $(SRCONVERT_CMD1)
	mkdir -p $(SREXAMPLESDEST2)
	rm -f $(SREXAMPLESDEST2)/*
	find $(EXAMPLESSRC2) | xargs -P $(MAXPROCS) -I{} sh -c $(SRCONVERT_CMD2)
	mkdir -p $(SREXAMPLESDEST3)
	rm -f $(SREXAMPLESDEST3)/*
	cp $(EXAMPLESSRC3) $(SREXAMPLESDEST3)

SREXAMPLES2x2=super_resolution_examples_2x2
SREXAMPLES4x4=super_resolution_examples_4x4

create_sr_example_images:
	find $(SREXAMPLESDEST1) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_images.sh {} $(SREXAMPLES2x2) 2
	find $(SREXAMPLESDEST2) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_images.sh {} $(SREXAMPLES2x2) 2
	find $(SREXAMPLESDEST1) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_images.sh {} $(SREXAMPLES4x4) 4
	find $(SREXAMPLESDEST2) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_images.sh {} $(SREXAMPLES4x4) 4
	find $(SREXAMPLESDEST3) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_images_noref.sh {} $(SREXAMPLES4x4) 4

DNEXAMPLES1=denoise_examples1_sigma$(SIGMA)
DNEXAMPLES2=denoise_examples2_sigma$(SIGMA)

create_dn_example_images:
	mkdir -p $(DNEXAMPLES1)
	rm -f $(DNEXAMPLES1)/*
	find $(EXAMPLESSRC1) -name "*.nef" | xargs -P $(MAXPROCS) -I{} ./create_dn_example_images.sh {} $(DNEXAMPLES1) $(SIGMA) ~/Data/nikond700db/denoising ppm
	mkdir -p $(DNEXAMPLES2)
	rm -f $(DNEXAMPLES2)/*
	find $(EXAMPLESSRC4) -name "*.nef" | xargs -P $(MAXPROCS) -I{} ./create_dn_example_images.sh {} $(DNEXAMPLES2) $(SIGMA) ~/Data/web/images2 gamma.ppm

clean_dn_example_pages:
	mkdir -p $(DNEXAMPLES1)
	mkdir -p $(DNEXAMPLES2)
	rm -f $(DNEXAMPLES1)/*.shtml
	rm -f $(DNEXAMPLES2)/*.shtml
	rm -f denoise1_sigma$(SIGMA).shtml
	rm -f denoise2_sigma$(SIGMA).shtml
	cp style.css $(DNEXAMPLES1)
	cp style.css $(DNEXAMPLES2)

create_dn_example_pages: clean_dn_example_pages
	find $(DNEXAMPLES1) -name "*.original.ppm" | sort | xargs -I{} ./create_dn_example_pages.sh {} denoise1_sigma$(SIGMA).shtml $(DNEXAMPLES1) "Denoising"
	find $(DNEXAMPLES2) -name "*.original.ppm" | sort | xargs -I{} ./create_dn_example_pages.sh {} denoise2_sigma$(SIGMA).shtml $(DNEXAMPLES2) "Denoising"

create_dn_example_stats:
	find $(DNEXAMPLES1) -name "*.original.ppm" | xargs -P $(MAXPROCS) -I{} ./create_dn_example_stats.sh {} $(DNEXAMPLES1)
	find $(DNEXAMPLES2) -name "*.original.ppm" | xargs -P $(MAXPROCS) -I{} ./create_dn_example_stats.sh {} $(DNEXAMPLES2)

CCPEXAMPLES=ccp_examples

clean_ccp_example_pages:
	rm -f color_channel_prediction.shtml
	rm -f $(CCPEXAMPLES)/*.shtml
	cp style.css $(CCPEXAMPLES)

create_ccp_example_images:
	mkdir -p $(CCPEXAMPLES)
	rm -f $(CCPEXAMPLES)/*
	find $(EXAMPLESSRC1) -name "*.nef" | xargs -P $(MAXPROCS) -I{} ./create_ccp_example_images.sh {} $(CCPEXAMPLES)

create_ccp_example_pages: clean_ccp_example_pages
	find $(CCPEXAMPLES) -name "*.original.ppm" | sort | xargs -I{} ./create_ccp_example_pages.sh {} color_channel_prediction.shtml $(CCPEXAMPLES) "Color Channel Prediction"

create_ccp_example_stats:
	find $(CCPEXAMPLES) -name "*.original.ppm" | sort | xargs -P $(MAXPROCS) -I{} ./create_ccp_example_stats.sh {} $(CCPEXAMPLES)

compare_dn:
	@echo Noisy:
	@find $(DNEXAMPLES1) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.noisy.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null
	@echo RCM:
	@find $(DNEXAMPLES1) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.rcm.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null
	@echo CBM3D:
	@find $(DNEXAMPLES1) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.cbm3d.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null
	@echo Noisy:
	@find $(DNEXAMPLES2) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.noisy.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null
	@echo RCM:
	@find $(DNEXAMPLES2) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.rcm.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null
	@echo CBM3D:
	@find $(DNEXAMPLES2) -name "*.original.ppm"| sed 's,.original.ppm,,' | xargs -I{} sh -c "echo -e \"{}.original.ppm\n{}.cbm3d.ppm\""|~/Projects/point_prediction/xstats 2> /dev/null

get_other_4x4_images:
	cp $(WEB)/images3/*.fattal.png $(SREXAMPLES4x4)
	cp $(WEB)/images3/*.glasner.png $(SREXAMPLES4x4)
	find $(WEB)/images3/*.fattal.png | xargs --verbose -I{} sh -c "convert {} $(SREXAMPLES4x4)/\`basename {} .png\`.ppm"
	find $(WEB)/images3/*.glasner.png | xargs --verbose -I{} sh -c "convert {} $(SREXAMPLES4x4)/\`basename {} .png\`.ppm"

clean_sr_example_pages:
	mkdir -p $(SREXAMPLES2x2)
	mkdir -p $(SREXAMPLES4x4)
	rm -f $(SREXAMPLES2x2)/*.shtml
	rm -f $(SREXAMPLES4x4)/*.shtml
	rm -f sr1_2x2.shtml
	rm -f sr2_2x2.shtml
	rm -f sr1_4x4.shtml
	rm -f sr2_4x4.shtml
	rm -f sr3_4x4.shtml
	cp style.css $(SREXAMPLES2x2)
	cp style.css $(SREXAMPLES4x4)

create_sr_example_pages: clean_sr_example_pages
	find $(SREXAMPLESDEST1) -name "*.ppm" | sort | xargs -I{} ./create_sr_example_pages.sh {} sr1_2x2.shtml $(SREXAMPLES2x2) "2x Super-resolution"
	find $(SREXAMPLESDEST2) -name "*.ppm" | sort | xargs -I{} ./create_sr_example_pages.sh {} sr2_2x2.shtml $(SREXAMPLES2x2) "2x Super-resolution"
	find $(SREXAMPLESDEST1) -name "*.ppm" | sort | xargs -I{} ./create_sr_example_pages.sh {} sr1_4x4.shtml $(SREXAMPLES4x4) "4x Super-resolution"
	find $(SREXAMPLESDEST2) -name "*.ppm" | sort | xargs -I{} ./create_sr_example_pages.sh {} sr2_4x4.shtml $(SREXAMPLES4x4) "4x Super-resolution"
	find $(SREXAMPLESDEST3) -name "*.ppm" | sort | xargs -I{} ./create_sr_example_pages_noref.sh {} sr3_4x4.shtml $(SREXAMPLES4x4) "4x Super-resolution"

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

create_sr_example_stats:
	find $(SREXAMPLESDEST1) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_stats.sh {} $(SREXAMPLES2x2)
	find $(SREXAMPLESDEST2) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_stats.sh {} $(SREXAMPLES2x2)
	find $(SREXAMPLESDEST1) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_stats.sh {} $(SREXAMPLES4x4)
	find $(SREXAMPLESDEST2) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_stats.sh {} $(SREXAMPLES4x4)
	find $(SREXAMPLESDEST3) -name "*.ppm" | xargs -P $(MAXPROCS) -I{} ./create_sr_example_stats_noref.sh {} $(SREXAMPLES4x4)

WEBSITE=laits:/mnt/www/natural-scenes.cps.utexas.edu

publish_html:
	scp style.css *.shtml *.png *.pdf logo.gif favicon.ico *_pixel_sensitivities.txt checksums.txt NormalizedD700SpectralSensitivities.txt $(WEBSITE)
	# this html code contains a different statcounter id
	scp close_cps.shtml $(WEBSITE)/close.shtml
	# this html code contains different google analytics ids
	scp open_cps.shtml $(WEBSITE)/open.shtml
	scp open_example_cps.shtml $(WEBSITE)/open_example.shtml

publish_examples:
	scp -r denoise_examples* super_resolution_examples* ccp_examples $(WEBSITE)

publish_code:
	scp -r retina_V1_model $(WEBSITE)
	rm -f retina_V1_model.zip
	zip -r retina_V1_model.zip retina_V1_model
	scp retina_V1_model.zip $(WEBSITE)

publish: publish_html publish_examples publish_code

backup:
	cp -av * /mnt/wsglab/Users/Perry/backups/natural_scenes

clean:
	rm -f file_sets.txt
	rm -f *.montage.png
	rm -f *.montage.png
	rm -f sr?_2x2.shtml
	rm -f sr?_4x4.shtml
	rm -f $(SREXAMPLES2x2)/*
	rm -f $(SREXAMPLES4x4)/*
