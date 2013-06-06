// PRUSA Mendel  
// Z motor mount
// Used for mounting Z motors
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel
include <configuration.scad>
include <inc/nuts_screws.scad>;
use <inc/drivetrain.scad>
 
module z_motor_mount(){
	difference(){
		union(){
			translate([0,0,stepper_motor_padded/2+z_motor_mount_clamp_wall_thickness]) rotate ([0,-90,0]) motor_plate(thickness=z_motor_mount_thickness, width=stepper_motor_padded, slot_length=0, vertical=[0,0,0,0], head_drop=0, hole_support=false, inwards_slot=false, $fn=12);
			
			// connect the motor mount to the sides.
			translate([-z_motor_mount_thickness,stepper_motor_padded/2-0.1,0]) cube([z_motor_mount_thickness,z_motor_mount_width/2+0.1, z_motor_mount_height]);
			translate([-z_motor_mount_thickness, -stepper_motor_padded/2-z_motor_mount_width/2,0]) cube([z_motor_mount_thickness,z_motor_mount_width/2+0.1, z_motor_mount_height]);
			
			// sides
			difference() {
				union() {
					translate([-z_motor_mount_thickness+z_motor_mount_width/2,frame_vertex_rod_to_rod_distance/2,0]) cylinder_poly(r=z_motor_mount_width/2, h=z_motor_mount_height);
					translate([-z_motor_mount_thickness+z_motor_mount_width/2,-frame_vertex_rod_to_rod_distance/2,0]) cylinder_poly(r=z_motor_mount_width/2, h=z_motor_mount_height);
				}
				translate([0,-stepper_motor_padded/2,z_motor_mount_clamp_wall_thickness]) cube ([z_motor_mount_width,stepper_motor_padded,z_motor_mount_height-z_motor_mount_clamp_wall_thickness+0.1]);
			}
			
			// bottom wall
			translate([-z_motor_mount_thickness,-frame_vertex_rod_to_rod_distance/2,0]) cube([z_motor_mount_width,frame_vertex_rod_to_rod_distance,z_motor_mount_clamp_wall_thickness]);
			
			translate([-z_motor_mount_thickness, -frame_vertex_rod_to_rod_distance/2, z_motor_mount_clamp_wall_thickness+stepper_motor_padded-0.1]) cube([z_motor_mount_thickness, frame_vertex_rod_to_rod_distance, z_motor_mount_height-z_motor_mount_clamp_wall_thickness-stepper_motor_padded+0.1]);
		}
		
		// frame rod holes
		translate([-z_motor_mount_thickness+z_motor_mount_width/2, frame_vertex_rod_to_rod_distance/2,z_motor_mount_height]) rotate([180,0,0]) screw_hole(type=frame_threaded_rod, h=z_motor_mount_height);
		translate([-z_motor_mount_thickness+z_motor_mount_width/2, -frame_vertex_rod_to_rod_distance/2,z_motor_mount_height]) rotate([180,0,0]) screw_hole(type=frame_threaded_rod, h=z_motor_mount_height);
		
		// smooth rod cutout
		translate([-z_motor_mount_thickness-0.5,0,0]) rotate([0,90,0]) rod_hole(d=z_axis_smooth_rod_diameter,h=z_motor_mount_width+1, horizontal=true, $fn=10);
		
		// screw holes
		translate([-z_motor_mount_thickness+z_motor_mount_width/2,z_motor_mount_clamp_seperation/2,0]) screw_nut_negative(l=z_motor_mount_clamp_wall_thickness, screw=z_motor_mount_clamp_screw, nut=z_motor_mount_clamp_nut, nut_drop=(nut_thickness(z_motor_mount_clamp_nut)+1), nut_thickness=(nut_thickness(z_motor_mount_clamp_nut)+1));
		translate([-z_motor_mount_thickness+z_motor_mount_width/2,-z_motor_mount_clamp_seperation/2,0]) screw_nut_negative(l=z_motor_mount_clamp_wall_thickness, screw=z_motor_mount_clamp_screw, nut=z_motor_mount_clamp_nut, nut_drop=(nut_thickness(z_motor_mount_clamp_nut)+1), nut_thickness=(nut_thickness(z_motor_mount_clamp_nut)+1));
	}
}

module z_motor_mount_clamp(){
	difference(){
		translate([0,-(z_motor_mount_clamp_seperation+14)/2,0]) cube_fillet([z_motor_mount_width, z_motor_mount_clamp_seperation+14, z_motor_mount_clamp_height], vertical=[z_motor_mount_width/3,z_motor_mount_width/3,z_motor_mount_width/3,z_motor_mount_width/3]);
		
		translate([-0.5,0,-0.5]) rotate([0,90,0]) rod_hole(d=z_axis_smooth_rod_diameter,h=z_motor_mount_width+1, horizontal=true, $fn=10);
		translate([z_motor_mount_width/2,z_motor_mount_clamp_seperation/2,z_motor_mount_clamp_height]) rotate([180,0,0]) screw_hole(type=z_motor_mount_clamp_screw, washer_type=washer_M5, h=z_motor_mount_clamp_height, head_drop=screw_head_height(v_screw_hole(z_motor_mount_clamp_screw)));
		translate([z_motor_mount_width/2,-z_motor_mount_clamp_seperation/2,z_motor_mount_clamp_height]) rotate([180,0,0]) screw_hole(type=z_motor_mount_clamp_screw, washer_type=washer_M5, h=z_motor_mount_clamp_height, head_drop=screw_head_height(v_screw_hole(z_motor_mount_clamp_screw)));
	}
}

translate([z_motor_mount_width,0,0])
	z_motor_mount_clamp();
z_motor_mount();
