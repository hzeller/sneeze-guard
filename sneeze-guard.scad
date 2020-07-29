e=0.01;
$fn=40;

glass_thick=3.1;   // Acrulic thickness

// How wide the mount at the corner should be
corner_mount_w = 2.5 * 25.4;
corner_mount_thick = 3;

// since the corner mount puts the glass a bit inward, that is also the width
// of the foot of the t-thing in the middle.
foot_diameter=corner_mount_w;

table_high=35;
holding_high=30;    // How much of the acrylic is supported
holding_w=12;       // Width of the fingers holding
holding_l=50;       // lenght of the fingers.
smooth_fn=6;        // finger front-parts: not fully round circles.

glass_up=3;         // How much the acrylic is hovering over the table.

use_table_screws=false;
edge_flush=true;    // Try to get as flush as possible to table.
screw_len=40;       // General screw punching action.
screw_dia=4;

module corner_punch(up=glass_up) {
     // Plexiglass
     color("azure", 0.25) translate([-glass_thick/2, 0, up])
	  cube([glass_thick, 200, 100]);
     translate([-screw_len/2, holding_l/2, holding_high/2+up]) rotate([0, 90, 0]) cylinder(r=screw_dia/2, h=screw_len);

     // mounting holes through glass
     translate([(corner_mount_w+holding_w)/4, screw_len/2, -table_high/2]) rotate([90, 0, 0]) cylinder(r=screw_dia/2, h=screw_len);
     translate([-(corner_mount_w+holding_w)/4, screw_len/2, -table_high/2]) rotate([90, 0, 0]) cylinder(r=screw_dia/2, h=screw_len);
}

// Plexiglass for t-part
module t_glass(up=glass_up) {
     color("azure", 0.25) translate([-glass_thick/2, 0, up]) {
	  translate([0, -150, 0])
	       cube([glass_thick, 300, 150]);
	  translate([0, -glass_thick/2, 0])
	       cube([200, glass_thick, 150]);
     }
}

// Punches for T-part
module t_punch(up=glass_up) {
     t_glass(up);

     color("silver") translate([-glass_thick/2, 0, up]) {
	  // Screws right left
	  translate([-screw_len/2, -holding_l/2, holding_high/2]) rotate([0, 90, 0]) cylinder(r=screw_dia/2, h=screw_len);
	  translate([-screw_len/2, +holding_l/2, holding_high/2]) rotate([0, 90, 0]) cylinder(r=screw_dia/2, h=screw_len);

	  // Screw in the length
	  translate([holding_l/2, screw_len/2, holding_high/2]) rotate([90, 0, 0]) cylinder(r=screw_dia/2, h=screw_len);

	  if (use_table_screws) {
	       // To table screw. Outside.
	       translate([-(foot_diameter-holding_w)/4-holding_w/4, -(holding_l/2+5), -screw_len/2]) cylinder(r=screw_dia/2, h=screw_len);
	       translate([-(foot_diameter-holding_w)/4-holding_w/4, +(holding_l/2+5), -screw_len/2]) cylinder(r=screw_dia/2, h=screw_len);
	       //translate([-(foot_diameter-holding_w)/4-holding_w/4, 0, -screw_len/2]) cylinder(r=screw_dia/2, h=screw_len);

	       // Inside
	       translate([foot_diameter/2-5, +(holding_l/2-5), -screw_len/2]) cylinder(r=screw_dia/2, h=screw_len);
	       translate([foot_diameter/2-5, -(holding_l/2-5), -screw_len/2]) cylinder(r=screw_dia/2, h=screw_len);
	  }

     }
}

module corner_block(up=4, screw_to_edge=use_table_screws) {
     // holding finger
     hull() {
	  translate([0, holding_l-holding_w/2, 0]) cylinder(r=holding_w/2, h=holding_high+up, $fn=smooth_fn);
	  translate([-holding_w/2, 0, 0]) cube([holding_w, e, holding_high+up]);
     }

     // Table support
     hull() {
	  translate([-corner_mount_w/2, 0, 0]) cube([corner_mount_w, e, up]);
	  translate([0, holding_l-corner_mount_w/2, 0]) cylinder(r=corner_mount_w/2, h=up);
     }

