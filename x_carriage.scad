include <configuration.scad>
use <bushing.scad>

module x_carriage() {
	difference () {
		union () {
			// base plate
			translate([0,0,x_carriage_base_size[2]/2]) cube(x_carriage_base_size, center=true);
			difference() {
				union() {
					// support cylinder
					cylinder_poly(r=x_extruder_mount_hole_diameter/2+(x_extruder_mount_screw_spacing-x_extruder_mount_hole_diameter),h=(x_carriage_base_support_thickness+x_carriage_base_size[2]));
					// fan support
					translate([-x_carriage_fan[1]/2,-x_carriage_base_size[1]/2, 0]) cube([x_carriage_fan[1], x_carriage_fan_nut_wall_thickness, x_carriage_fan_nut_wall_height]);
					// fan support
					translate([-x_carriage_fan[1]/2,x_carriage_base_size[1]/2-x_carriage_fan_nut_wall_thickness, 0]) cube([x_carriage_fan[1], x_carriage_fan_nut_wall_thickness, x_carriage_fan_nut_wall_height]);
				}
				// cutout for fan support
				translate([0,-x_carriage_base_size[1]/2-0.1, sagitta_radius(x_carriage_fan_nut_wall_height-x_carriage_base_size[2],x_carriage_fan[0]/2-nut_outer_dia(v_nut_hole(x_carriage_fan_nut))/2)+x_carriage_base_size[2]]) rotate([-90,0,0]) cylinder_poly(r=sagitta_radius(x_carriage_fan_nut_wall_height-x_carriage_base_size[2],x_carriage_fan[0]/2-nut_outer_dia(v_nut_hole(x_carriage_fan_nut))/2), h=x_carriage_fan_nut_wall_thickness+0.2);
				translate([0,x_carriage_base_size[1]/2-x_carriage_fan_nut_wall_thickness-0.1, sagitta_radius(x_carriage_fan_nut_wall_height-x_carriage_base_size[2],x_carriage_fan[0]/2-nut_outer_dia(v_nut_hole(x_carriage_fan_nut))/2)+x_carriage_base_size[2]]) rotate([-90,0,0]) cylinder_poly(r=sagitta_radius(x_carriage_fan_nut_wall_height-x_carriage_base_size[2],x_carriage_fan[0]/2-nut_outer_dia(v_nut_hole(x_carriage_fan_nut))/2), h=x_carriage_fan_nut_wall_thickness+0.2);
				
				// cutouts for the bearings
				translate([x_axis_smooth_rod_separation/2+(bushing_x[1] + bushing_clamp_outer_radius_add)/2, 0, ((x_carriage_base_support_thickness+x_carriage_base_size[2])+0.1)/2]) cube([(bushing_x[1] + bushing_clamp_outer_radius_add),x_carriage_base_size[1],(x_carriage_base_support_thickness+x_carriage_base_size[2])+0.2], center=true);
				translate([x_axis_smooth_rod_separation/2, 0, bushing_x[1]+x_carriage_base_size[2]+0.1]) rotate([90,0,0]) cylinder_poly(r = bushing_x[1] + 0.02, h=x_carriage_base_size[1]+0.2, center=true);
				translate([-x_axis_smooth_rod_separation/2-(bushing_x[1] + bushing_clamp_outer_radius_add)/2, 0, ((x_carriage_base_support_thickness+x_carriage_base_size[2])+0.1)/2]) cube([(bushing_x[1] + bushing_clamp_outer_radius_add),x_carriage_base_size[1],(x_carriage_base_support_thickness+x_carriage_base_size[2])+0.2], center=true);
				translate([-x_axis_smooth_rod_separation/2, 0, bushing_x[1]+x_carriage_base_size[2]+0.1]) rotate([90,0,0]) cylinder_poly(r = bushing_x[1] + 0.02, h=x_carriage_base_size[1]+0.2, center=true);
			}
			// bearing holders
			translate([0, 0, bushing_x[1]+x_carriage_base_size[2]+0.1]) {
				translate([x_axis_smooth_rod_separation/2,x_carriage_base_size[1]/2-(bushing_x[2]+bushing_retainer_add)/2, 0]) rotate([90,-90,180]) linear(conf_b = bushing_x, center=true, wide_base=true);
				translate([x_axis_smooth_rod_separation/2,-(x_carriage_base_size[1]/2-(bushing_x[2]+bushing_retainer_add)/2), 0]) rotate([90,-90,180]) linear(conf_b = bushing_x, center=true, wide_base=true);
				translate([-x_axis_smooth_rod_separation/2,x_carriage_base_size[1]/2-(bushing_x[2]+bushing_retainer_add)/2, 0]) rotate([90,-90,0]) linear(conf_b = bushing_x, center=true, wide_base=true);
				translate([-x_axis_smooth_rod_separation/2,-(x_carriage_base_size[1]/2-(bushing_x[2]+bushing_retainer_add)/2), 0]) rotate([90,-90,0]) linear(conf_b = bushing_x, center=true, wide_base=true);
			}
			// end stop flag
			translate([x_carriage_base_size[0]/2-0.1,x_carriage_base_size[1]/2-15,0])
				cube_fillet([(end_stop_mount_thickness+end_stop_size[1]/2)+screw_head_top_dia(v_screw_hole(end_stop_flag_screw))/2+3+0.1, 15, (bushing_x[1]+x_carriage_base_size[2]+0.1-(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2-end_stop_button_loc_from_screw)+screw_head_top_dia(v_screw_hole(end_stop_flag_screw))/2+3], vertical=[3,0,0,3], top=[3,0,3,3]);			// belt tensioner slide through
			// belt tensioner slide through support
			translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset),-x_carriage_base_size[1]/2,0])
				cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset+0.1, x_carriage_belt_support_width, x_carriage_base_size[2]+belt[3]], vertical=[0,4,4,0]);
			// belt tensioner clamp
			translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset),0,0])
				cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset+0.1, x_carriage_belt_clamp_width, x_carriage_base_size[2]], vertical=[0,5,5,0]);
			// belt tensioner
			translate([-x_carriage_base_size[0]/2-(belt_width/2+x_carriage_tensioner_nut_support_outer_dia/2+x_carriage_belt_clamp_offset),-(x_carriage_base_size[1]/2-x_carriage_belt_support_width)/2-x_carriage_tensioner_nut_support_outer_dia/2,0]) cube_fillet([belt_width/2+x_carriage_tensioner_nut_support_outer_dia/2+x_carriage_belt_clamp_offset+x_carriage_tensioner_offset+0.1, x_carriage_tensioner_nut_support_outer_dia, x_carriage_tensioner_nut_support_thickness], vertical=[0,x_carriage_tensioner_nut_support_outer_dia/2,x_carriage_tensioner_nut_support_outer_dia/2,0], top=[0,0,0,x_carriage_tensioner_offset]);
			
			// belt clamp
			translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset),x_carriage_base_size[1]/2-x_carriage_belt_clamp_width,0]) cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset+x_carriage_belt_clamp_offset+0.1, x_carriage_belt_clamp_width, x_carriage_base_size[2]], vertical=[0,5,5,0]);
			
		}
		translate([0, -x_carriage_base_size[1]/2, 0]) {	
			translate([-x_carriage_fan[0]/2,0,0]){
				// fan screw hole
				translate([0, 0, x_carriage_fan_nut_height]) rotate([-90,0,0]) screw_hole(type=x_carriage_fan_screw, h=x_carriage_fan_nut_wall_thickness, $fn=8, horizontal=true);
				// fan nut hole
				translate([0, x_carriage_fan_nut_wall, x_carriage_fan_nut_height]) rotate([-90,0,0]) rotate([0,0,90]) nut_hole(type=x_carriage_fan_nut, nut_slot=x_carriage_fan_nut_height, horizontal=true);
			}
			translate([x_carriage_fan[0]/2,0,0]){
				// fan screw hole
				translate([0,0, x_carriage_fan_nut_height]) rotate([-90,0,0]) screw_hole(type=x_carriage_fan_screw, h=x_carriage_fan_nut_wall_thickness, $fn=8, horizontal=true);
				// fan nut hole		
				translate([0,x_carriage_fan_nut_wall, x_carriage_fan_nut_height]) rotate([-90,0,0]) rotate([0,0,90]) nut_hole(type=x_carriage_fan_nut, nut_slot=x_carriage_fan_nut_height, horizontal=true);
			}
		}
		translate([0, x_carriage_base_size[1]/2-x_carriage_fan_nut_wall_thickness, 0]) {	
			translate([-x_carriage_fan[0]/2,0,0]){
				// fan screw hole
				translate([0, 0, x_carriage_fan_nut_height]) rotate([-90,0,0]) screw_hole(type=x_carriage_fan_screw, h=x_carriage_fan_nut_wall_thickness, $fn=8, horizontal=true);
				// fan nut hole
				translate([0, x_carriage_fan_nut_wall, x_carriage_fan_nut_height]) rotate([-90,0,0]) rotate([0,0,90]) nut_hole(type=x_carriage_fan_nut, nut_slot=x_carriage_fan_nut_height, horizontal=true);
			}
			translate([x_carriage_fan[0]/2,0,0]){
				// fan screw hole
				translate([0,0, x_carriage_fan_nut_height]) rotate([-90,0,0]) screw_hole(type=x_carriage_fan_screw, h=x_carriage_fan_nut_wall_thickness, $fn=8, horizontal=true);
				// fan nut hole		
				translate([0,x_carriage_fan_nut_wall, x_carriage_fan_nut_height]) rotate([-90,0,0]) rotate([0,0,90]) nut_hole(type=x_carriage_fan_nut, nut_slot=x_carriage_fan_nut_height, horizontal=true);
			}
		}
		
		// belt clamp tensioner slide through hole
		//translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset),-x_carriage_base_size[1]/2-0.1,-0.01]) cube([belt_width, x_carriage_belt_support_width+0.2, belt[3]]);
		translate([-x_carriage_base_size[0]/2-(x_carriage_belt_clamp_offset),-x_carriage_base_size[1]/2+x_carriage_belt_support_width,0]) rotate([90,0,-90]) fillet_linear_i(belt_width, fillet_r=2, fillet_angle=90, fillet_fn=2);
		
		// belt clamp tensioner alignment hole
		translate([-x_carriage_base_size[0]/2+x_carriage_belt_clamp_screw_offset-screw_dia(v_screw_hole(x_carriage_belt_clamp_screw))/2,-x_carriage_base_size[1]/2+x_carriage_belt_support_width/4,-0.01]) cube_fillet([screw_dia(v_screw_hole(x_carriage_belt_clamp_screw)), x_carriage_belt_support_width/2, x_carriage_base_size[2]-1], vertical=[1.25,1.25,1.25,1.25]);
		// belt clamp tensioner alignment screw hole
		translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset+x_carriage_belt_clamp_screw_offset),-x_carriage_base_size[1]/2+x_carriage_belt_support_width/2,0]) screw_hole(type=x_carriage_belt_clamp_screw);
		
		// belt clamp tensioner teeth
		translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset),-0.1,-0.1]) cube([belt_width, x_carriage_belt_clamp_width+0.2, belt[4]]);
		// belt clamp tensioner screw
		translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset+x_carriage_belt_clamp_screw_offset),x_carriage_belt_clamp_width/2,0]) screw_hole(type=x_carriage_belt_clamp_screw);
		// belt clamp tensioner screw inside
		translate([-x_carriage_base_size[0]/2-x_carriage_belt_clamp_offset+x_carriage_belt_clamp_screw_offset,x_carriage_belt_clamp_width/2,0]) screw_hole(type=x_carriage_belt_clamp_screw);
		
		// belt tensioner nut
		translate([-x_carriage_base_size[0]/2-(belt_width/2+x_carriage_belt_clamp_offset),-(x_carriage_base_size[1]/2-x_carriage_belt_support_width)/2,x_carriage_tensioner_nut_support_thickness+0.01]) rotate([0,180,0]) nut_hole(type=x_carriage_tensioner_nut);
		// belt tensioner screw
		translate([-x_carriage_base_size[0]/2-(belt_width/2+x_carriage_belt_clamp_offset),-(x_carriage_base_size[1]/2-x_carriage_belt_support_width)/2,0]) screw_hole(type=x_carriage_tensioner_screw);
		
		// belt clamp teeth
		//translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset),x_carriage_base_size[1]/2-x_carriage_belt_clamp_width-0.1,x_carriage_base_size[2]+0.1-belt[4]]) cube([belt_width, x_carriage_belt_clamp_width+0.2, belt[4]]);
		translate([-x_carriage_base_size[0]/2-(x_carriage_belt_clamp_offset),x_carriage_base_size[1]/2-x_carriage_belt_clamp_width-0.1,-0.01]) rotate([0,0,90]) belt_teeth_cutout(distance=x_carriage_belt_clamp_width, center=false);
		// belt clamp screw
		translate([-x_carriage_base_size[0]/2-(belt_width+x_carriage_belt_clamp_offset+x_carriage_belt_clamp_screw_offset),x_carriage_base_size[1]/2-x_carriage_belt_clamp_width/2,0]) screw_hole(type=x_carriage_belt_clamp_screw);
		// belt clamp alignment hole
		translate([-x_carriage_base_size[0]/2+x_carriage_belt_clamp_screw_offset-screw_dia(v_screw_hole(x_carriage_belt_clamp_screw))/2,x_carriage_base_size[1]/2-x_carriage_belt_clamp_width/2-x_carriage_belt_clamp_width/4,-0.01]) cube_fillet([screw_dia(v_screw_hole(x_carriage_belt_clamp_screw)), x_carriage_belt_clamp_width/2, x_carriage_base_size[2]-1], vertical=[1.25,1.25,1.25,1.25]);
		
		// end stop flag screw
		translate([x_carriage_base_size[0]/2,x_carriage_base_size[1]/2,0])
			translate([(end_stop_mount_thickness+end_stop_size[1]/2),0,(bushing_x[1]+x_carriage_base_size[2]+0.1-(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2-end_stop_button_loc_from_screw)]) {
			 	rotate([90,0,0]) screw_hole(type=end_stop_flag_screw, h=15, $fn=8);
			 	rotate([90,0,0]) translate ([0,0,5]) nut_hole(type=end_stop_flag_nut, nut_slot=10, horizontal=true);
			}
		
		// Extruder Mounting Holes
		for (i=[0:1])
			rotate(180*i)
			for (hole=[-1:1])
				rotate(hole*22)
				translate([0,x_extruder_mount_screw_spacing/2,-0.1])
				screw_hole(type=x_extruder_mount_screw, h=(x_carriage_base_size[2]+x_carriage_base_size[2]+0.2));
		
		// Hotend Hole
		translate([0,0,-0.1]) cylinder_poly(r=x_extruder_mount_hole_diameter/2,h=(x_carriage_base_support_thickness+x_carriage_base_size[2]+0.2));
	}
}

