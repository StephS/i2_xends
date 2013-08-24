include <configuration.scad>
use <bushing.scad>
use <end_stop_holder.scad>
use <inc/drivetrain.scad>
include <inc/nuts_screws.scad>;

z_end_stop_loc_y= (x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset)+(v_rod_hole(d=z_axis_smooth_rod_diameter)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness)-end_stop_mount_thickness-end_stop_size[1]/2;
z_end_stop_loc_x=-(-(v_rod_hole(d=z_axis_smooth_rod_diameter)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness)-end_stop_plate_size[0]-end_stop_plate_offset)-(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2-end_stop_button_loc_from_screw;

module x_end_base(vertical=[5,5,5,5], top=[0,0,0,0]) {
	//X end block
	difference(){
		union(){
			translate([0,0,x_end_base_size[2]/2]) cube_fillet(x_end_base_size, center=true, vertical=vertical, top=top);	//Main block
			translate([0,x_end_base_size[1]/2-lead_screw_y_offset,0]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=x_end_base_size[2]);
			translate([-(x_end_bushing_mount_wall_width)/2,0,x_end_base_size[2]-0.01]) bushing_mount_wall();
		}
		
		translate([0,x_end_base_size[1]/2-lead_screw_y_offset,0]) screw_hole(type=lead_screw, h=x_end_base_size[2], allowance=1);
		
		translate([0,x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset,-0.5]) rotate([0,0,-90]) rod_hole(d=z_axis_smooth_rod_diameter+2,h=x_end_base_size[2]+1, length=x_end_base_size[1]-lead_screw_to_smooth_rod_separation);
		
		// smooth rod cutouts
		translate([x_axis_smooth_rod_separation/2,0,-x_end_base_clamp_gap/2]) rotate([90,0,0]) rotate([0,0,18]) rod_hole(d=x_axis_smooth_rod_diameter, h=x_end_base_size[1]+1, $fn=10, center=true, horizontal=true);
		translate([-x_axis_smooth_rod_separation/2,0,-x_end_base_clamp_gap/2]) rotate([90,0,0]) rotate([0,0,18]) rod_hole(d=x_axis_smooth_rod_diameter, h=x_end_base_size[1]+1, $fn=10, center=true, horizontal=true);
	}
}

module bushing_mount_wall() {
		intersection() {
			cube([x_end_bushing_mount_wall_width, 12, z_bushing_foot_height+1.01]);
			translate([(x_end_bushing_mount_wall_width)/2,12-sagitta_radius(5, x_end_bushing_mount_wall_width/2),-1]) cylinder_poly(r=sagitta_radius(5, x_end_bushing_mount_wall_width/2),h=z_bushing_foot_height+3);
		}
}
	//translate([0,0,x_end_base_size[2]+1]) {
module bushing_mount_screws(screw_length=12) {
		// screw holes
		translate([x_end_bushing_mount_hole_spacing/2, screw_length, z_bushing_foot_height-6]) rotate([90, 0, 0]) screw_hole(type=z_bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1, horizontal=true);
		translate([-x_end_bushing_mount_hole_spacing/2, screw_length, z_bushing_foot_height-6]) rotate([90, 0,0]) screw_hole(type=z_bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1, horizontal=true);
		translate([x_end_bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0, 0]) screw_hole(type=z_bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1, horizontal=true);
       	translate([-x_end_bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0,0]) screw_hole(type=z_bushing_mounting_screw, head_drop=0, $fn=8, h=screw_length+1, horizontal=true);
			
		// Nut traps
		translate([x_end_bushing_mount_hole_spacing/2, screw_length, z_bushing_foot_height-6]) rotate([90, 0, 0]) nut_hole(type=z_bushing_mounting_nut, thickness=screw_length-6, horizontal=true);
		translate([-x_end_bushing_mount_hole_spacing/2, screw_length, z_bushing_foot_height-6]) rotate([90, 0,0]) nut_hole(type=z_bushing_mounting_nut, thickness=screw_length-6, horizontal=true);
		translate([x_end_bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0, 0]) nut_hole(type=z_bushing_mounting_nut, thickness=screw_length-6, horizontal=true);
       	translate([-x_end_bushing_mount_hole_spacing/2, screw_length, 6]) rotate([90, 0,0]) nut_hole(type=z_bushing_mounting_nut, thickness=screw_length-6, horizontal=true);
}

module rod_clamp_screws(nuts=false) {
	head_drop=(z_bushing_foot_height+1.02);
	
	translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+((nuts) ? 0 : head_drop)])
		rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=x_end_base_size[2], head_drop=((nuts) ? 0 : (screw_head_height(smooth_rod_clamp_screw)+head_drop)), allowance=screw_hole_allowance_vertical*2.5);
	translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+((nuts) ? 0 : head_drop)]) 
		rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=x_end_base_size[2], head_drop=((nuts) ? 0 : (screw_head_height(smooth_rod_clamp_screw)+head_drop)), allowance=screw_hole_allowance_vertical*2.5);
			
	translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+((nuts) ? 0 : head_drop)]) 
		rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=x_end_base_size[2], head_drop=((nuts) ? 0 : (screw_head_height(smooth_rod_clamp_screw)+head_drop)), allowance=screw_hole_allowance_vertical*2.5);
	translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+((nuts) ? 0 : head_drop)]) 
		rotate ([180,0,0]) screw_hole(type=smooth_rod_clamp_screw, h=x_end_base_size[2], head_drop=((nuts) ? 0 : (screw_head_height(smooth_rod_clamp_screw)+head_drop)), allowance=screw_hole_allowance_vertical*2.5);
	if (nuts) {
		render() translate([smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+head_drop])
			rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut, thickness=nut_thickness(v_nut_hole(smooth_rod_clamp_nut))+head_drop);
		render() translate([-smooth_rod_clamp_screw_hole_spacing_x/2,smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+head_drop]) 
			rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut, thickness=nut_thickness(v_nut_hole(smooth_rod_clamp_nut))+head_drop);
				
		render() translate([-smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+head_drop]) 
			rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut, thickness=nut_thickness(v_nut_hole(smooth_rod_clamp_nut))+head_drop);
		render() translate([smooth_rod_clamp_screw_hole_spacing_x/2,-smooth_rod_clamp_screw_hole_spacing_y/2,x_end_base_size[2]+head_drop]) 
			rotate ([180,0,0]) nut_hole(type=smooth_rod_clamp_nut, thickness=nut_thickness(v_nut_hole(smooth_rod_clamp_nut))+head_drop);
		
	}
}

