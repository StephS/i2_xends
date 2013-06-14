include <configuration.scad>
use <x_end_base.scad>
use <x_carriage.scad>
use <bushing.scad>
use <end_stop_holder.scad>

translate([0,0,-x_end_base_clamp_gap]) rotate([0,180,0]) x_end_bottom(end_stop=true);
translate([0,x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset,-(x_end_base_size[2]+1)-x_end_base_clamp_gap-z_bushing_foot_height]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
translate([0,x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset,x_end_base_size[2]+1]) rotate([0,0,-90]) linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
//idler
//%translate([(x_end_base_size[0]/2)+1+bearing_width(x_end_idler_bearing), screw_dia(v_screw_hole(x_end_idler_screw, $fn=8))/2, x_end_idler_height]) rotate([0,-90,0]) idler(x_end_idler_bearing=x_end_idler_bearing);


// Print one of the motor and idler, one x_end_bottom, one x_end_bottom(end_stop=true), and 4 of the bearing clamps
//linear_bearing_clamp_with_foot(length=z_bushing_foot_height);
//x_end_idler();
x_end_motor();
//x_end_bottom();
//x_end_bottom(end_stop=true);

translate([0,x_carriage_base_size[1],bushing_x[1]+x_carriage_base_size[2]+0.1]) rotate ([0,180,180]) x_carriage();

translate([0, x_end_base_size[1]/2-lead_screw_to_smooth_rod_separation-lead_screw_y_offset, -(z_bushing_foot_height+1)-x_end_base_size[2]-x_end_base_clamp_gap-end_stop_plate_size[2]-5])
	rotate([0,0,180]) end_stop_holder();