module belt_teeth_cutout(distance=30, center=true) {
	union(){
		translate([(center) ? -(distance-belt[0]/2)/2 : belt[0]/4, (center) ? 0 : (belt_width+0.1)/2, (center) ? 0 : (belt[2]+0.1)/2]) {
			for (i = [0 : distance/belt[0]-1+((distance%belt[0])/(distance%belt[0]+1))]) {
				translate([(belt[0]*belt[1])/2+i*belt[0], 0, 0]) cube([belt[0]*belt[1], (belt_width+0.1), (belt[2]+0.1)], center = true);
			}
		}
	}
}

module x_carriage_tensioner_belt_clamp() {
	difference() {
		cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2, x_carriage_belt_clamp_width, x_carriage_belt_clamp_thickness], vertical=[5,5,5,5]);
		translate([x_carriage_belt_clamp_nut_support_outer_dia, x_carriage_belt_clamp_width/2, 0]) screw_hole(type=x_carriage_belt_clamp_screw);
		translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset*2+belt_width, x_carriage_belt_clamp_width/2, 0]) screw_hole(type=x_carriage_belt_clamp_screw);
		translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset, 0, x_carriage_belt_clamp_thickness+0.01]) rotate([180,0,90]) belt_teeth_cutout(distance=x_carriage_belt_clamp_width,center=false);
	}
}