     // Side-wall table connect
     translate([0, -corner_mount_thick, 0]) hull() {
	  translate([-corner_mount_w/2, 0, 0]) cube([corner_mount_w, corner_mount_thick, e]);
	  translate([-corner_mount_w/2, 0, up]) cube([corner_mount_w, corner_mount_thick, e]);

	  if (screw_to_edge) {
	       translate([-(corner_mount_w/2-10), 0, -(table_high-10)]) rotate([-90, 0, 0]) cylinder(r=10, h=corner_mount_thick);
	       translate([+(corner_mount_w/2-10), 0, -(table_high-10)]) rotate([-90, 0, 0]) cylinder(r=10, h=corner_mount_thick);
	  }

	  translate([-holding_w/2, 0, holding_high+up]) cube([holding_w, corner_mount_thick, e]);
     }
}

module t_block(up=0, needs_foot=false) {
     // center finger
     translate([-holding_w/2, 0, 0]) hull() {
	  translate([0, -holding_w/2, 0]) cube([e, holding_w, holding_high+up]);
	  translate([holding_l, 0, 0]) cylinder(r=holding_w/2, h=holding_high+up, $fn=smooth_fn);
     }

     // long fingers
     hull() {
	  translate([0, +(holding_l-holding_w/2), 0]) cylinder(r=holding_w/2, h=holding_high+up, $fn=smooth_fn);
	  translate([0, -(holding_l-holding_w/2), 0]) cylinder(r=holding_w/2, h=holding_high+up, $fn=smooth_fn);
     }

     // Bottom part.
     if (needs_foot) hull() {
	  translate([0, +(holding_l-foot_diameter/2), 0]) cylinder(r=foot_diameter/2, h=up);
	  translate([0, -(holding_l-foot_diameter/2), 0]) cylinder(r=foot_diameter/2, h=up);
	  translate([(holding_l-foot_diameter/2), 0, 0]) cylinder(r=foot_diameter/2, h=up);
     }
}

// Assembled t part: block minus punch.
module t_part(up=0, needs_foot=false) {
     intersection() {
	  if (edge_flush) {
	       translate([100-holding_w/2, 0, 0]) cube([200, 200, 200], center=true);
	  }
	  difference() {
	       t_block(up=up, needs_foot=needs_foot);
	       t_punch(up=up);
	  }
     }
}

module corner_mount(up=glass_up, is_right=true) {
     intersection() {
	  if (edge_flush) {
	       translate([(is_right ? -1 : 1) * (100-holding_w/2), 100-corner_mount_thick, 0]) cube([200, 200, 200], center=true);
	  }
	  difference() {
	       corner_block(up=up);
	       corner_punch(up=up);
	  }
     }
}

// Functions used in the Makefile
module print_top_t() { t_part(up=glass_up, needs_foot=false); }
module print_bottom_t() { t_part(up=glass_up, needs_foot=true); }
module print_center_t() { t_part(up=0, needs_foot=false); }

module corner_mount_preprint(up=glass_up, is_right=true) {
     if (use_table_screws) {
	  translate([0, 0, corner_mount_thick]) rotate([90, 0, 0]) corner_mount(, is_right=is_right);
     } else {
	  corner_mount(is_right=is_right);
     }
}

module print_right_corner_mount(up=glass_up) {
     corner_mount_preprint(up=up, is_right=true);
}

module print_left_corner_mount(up=glass_up) {
     corner_mount_preprint(up=up, is_right=false);
}

module assembly() {
     t_part(up=glass_up, needs_foot=true);
     translate([0, 0, 150+2*glass_up]) rotate([180, 0, 0]) t_part(up=glass_up, needs_foot=false);
     translate([0, -150, 0]) corner_mount(is_right=false);
     translate([0, 150, 0]) rotate([0, 0, 180]) corner_mount(is_right=true);

     translate([0, 0, 80+2*glass_up]) rotate([180, 0, 0]) t_part(up=-e, needs_foot=false);

     t_glass();   // Visualization glass

     color("beige", 0.3) translate([edge_flush ? -holding_w/2 : -corner_mount_w/2, -153, -38]) cube([300, 306, 38]);  // Visualization table
}

assembly();
//corner_mount();
//print_corner_mount();