module x_end_idler() {
	//X end block
	union() {
	difference(){
		union(){
			x_end_base(vertical=[0,5,5,0], top=[0,5,0,0]);
			translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]-0.01]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=20.01);
			
			// idler wall
			translate([x_end_base_size[0]/2-x_end_idler_wall_thickness/2,0,x_end_idler_wall_height/2+x_end_base_size[2]/2-0.005]) cube_fillet([x_end_idler_wall_thickness,x_end_base_size[1],x_end_idler_wall_height-x_end_base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(x_end_idler_bearing)/2,0,bearing_out_dia(x_end_idler_bearing)/2,0]);	//idler wall
			//#translate([(x_end_base_size[0]/2)+1, screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([0,-90,0]) rotate([0,0,180/8]) cylinder_poly(r1=screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))*cos(180/8)/2+2,r2=screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))*cos(180/8)/2+3.5, h=1.1, $fn=8);
			
			// outside idler wall
			translate([x_end_base_size[0]/2+x_end_idler_wall_thickness/2+washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1,0,x_end_idler_wall_height/2+x_end_base_size[2]/2-0.005]) cube_fillet([x_end_idler_wall_thickness,x_end_base_size[1],x_end_idler_wall_height-x_end_base_size[2]+0.01], center=true, vertical=[5,0,0,5], top=[bearing_out_dia(x_end_idler_bearing)/2,0,bearing_out_dia(x_end_idler_bearing)/2,0]);	//idler wall
			//#translate([(x_end_base_size[0]/2)+2+bearing_width(x_end_idler_bearing)+0.1, screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([0,-90,0]) rotate([0,0,180/8]) cylinder_poly(r2=screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))*cos(180/8)/2+2,r1=screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))*cos(180/8)/2+3.5, h=1.1, $fn=8);
			
			// idler wall bottom support
			translate([x_end_base_size[0]/2+(x_end_idler_wall_thickness+washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1)/2-0.05,0,x_end_base_size[2]/2]) cube_fillet([x_end_idler_wall_thickness+washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1+0.1,x_end_base_size[1],x_end_base_size[2]], center=true, vertical=[5,0,0,5]);
			