module x_carriage_belt_clamp() {
	difference() {
		union() {
			cube_fillet([belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2+x_carriage_belt_clamp_offset, x_carriage_belt_clamp_width, x_carriage_belt_clamp_thickness], vertical=[5,5,5,5]);
			translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset*2+belt_width+x_carriage_belt_clamp_offset, x_carriage_belt_clamp_width/2, x_carriage_belt_clamp_thickness+(x_carriage_base_size[2]-1.5)/2-0.01]) cube_fillet([screw_dia(x_carriage_belt_clamp_screw)-0.1, x_carriage_belt_clamp_width/2, x_carriage_base_size[2]-1.5], vertical=[1.25,1.25,1.25,1.25], top=[0.5,0.5,0.5,0.5],center=true);
		}
		translate([x_carriage_belt_clamp_nut_support_outer_dia, x_carriage_belt_clamp_width/2, 0]) screw_hole(type=x_carriage_belt_clamp_screw);
		translate([x_carriage_belt_clamp_nut_support_outer_dia+x_carriage_belt_clamp_screw_offset, -0.1, x_carriage_belt_clamp_thickness-belt[4]+0.01]) cube([belt_width, x_carriage_belt_clamp_width+0.2, belt[4]]);
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

translate([-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2+x_carriage_belt_clamp_offset)/2,8,0]) x_carriage_tensioner_clamp();
translate([-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2+x_carriage_belt_clamp_offset)/2,-5,0]) x_carriage_belt_clamp();
translate([-(belt_width+x_carriage_belt_clamp_nut_support_outer_dia*2+x_carriage_belt_clamp_screw_offset*2)/2,-18,0]) x_carriage_tensioner_belt_clamp();
x_carriage();
//belt_teeth_cutout(center=true);