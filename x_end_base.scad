include <configuration.scad>
use <bushing.scad>
use <inc/drivetrain.scad>
include <inc/nuts_screws.scad>;

module x_end_base(vertical=[5,5,5,5], top=[0,0,0,0]) {
	//X end block
	difference(){
		union(){
			translate([0,0,base_size[2]/2]) cube_fillet(base_size, center=true, vertical=vertical, top=top);	//Main block
			translate([0,base_size[1]/2-y_offset,0]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=base_size[2]);
			translate([-(bushing_mount_hole_spacing+12)/2,0,base_size[2]-0.01]) bushing_mount_wall();
		}
		
		translate([0,base_size[1]/2-y_offset,0]) screw_hole(type=lead_screw, h=base_size[2], allowance=1);
		
		translate([0,base_size[1]/2-lead_screw_to_smooth_rod_separation-y_offset,-0.5]) rotate([0,0,-90]) rod_hole(d=z_axis_smooth_rod_diameter+2,h=base_size[2]+1, length=base_size[1]-lead_screw_to_smooth_rod_separation);
		
		translate([x_axis_smooth_rod_separation/2,0,-base_clamp_gap/2]) rotate([90,0,0]) rod_hole(d=x_axis_smooth_rod_diameter, h=base_size[1]+1, $fn=8, center=true);
		translate([-x_axis_smooth_rod_separation/2,0,-base_clamp_gap/2]) rotate([90,0,0]) rod_hole(d=x_axis_smooth_rod_diameter, h=base_size[1]+1, $fn=8, center=true);
	}
}

module bushing_mount_wall() {
		intersection() {
			cube([bushing_mount_hole_spacing+12, 12, bushing_holder_height+1.01]);
			translate([(bushing_mount_hole_spacing+12)/2,-40,-1]) cylinder_poly(r=52,h=bushing_holder_height+3);
		}
}
	//translate([0,0,base_size[2]+1]) {