			// idler wall rear support
			translate([x_end_base_size[0]/2+(washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1)/2,-x_end_base_size[1]/2+x_end_idler_wall_thickness/2,x_end_idler_wall_height/2+x_end_base_size[2]/2-0.005]) cube_fillet([washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1,x_end_idler_wall_thickness,x_end_idler_wall_height-x_end_base_size[2]+0.01], vertical=[0,0,0,0], top=[0,0,bearing_out_dia(x_end_idler_bearing)/2,0], center=true);
			
			//translate([x_end_base_size[0]/2-3,0,x_end_idler_wall_height/2+x_end_base_size[2]/2-0.005]) cube_fillet([6,x_end_base_size[1],x_end_idler_wall_height-x_end_base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(x_end_idler_bearing)/2,0,bearing_out_dia(x_end_idler_bearing)/2,0]);	//idler wall
			
			//front idler wall bridge
			difference() {
				translate([x_end_base_size[0]/2-x_end_idler_wall_thickness-7,x_end_base_size[1]/4,x_end_idler_wall_height/2+x_end_base_size[2]/2-0.005]) cube_fillet([14,x_end_base_size[1]/2,x_end_idler_wall_height-x_end_base_size[2]+0.01], center=true, vertical=[0,0,0,0], top=[bearing_out_dia(x_end_idler_bearing)/2,0,0,0]);	//idler wall
				translate([x_end_base_size[0]/2-x_end_idler_wall_thickness-12-1,x_end_base_size[1]/2+3,x_end_base_size[2]-0.005]) cylinder_poly(r=13.5, h=x_end_idler_wall_height-x_end_base_size[2]+0.01);	//idler wall
			}
			//rear idler wall bridge
			difference() {
				translate([x_end_base_size[0]/2-x_end_idler_wall_thickness-((x_end_base_size[0] - x_end_bushing_mount_wall_width)/2 - x_end_idler_wall_thickness)-0.4,-x_end_base_size[1]/2,x_end_base_size[2]-0.01])
					cube_fillet([ (x_end_base_size[0] - x_end_bushing_mount_wall_width)/2 - x_end_idler_wall_thickness +0.5,x_end_base_size[1]/2,x_end_idler_wall_height-x_end_base_size[2]+0.01], vertical=[0,0,0,0], top=[0,0,bearing_out_dia(x_end_idler_bearing)/2,0]);	//idler wall
				translate([x_end_base_size[0]/2-x_end_idler_wall_thickness-sagitta_radius((x_end_base_size[0] - x_end_bushing_mount_wall_width)/2 - x_end_idler_wall_thickness, x_end_base_size[1]/2-z_bushing_mount_thickness),-x_end_base_size[1]/2,x_end_base_size[2]-0.01])
					cylinder_poly(r=sagitta_radius((x_end_base_size[0] - x_end_bushing_mount_wall_width)/2 - x_end_idler_wall_thickness, x_end_base_size[1]/2-z_bushing_mount_thickness), h=x_end_idler_wall_height-x_end_base_size[2]+0.02);
				//cylinder_poly(r=28, h=x_end_idler_wall_height-x_end_base_size[2]+0.01);	//idler wall
			}
		}
		translate([0,0,x_end_base_size[2]+1]) bushing_mount_screws(screw_length=12);
		
		// idler screw hole
		#translate([(x_end_base_size[0]/2+x_end_idler_wall_thickness+2+bearing_width(x_end_idler_bearing)+0.1)+washer_thickness(x_end_idler_washer)*2, screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([0,-90,0]) screw_hole(type=x_end_idler_screw, h=12+x_end_idler_wall_thickness*2+washer_thickness(x_end_idler_washer)*2+bearing_width(x_end_idler_bearing)+0.1, $fn=8);
		
		// cutout for screw hole
		translate([(x_end_base_size[0]/2)-12/2-x_end_idler_wall_thickness-0.01, screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/4, x_end_idler_height]) cube([12,screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2+0.02,screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))*cos(180/8)],center=true);
		
		// idler nut trap
		translate([(x_end_base_size[0]/2)-x_end_idler_wall_thickness -0.01, screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([-90,0,90]) nut_hole(type=x_end_idler_nut, nut_slot=17);
		
		// Lead screw hole and anti-backlash nut
		translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]-0.01]) screw_hole(type=lead_screw, h=20.01, allowance=1);
		translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]+0.01]) nut_hole(type=lead_screw_nut, thickness=z_bushing_foot_height+1.01, allowance=nut_hole_allowance_vertical*2.5);

		// rod clamp screw holes		
		translate([0,0,0]) rod_clamp_screws(nuts=false);
	}
	// support wall for idler hole
	translate([(x_end_bushing_mount_wall_width/2)-0.4-((12+x_end_idler_wall_thickness)-(x_end_base_size[0]/2-x_end_bushing_mount_wall_width/2))-0.1, 0, x_end_idler_height-nut_flat(v_nut_hole(x_end_idler_nut))/2])
		cube([(12+x_end_idler_wall_thickness)-(x_end_base_size[0]/2-x_end_bushing_mount_wall_width/2)+0.1, single_wall_width+0.1, nut_flat(v_nut_hole(x_end_idler_nut))]);
	}
}

