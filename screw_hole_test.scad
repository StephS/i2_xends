// print this and adjust your settings.
include <inc/nuts_screws.scad>

difference() {
	cube([17,17,15]);
	translate([5,5,0]) {
		screw_hole(type=screw_M3_button_head, h=12, head_drop=3, $fn=0, hole_support=true);
		translate([0,0,15+0.01]) mirror ([0,0,1]) nut_hole(type=nut_M3);
		translate([0,7,15]) mirror ([0,0,1]) screw_hole(type=screw_M3_button_head, h=12, head_drop=3, $fn=0);
		translate([0,7,4]) rotate([0,0,90]) nut_hole(type=nut_M3, nut_slot=7);
	}
	translate([13,17,4])
	rotate([90,0,0]){
		screw_hole(type=screw_M3_button_head, h=14, head_drop=3, $fn=8, horizontal=true);
		translate([0,0,17+0.01]) mirror ([0,0,1]) nut_hole(type=nut_M3, horizontal=true);
		translate([0,7,17]) mirror ([0,0,1]) screw_hole(type=screw_M3_button_head, h=14, head_drop=3, $fn=8, horizontal=true);
	}
	translate([13,13,11]) rotate([90,0,0]) nut_hole(type=nut_M3, nut_slot=7, horizontal=true);
}