module bushing_mount_screws(screw_length=12) {
		// screw holes
		translate([bushing_mount_hole_spacing/2, screw_length, bushing_holder_height-6]) rotate([90, 0, 0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1);
		translate([-bushing_mount_hole_spacing/2, screw_length, bushing_holder_height-6]) rotate([90, 0,0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1);
		translate([bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0, 0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1);
       	translate([-bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0,0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1);
			
		// Nut traps
		translate([bushing_mount_hole_spacing/2, screw_length, bushing_holder_height-6]) rotate([90, 0, 0]) nut_hole(type=bushing_mounting_nut, h=screw_length-6);
		translate([-bushing_mount_hole_spacing/2, screw_length, bushing_holder_height-6]) rotate([90, 0,0]) nut_hole(type=bushing_mounting_nut, h=screw_length-6);
		translate([bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0, 0]) nut_hole(type=bushing_mounting_nut, h=screw_length-6);
       	translate([-bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0,0]) nut_hole(type=bushing_mounting_nut, h=screw_length-6);
}

module x_end_idler() {
	//X end block
	union() {
	difference(){
		union(){
			x_end_base(vertical=[0,5,5,0], top=[0,5,0,0]);
			translate([0,base_size[1]/2-y_offset,base_size[2]-0.01]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=20.01);
			
			// idler wall
			translate([base_size[0]/2-idler_wall_thickness/2,0,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([idler_wall_thickness,base_size[1],idler_wall_height-base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(idler_bearing)/2,0,bearing_out_dia(idler_bearing)/2,0]);	//idler wall
			translate([(base_size[0]/2)+1, screw_dia(v_screw_hole(idler_screw, $fn=8))/2, idler_height]) rotate([0,-90,0]) rotate([0,0,180/8]) cylinder_poly(r1=screw_dia(v_screw_hole(idler_screw, $fn=8))*cos(180/8)/2+2,r2=screw_dia(v_screw_hole(idler_screw, $fn=8))*cos(180/8)/2+3.5, h=1.1, $fn=8);
			
			// outside idler wall
			translate([base_size[0]/2+idler_wall_thickness/2+2+bearing_width(idler_bearing)+0.1,0,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([idler_wall_thickness,base_size[1],idler_wall_height-base_size[2]+0.01], center=true, vertical=[5,0,0,5], top=[bearing_out_dia(idler_bearing)/2,0,bearing_out_dia(idler_bearing)/2,0]);	//idler wall
			translate([(base_size[0]/2)+2+bearing_width(idler_bearing)+0.1, screw_dia(v_screw_hole(idler_screw, $fn=8))/2, idler_height]) rotate([0,-90,0]) rotate([0,0,180/8]) cylinder_poly(r2=screw_dia(v_screw_hole(idler_screw, $fn=8))*cos(180/8)/2+2,r1=screw_dia(v_screw_hole(idler_screw, $fn=8))*cos(180/8)/2+3.5, h=1.1, $fn=8);
			
			// idler wall bottom support
			translate([base_size[0]/2+(idler_wall_thickness+2+bearing_width(idler_bearing)+0.1)/2,0,base_size[2]/2]) cube_fillet([idler_wall_thickness+2+bearing_width(idler_bearing)+0.1,base_size[1],base_size[2]], center=true, vertical=[5,0,0,5]);
			
			// idler wall rear support
			translate([base_size[0]/2+(2+bearing_width(idler_bearing)+0.1)/2,-base_size[1]/2+idler_wall_thickness/2,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([2+bearing_width(idler_bearing)+0.1,idler_wall_thickness,idler_wall_height-base_size[2]+0.01], vertical=[0,0,0,0], top=[0,0,bearing_out_dia(idler_bearing)/2,0], center=true);
			
			//translate([base_size[0]/2-3,0,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([6,base_size[1],idler_wall_height-base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(idler_bearing)/2,0,bearing_out_dia(idler_bearing)/2,0]);	//idler wall
			
			//front idler wall bridge
			difference() {
				translate([base_size[0]/2-idler_wall_thickness-7,base_size[1]/4,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([14,base_size[1]/2,idler_wall_height-base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(idler_bearing)/2,0,0,0]);	//idler wall
				translate([base_size[0]/2-idler_wall_thickness-12-1,base_size[1]/2+3,base_size[2]-0.005]) cylinder_poly(r=13.5, h=idler_wall_height-base_size[2]+0.01);	//idler wall
			}
			//rear idler wall bridge
			difference() {
				translate([base_size[0]/2-idler_wall_thickness-6.65/2,-base_size[1]/4,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([6.65,base_size[1]/2,idler_wall_height-base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[0,0,bearing_out_dia(idler_bearing)/2,0]);	//idler wall
				translate([0,-base_size[1]/2-3,base_size[2]-0.005]) cylinder_poly(r=28, h=idler_wall_height-base_size[2]+0.01);	//idler wall
			}
		}
		translate([0,0,base_size[2]+1]) bushing_mount_screws(screw_length=12);
		
		// idler screw hole
		translate([(base_size[0]/2+idler_wall_thickness+2+bearing_width(idler_bearing)+0.1), screw_dia(v_screw_hole(idler_screw, $fn=8))/2, idler_height]) rotate([0,-90,0]) screw_hole(type=idler_screw, h=12+idler_wall_thickness*2+2+bearing_width(idler_bearing)+0.1, $fn=8);
		
		// cutout for screw hole
		translate([(base_size[0]/2)-12/2-idler_wall_thickness-0.01, screw_dia(v_screw_hole(idler_screw, $fn=8))/4, idler_height]) cube([12,screw_dia(v_screw_hole(idler_screw, $fn=8))/2+0.02,screw_dia(v_screw_hole(idler_screw, $fn=8))*cos(180/8)],center=true);
		
		// idler nut trap
		translate([(base_size[0]/2)-idler_wall_thickness -0.01, screw_dia(v_screw_hole(idler_screw, $fn=8))/2, idler_height]) rotate([-90,0,90]) nut_slot_hole(type=idler_nut, h=17);
		
		// Lead screw hole and anti-backlash nut
		translate([0,base_size[1]/2-y_offset,base_size[2]-0.01]) screw_hole(type=lead_screw, h=20.01, allowance=1);
		translate([0,base_size[1]/2-y_offset,base_size[2]+0.01]) nut_hole(type=lead_screw_nut, h=bushing_holder_height+1.01);

		// rod clamp screw holes		
		translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		
		translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
	}
	// support wall for idler hole
	translate([base_size[0]/2-idler_wall_thickness-nut_thickness(v_nut_hole(idler_nut))-(12-nut_thickness(v_nut_hole(idler_nut))+0.1)/2, (single_wall_width+0.1)/2, idler_height]) cube([12-nut_thickness(v_nut_hole(idler_nut))+0.1,single_wall_width+0.1,screw_dia(v_screw_hole(idler_screw, $fn=8))],center=true);
	}
}

module x_end_motor() {
	motor_loc=-base_size[1]/2+bushing_mount_thickness+bushing[1]*2+screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8))/2 + 0.3 +hole_fit(nut_outer_dia(v_nut_hole(nut_M3))+0.5)/2+2;
	
	//X end block
	difference(){
		union(){
			x_end_base(vertical=[5,5,0,5], top=[0,0,0,5]);
			translate([0,base_size[1]/2-y_offset,base_size[2]-0.01]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=20.01);
			
			// motor mount
			translate([-base_size[0]/2+motor_wall_thickness,-base_size[1]/2-stepper_motor_padded/2-motor_loc,(stepper_motor_padded)/2+motor_support_height]) rotate([0, -90, 0]) motor_plate(thickness=motor_wall_thickness, width=stepper_motor_padded+0.1, slot_length=0, vertical=[0,0,0,0], head_drop=1, $fn=12);
			
			// motor mount supports
			translate([-base_size[0]/2,-base_size[1]/2-motor_loc+0.1/2,0]) cube_fillet([motor_wall_thickness,motor_loc+0.1,stepper_motor_padded+motor_support_height+0.1/2], vertical=[0,0,0,0], top=[4.5,0,0,0], $fn=1);
			
			translate([-base_size[0]/2,-base_size[1]/2-motor_loc,0]) cube_fillet([base_size[0]/2-z_axis_smooth_rod_diameter/2-1-rod_hole_allowance/2,motor_loc+0.1,base_size[2]], vertical=[0,0,0,0], top=[0,0,base_size[2]-motor_support_height,0], $fn=1);
			
			translate([-base_size[0]/2,-base_size[1]/2-motor_loc-stepper_motor_padded-0.1/2 - motor_wall_thickness,0]) cube_fillet([base_size[0]/2-z_axis_smooth_rod_diameter/2-1-rod_hole_allowance/2,stepper_motor_padded+0.1+motor_wall_thickness,motor_support_height], vertical=[0,0,0,base_size[0]/2-z_axis_smooth_rod_diameter/2-1-rod_hole_allowance/2-motor_wall_thickness], top=[0,0,0,0], $fn=1);
			
			translate([-base_size[0]/2,-base_size[1]/2-motor_loc-stepper_motor_padded-0.1/2-motor_wall_thickness,0]) cube_fillet([motor_wall_thickness*2,motor_wall_thickness,motor_support_height+stepper_motor_padded+0.1/2], vertical=[2,0,0,motor_wall_thickness], top=[0,0,motor_wall_thickness,motor_wall_thickness], $fn=1);
			
			//rear idler wall bridge
			difference() {
				translate([-base_size[0]/2+idler_wall_thickness+(6.65-idler_wall_thickness)/2,(-base_size[1]/2+7)/2,idler_wall_height/2+base_size[2]/2-0.005]) cube_fillet([6.65+idler_wall_thickness,base_size[1]/2+7,idler_wall_height-base_size[2]+0.01], center=true, vertical=[0,11,0,0], top=[0,0,0,0]);	//idler wall
				translate([0,-base_size[1]/2-3,base_size[2]-0.005]) cylinder_poly(r=28, h=idler_wall_height-base_size[2]+0.01);	//idler wall
			}
		}
		translate([0,0,base_size[2]+1]) bushing_mount_screws(screw_length=12);
		
		// Lead screw hole and anti-backlash nut
		translate([0,base_size[1]/2-y_offset,base_size[2]-0.01]) screw_hole(type=lead_screw, h=20.01, allowance=1);
		translate([0,base_size[1]/2-y_offset,base_size[2]+0.01]) nut_hole(type=lead_screw_nut, h=bushing_holder_height+1.01);

		// rod clamp screw holes		
		translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		
		translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
		translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,base_size[2]]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=screw_head_height(smooth_rod_clamp_screw));
	}
}

module x_end_bottom() {
	difference() {
		union() {
			x_end_base(top=[0,5,0,5]);
			translate([0,base_size[1]/2-y_offset,-base_clamp_gap/2+nut_thickness(v_nut_hole(lead_screw_nut))]) cylinder_poly(r=screw_dia(v_screw_hole(lead_screw))/2+1, h=layer_height);
		}
		translate([0,0,base_size[2]+1]) bushing_mount_screws(screw_length=12);
		
		// rod clamp screw holes
		translate([0,0,base_size[2]]) {
			translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=0);
			translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=0);
				
			translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=0);
			translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=base_size[2], head_drop=0);
			
			// nut traps
			translate([0,0,0.01]) {
				translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut);
				translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut);
				
				translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut);
				translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,0]) rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut);
			}
		}
		
		translate([0,base_size[1]/2-y_offset,-base_clamp_gap/2]) nut_hole(type=lead_screw_nut);
	}
}

/*
translate([0,0,-base_clamp_gap]) rotate([0,180,0]) x_end_bottom();
translate([0,base_size[1]/2-lead_screw_to_smooth_rod_separation-y_offset,-(bushing_holder_height/2+base_size[2]+1)-base_clamp_gap]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=bushing_holder_height);

//%translate([(base_size[0]/2)+1+bearing_width(idler_bearing), screw_dia(v_screw_hole(idler_screw, $fn=8))/2, idler_height]) rotate([0,-90,0]) idler(idler_bearing=idler_bearing);
x_end_idler();
translate([0,base_size[1]/2-lead_screw_to_smooth_rod_separation-y_offset,bushing_holder_height/2+base_size[2]+1]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=bushing_holder_height);
*/
translate([0,base_size[1]/2-lead_screw_to_smooth_rod_separation-y_offset,bushing_holder_height/2+base_size[2]+1]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=bushing_holder_height);

x_end_motor();