module x_end_motor() {
	motor_loc=-x_end_base_size[1]/2+z_bushing_mount_thickness+bushing_z[1]*2+screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8))/2 + 0.3 +hole_fit(nut_outer_dia(v_nut_hole(nut_M3))+0.5)/2+3;
	
	//X end block
	difference(){
		union(){
			x_end_base(vertical=[5,5,0,5], top=[0,0,0,5]);
			translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]-0.01]) cylinder_poly(r=lead_screw_nut_support_outer_dia/2, h=20.01);
			
			// motor mount
			translate([-x_end_base_size[0]/2+x_end_motor_wall_thickness,-x_end_base_size[1]/2-stepper_motor_padded/2-motor_loc,(stepper_motor_padded)/2+x_end_motor_support_height]) rotate([0, -90, 0]) motor_plate(thickness=x_end_motor_wall_thickness, width=stepper_motor_padded+0.1, slot_length=0, vertical=[0,0,0,0], head_drop=1, $fn=12);
			
			// motor mount supports
			translate([-x_end_base_size[0]/2,-x_end_base_size[1]/2-motor_loc+0.1/2,0]) cube_fillet([x_end_motor_wall_thickness,motor_loc+0.1,stepper_motor_padded+x_end_motor_support_height+0.1/2], vertical=[0,0,0,0], top=[3.5,0,0,0], $fn=1);
			
			// bottom step down
			translate([-x_end_base_size[0]/2,-x_end_base_size[1]/2-motor_loc,0]) cube_fillet([x_end_base_size[0]/2-v_rod_hole(d=z_axis_smooth_rod_diameter, $fn=10)/2-1,motor_loc+0.1,x_end_base_size[2]], vertical=[0,0,0,0], top=[0,0,x_end_base_size[2]-x_end_motor_support_height,0], $fn=1);
			
			// bottom support
			translate([-x_end_base_size[0]/2,-x_end_base_size[1]/2-motor_loc-stepper_motor_padded-0.1/2 - x_end_motor_wall_thickness,0]) cube_fillet([x_end_base_size[0]/2-v_rod_hole(d=z_axis_smooth_rod_diameter, $fn=10)/2-1,stepper_motor_padded+0.1+x_end_motor_wall_thickness,x_end_motor_support_height], vertical=[0,0,0,x_end_base_size[0]/2-v_rod_hole(d=z_axis_smooth_rod_diameter, $fn=10)/2-1-x_end_motor_wall_thickness], top=[0,0,0,0], $fn=1);
			
			// rear support
			translate([-x_end_base_size[0]/2,-x_end_base_size[1]/2-motor_loc-stepper_motor_padded-0.1/2-x_end_motor_wall_thickness,0]) cube_fillet([x_end_motor_wall_thickness*2,x_end_motor_wall_thickness,x_end_motor_support_height+stepper_motor_padded+0.1/2], vertical=[2,0,0,x_end_motor_wall_thickness], top=[0,0,x_end_motor_wall_thickness,x_end_motor_wall_thickness], top_fn=[0,0,0,0], vertical_fn=[1,0,0,1]);
			
			//front motor mount wall bridge
			difference() {
				translate([-x_end_base_size[0]/2, -x_end_base_size[1]/2-0.1, x_end_base_size[2]-0.01]) cube_fillet([(x_end_base_size[0]-x_end_bushing_mount_wall_width)/2+0.1, x_end_base_size[1]/2+7+0.1,x_end_idler_wall_height-x_end_base_size[2] + 0.01], vertical=[0,11,0,0], top=[0,0,0,0]);	//idler wall
				translate([-x_end_base_size[0]/2+sagitta_radius((x_end_base_size[0]-x_end_bushing_mount_wall_width)/2-x_end_motor_wall_thickness, x_end_base_size[1]/2+7-(z_bushing_mount_thickness+7))+x_end_motor_wall_thickness, -x_end_base_size[1]/2,x_end_base_size[2] -0.01])
				cylinder_poly(r=sagitta_radius((x_end_base_size[0]-x_end_bushing_mount_wall_width)/2-x_end_motor_wall_thickness, x_end_base_size[1]/2+7-(z_bushing_mount_thickness+7)), h=x_end_idler_wall_height-x_end_base_size[2]+0.02);	//idler wall
			}
			
			// x end stop
			translate([x_end_base_size[0]/2+end_stop_plate_size[1], x_end_base_size[1]/2-end_stop_plate_size[2],0]) rotate([0,0,90])
				end_stop_plate_vertical(size=[end_stop_plate_size[0],end_stop_plate_size[1]+nut_thickness(v_nut_hole(end_stop_mounting_nut)),end_stop_plate_size[2]], holes=false);
		
			difference () {
				union() {
					translate([x_end_base_size[0]/2-(end_stop_plate_size[1]+nut_thickness(v_nut_hole(end_stop_mounting_nut))), x_end_base_size[1]/2-end_stop_plate_size[2], 0])
						cube([end_stop_plate_size[1]+nut_thickness(v_nut_hole(end_stop_mounting_nut))+0.1,end_stop_plate_size[2],x_end_base_size[2]]);
				}
				
				translate([x_axis_smooth_rod_separation/2,0,-x_end_base_clamp_gap/2]) rotate([90,0,0]) rotate([0,0,18]) rod_hole(d=x_axis_smooth_rod_diameter+0.1, h=x_end_base_size[1]+10, $fn=10, center=true, horizontal=true);
			}
			
			
		}
		translate([0,0,x_end_base_size[2]+1]) bushing_mount_screws(screw_length=12);
		
		// holes for the endstop
		translate([x_end_base_size[0]/2+end_stop_plate_size[1], x_end_base_size[1]/2-end_stop_plate_size[2],0]) rotate([0,0,90])
				translate([(end_stop_plate_size[2]-end_stop_hole_spacing[1])/2+(end_stop_hole_spacing[1]),0,(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2]) {
					rotate([0,-90,0]) end_stop_screw_holes(h=end_stop_plate_size[1]+nut_thickness(v_nut_hole(end_stop_mounting_nut)), nut_drop=nut_thickness(v_nut_hole(end_stop_mounting_nut)), rotate_z=90, holes=[0,1,0,1], nuts=[0,1,0,1]);
					rotate([0,-90,0]) end_stop_screw_holes(h=end_stop_plate_size[1]+nut_thickness(v_nut_hole(end_stop_mounting_nut))+2, rotate_z=90, holes=[1,0,1,0], nuts=[0,0,0,0]);
					render() translate([0,end_stop_plate_size[1],0]) rotate([-90,90,0]) nut_hole(type=end_stop_mounting_nut, nut_slot=(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2, horizontal=true);
					render() translate([-end_stop_hole_spacing[1],end_stop_plate_size[1],0]) rotate([-90,90,0]) nut_hole(type=end_stop_mounting_nut, nut_slot=(end_stop_plate_size[0]-end_stop_hole_spacing[0])/2, horizontal=true);
				}
		
		// Lead screw hole and anti-backlash nut
		translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]-0.01]) screw_hole(type=lead_screw, h=20.01, allowance=1);
		translate([0,x_end_base_size[1]/2-lead_screw_y_offset,x_end_base_size[2]+0.01]) nut_hole(type=lead_screw_nut, thickness=z_bushing_foot_height+1.01, allowance=nut_hole_allowance_vertical*2.5);

		// rod clamp screw holes		
		translate([0,0,0]) rod_clamp_screws(nuts=false);
	}
}

