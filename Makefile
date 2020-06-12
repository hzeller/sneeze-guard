ALL_OUTPUT=print_top_t.stl print_bottom_t.stl \
           print_left_corner_mount.stl print_right_corner_mount.stl

all : $(ALL_OUTPUT)

# Create an scad file on-the-fly that calls that particular function
%.scad : sneeze-guard.scad
	echo "use <sneeze-guard.scad>; $*();" > $@

%.stl : %.scad
	openscad -o $@ $<
