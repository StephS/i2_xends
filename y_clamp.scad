include <configuration.scad>

module belt_teeth_cutout(distance=30, center=true) {
	union(){
		translate([(center) ? -(distance-belt[0]/2)/2 : belt[0]/4, (center) ? 0 : (belt_width+0.1)/2, (belt[2]+0.1)/2]) {
			for (i = [0 : distance/belt[0]-1+((distance%belt[0])/(distance%belt[0]+1))]) {
				translate([(belt[0]*belt[1])/2+i*belt[0], 0, 0]) cube([belt[0]*belt[1], (belt_width+0.1), (belt[2]+0.1)], center = true);
			}
		}
	}
}

module y_belt_clamp() {
	difference() {
		translate([-y_belt_clamp_length/2, -y_belt_clamp_width/2, 0]) cube_fillet([y_belt_clamp_length, y_belt_clamp_width, y_belt_clamp_thickness+belt[4]], vertical=[5,5,5,5]);
		translate([y_belt_clamp_screw_separation/2, 0, 0]) screw_hole(type=y_belt_clamp_screw);
		translate([-y_belt_clamp_screw_separation/2, 0, 0]) screw_hole(type=y_belt_clamp_screw);
		translate([0, 0, y_belt_clamp_thickness+0.01]) rotate([180,0,90]) belt_teeth_cutout(distance=y_belt_clamp_width,center=true);
		translate([-(belt_width+0.1)/2, -(y_belt_clamp_width+0.1)/2, y_belt_clamp_thickness]) cube([(belt_width+0.1), y_belt_clamp_width+0.1, belt[4]+0.01]);
	}
}

module y_belt_clamp_nut_trap() {
	difference() {
		translate([-y_belt_clamp_length/2, -y_belt_clamp_width/2, 0]) cube_fillet([y_belt_clamp_length, y_belt_clamp_width, y_belt_clamp_thickness], vertical=[5,5,5,5]);
		translate([y_belt_clamp_screw_separation/2, 0, -0.01]) nut_hole(type=y_belt_clamp_nut,  thickness=y_belt_clamp_thickness+0.1);
		translate([-y_belt_clamp_screw_separation/2, 0, -0.01]) nut_hole(type=y_belt_clamp_nut, thickness=y_belt_clamp_thickness+0.1);
	}
}

module x_carriage_tensioner_clamp() {
	difference() {
		union() {
			cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2+x_carriage_belt_clamp_offset, x_carriage_belt_support_width, x_carriage_belt_clamp_thickness], vertical=[5,5,5,5]);
			translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset*2+belt_width+x_carriage_belt_clamp_offset, x_carriage_belt_support_width/2, x_carriage_belt_clamp_thickness+(x_carriage_base_size[2]-1.5)/2-0.01]) cube_fillet([screw_dia(x_carriage_belt_clamp_screw)-0.1, x_carriage_belt_support_width/2, x_carriage_base_size[2]-1.5], vertical=[1.25,1.25,1.25,1.25], top=[0.5,0.5,0.5,0.5], center=true);
		}
		translate([x_carriage_belt_clamp_nut_support_outer_dia, x_carriage_belt_support_width/2, 0]) screw_hole(type=x_carriage_belt_clamp_screw);
		translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset, -0.1, x_carriage_belt_clamp_thickness-belt[3]+0.01]) cube([belt_width, x_carriage_belt_support_width+0.2, belt[3]]);
	}
}

//y_belt_clamp();
y_belt_clamp_nut_trap();