module x_end_bottom() {
	difference() {
		union() {
			x_end_base(top=[0,5,0,5]);
			translate([0,x_end_base_size[1]/2-lead_screw_y_offset,-x_end_base_clamp_gap/2+nut_thickness(v_nut_hole(lead_screw_nut))]) cylinder_poly(r=screw_dia(v_screw_hole(lead_screw))/2+1, h=layer_height);
		}
		render() translate([0,0,x_end_base_size[2]+1]) bushing_mount_screws(screw_length=12);

		// rod clamp screw holes
		translate([0,0,0]) rod_clamp_screws(nuts=true);
		
		render() translate([0,x_end_base_size[1]/2-lead_screw_y_offset,-x_end_base_clamp_gap/2]) nut_hole(type=lead_screw_nut);
	}
}

module x_end_bottom_endstop() {
	union() {
		difference() {
			union() {
				x_end_base(top=[0,0,0,5]);
				translate([0,x_end_base_size[1]/2-lead_screw_y_offset,-x_end_base_clamp_gap/2+nut_thickness(v_nut_hole(lead_screw_nut))]) cylinder_poly(r=screw_dia(v_screw_hole(lead_screw))/2+1, h=layer_height);
				
				// z end stop
				translate([-z_end_stop_loc_x+1.5, z_end_stop_loc_y, (x_end_base_size[2]+z_bushing_foot_height+1)/2]) cube_fillet([nut_outer_dia(v_nut_hole(end_stop_flag_nut))+7, nut_outer_dia(v_nut_hole(end_stop_flag_nut))+4, x_end_base_size[2]+z_bushing_foot_height+1], center=true);
				
				difference() {
					translate([-x_end_base_size[0]/2, -x_end_base_size[1]/2-0.1, x_end_base_size[2]-0.01]) cube_fillet([(x_end_base_size[0]-x_end_bushing_mount_wall_width)/2+0.1, x_end_base_size[1]/2+7+0.1,x_end_idler_wall_height-x_end_base_size[2] + 0.01], vertical=[0,11,0,0], top=[0,0,0,0]);	//idler wall
					translate([-x_end_base_size[0]/2+sagitta_radius((x_end_base_size[0]-x_end_bushing_mount_wall_width)/2-5, 
						x_end_base_size[1]/2+7-(z_bushing_mount_thickness+7))+5, 
						-x_end_base_size[1]/2, 
						x_end_base_size[2] -0.01])
					cylinder_poly(r=sagitta_radius((x_end_base_size[0]-x_end_bushing_mount_wall_width)/2-5, x_end_base_size[1]/2+7-(z_bushing_mount_thickness+7)), h=x_end_idler_wall_height-x_end_base_size[2]+0.02);	//idler wall
				}
			}
			render() translate([0,0,x_end_base_size[2]+1]) bushing_mount_screws(screw_length=12);
			
			// z end stop hole
			translate([-z_end_stop_loc_x, z_end_stop_loc_y, x_end_base_size[2]+z_bushing_foot_height+1-4])
				rotate([180,0,180]) nut_hole(type=end_stop_flag_nut, nut_slot=nut_outer_dia(v_nut_hole(end_stop_flag_nut))/2+3);
			translate([-z_end_stop_loc_x, z_end_stop_loc_y, 0])
				screw_hole(type=end_stop_flag_screw, h=x_end_base_size[2]+z_bushing_foot_height+1, washer=end_stop_flag_washer, head_drop=z_bushing_foot_height, hole_support=true);
			
			// rod clamp screw holes
			translate([0,0,0]) rod_clamp_screws(nuts=true);
			
			render() translate([0,x_end_base_size[1]/2-lead_screw_y_offset,-x_end_base_clamp_gap/2]) nut_hole(type=lead_screw_nut);
		}
		translate([-z_end_stop_loc_x, z_end_stop_loc_y, x_end_base_size[2]+z_bushing_foot_height+1-4])
			cylinder(r=nut_outer_dia(v_nut_hole(end_stop_flag_nut))/2, h=layer_height+0.01);
	}
}

//translate([0,0,-x_end_base_clamp_gap]) rotate([0,180,0]) x_end_bottom();
/*
translate([0,x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset,-(x_end_base_size[2]+1)-x_end_base_clamp_gap-z_bushing_foot_height]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
translate([0,x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset,x_end_base_size[2]+1]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
//idler
%translate([(x_end_base_size[0]/2)+1+bearing_width(x_end_idler_bearing), screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([0,-90,0]) idler(x_end_idler_bearing=x_end_idler_bearing);
*/

// Print one of the motor and idler, two x_end_bottom, and 4 of the bearing clamps
//linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
//x_end_idler();
//x_end_motor();
x_end_bottom();
//x_end_bottom_endstop();