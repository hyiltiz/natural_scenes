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

EXAMPLESSRC1=$(WEB)/images1
EXAMPLESSRC2=$(WEB)/images2
RGB_AHD_CMD1="dcraw -6 -q 3 -o 0 -v -c {} | convert -contrast-stretch 2%x1% -depth 8 - tmp/\`basename {} .nef\`.ppm"
RGB_AHD_CMD2="dcraw -6 -q 3 -o 0 -v -c {} | convert -contrast-stretch 2%x1% -depth 8 -crop 1070x710+1606+1066 - tmp/\`basename {} .nef\`.ppm"

examples:

convert_examples:
	mkdir -p tmp
	rm -f tmp/*
	find $(EXAMPLESSRC1) -name "*.nef" | xargs -P12 -I{} sh -c $(RGB_AHD_CMD1)
	find $(EXAMPLESSRC2) -name "*.nef" | xargs -P12 -I{} sh -c $(RGB_AHD_CMD2)

EXAMPLESDEST=./super_resolution_examples

create_examples:
	mkdir -p $(EXAMPLESDEST)
	rm -f $(EXAMPLESDEST)/*
	find tmp/ -name "*.ppm" | xargs -P12 -I{} ./create_example.sh {} $(EXAMPLESDEST)

clean:
	rm -f file_sets.txt
	rm *.montage.png
	rm -rf tmp

