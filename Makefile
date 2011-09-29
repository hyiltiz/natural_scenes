# @file Makefile
# @brief make file collections
# @author Jeff Perry <jeffsp@gmail.com>
# @version 1.0
# @date 2011-09-27

SRC=/media/sunbright/nikond700db/original
DEST=/var/local/point_prediction/nikond700db/srgb_ahd_16bit

convert_ppm:
	@mkdir -p $(DEST)
	@find $(SRC) -name "*.nef" | xargs --verbose -P12 -I{} sh -c "dcraw -c -v -4 -o 1 -q 3 {} > $(DEST)/\`basename {} .nef\`.ppm"

WEB=/var/local/point_prediction/web
DB=$(WEB)/db

file_sets:
	@ls $(DEST) | cut -b 1-11 | uniq > file_sets.txt
	@cat file_sets.txt

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
	@cp -v $(DB)/*.zip /mnt/cvis/point_prediction
	@touch /mnt/cvis/point_prediction/*.zip

thumbs:
	cat file_sets.txt | xargs --verbose -P1 -I{} sh -c "montage -geometry 42x28+1+1 -tile 14x -gamma 2.9 \`find $(PPM_SRC) -name '{}*.ppm'\` {}.montage.png"

EXAMPLESSRC1=$(WEB)/images1/*.16bit.ppm
EXAMPLESSRC2=$(WEB)/images2/*.nef
EXAMPLESDEST1_2x2=super_resolution_images1_2x2
EXAMPLESDEST2_2x2=super_resolution_images2_2x2
EXAMPLESDEST1_4x4=super_resolution_images1_4x4
EXAMPLESDEST2_4x4=super_resolution_images2_4x4
RGB_AHD_CMD1_2x2="convert -crop 1070x710+0+0 -contrast-stretch 2%x1% -depth 8 {} $(EXAMPLESDEST1_2x2)/\`basename {} .16bit.ppm\`.ppm"
RGB_AHD_CMD2_2x2="dcraw -6 -q 3 -o 0 -v -c {} | convert -crop 1070x710+1606+1066 -contrast-stretch 2%x1% -depth 8 - $(EXAMPLESDEST2_2x2)/\`basename {} .nef\`.ppm"
RGB_AHD_CMD2_4x4="dcraw -6 -q 3 -o 0 -v -c {} | convert -crop 535x355+1874+1244 -contrast-stretch 2%x1% -depth 8 - $(EXAMPLESDEST2_4x4)/\`basename {} .nef\`.ppm"

# These must be done manually
# RGB_AHD_CMD1_4x4="convert -crop 268x178 -contrast-stretch 2%x1% -depth 8 {} $(EXAMPLESDEST1_4x4)/\`basename {} .16bit.ppm\`.ppm"

convert_examples:
	mkdir -p $(EXAMPLESDEST1_2x2)
	mkdir -p $(EXAMPLESDEST2_2x2)
	mkdir -p $(EXAMPLESDEST2_4x4)
	rm -f $(EXAMPLESDEST1_2x2)/*
	rm -f $(EXAMPLESDEST2_2x2)/*
	rm -f $(EXAMPLESDEST2_4x4)/*
	find $(EXAMPLESSRC1) | xargs -P12 -I{} sh -c $(RGB_AHD_CMD1_2x2)
	find $(EXAMPLESSRC2) | xargs -P12 -I{} sh -c $(RGB_AHD_CMD2_2x2)
	find $(EXAMPLESSRC2) | xargs -P12 -I{} sh -c $(RGB_AHD_CMD2_4x4)

EXAMPLESDEST=super_resolution_examples

create_examples:
	mkdir -p $(EXAMPLESDEST)
	rm -f $(EXAMPLESDEST)/*
	rm -f sr1_4x4.shtml
	find $(EXAMPLESDEST1_4x4) -name "*.ppm" | xargs -I{} ./create_example_4x4.sh {} sr1_4x4.shtml $(EXAMPLESDEST)

clean:
	rm -f file_sets.txt
	rm *.montage.png
	rm -rf tmp

