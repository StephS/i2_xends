include <configuration.scad>
include <inc/nuts_screws.scad>;

module end_stop_holder(smooth_rod=x_axis_smooth_rod_diameter){
	difference(){
		union(){
			cylinder_poly(r=v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, h=end_stop_size[2]);
			
			translate([0,-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				cube_fillet([v_rod_hole(d=smooth_rod)/2+end_stop_smooth_rod_to_screw_gap+screw_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true))/2+screw_head_top_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true)),v_rod_hole(d=smooth_rod)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, end_stop_size[2]], vertical=[0,0,0,0], bottom=[0,0,0,end_stop_size[2]/2], top=[0,0,0,end_stop_size[2]/2], $fn=4);
			translate([-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness)-end_stop_size[0]-end_stop_plate_offset,-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				end_stop_plate(horizontal=true);
			translate([-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness+end_stop_plate_offset)-0.1, -(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				cube([(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness+end_stop_plate_offset)+0.1,end_stop_mount_thickness, end_stop_size[2]]);
		}
		
		// smooth rod hole
		translate([0,0,-0.01]) rod_hole(d=smooth_rod,h=end_stop_size[2]+0.02);
		// clamp screw hole
		translate([v_rod_hole(d=smooth_rod)/2+end_stop_smooth_rod_to_screw_gap +screw_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true))/2, v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, frame_threaded_smooth_rod_clamp_height/2]) rotate([90,0,0]) screw_hole(type=screw_M4_socket_head, h=v_rod_hole(d=smooth_rod)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, $fn=12, horizontal=true);
		
		translate([0,-frame_threaded_smooth_rod_clamp_gap/2,-0.1]) cube([v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_gap+screw_dia(v_screw_hole(type=frame_threaded_rod, $fn=12, horizontal=true))/2+frame_threaded_smooth_rod_clamp_height/2+0.1, frame_threaded_smooth_rod_clamp_gap, frame_threaded_smooth_rod_clamp_height+0.2]);
	}
}

module end_stop_plate(horizontal=true, $fn=8){
	difference () {
		cube([end_stop_size[0], end_stop_mount_thickness, end_stop_size[2]]);
		translate([(end_stop_size[0]-end_stop_hole_spacing[0])/2,0,(end_stop_size[2]-end_stop_hole_spacing[1])/2]) 
			rotate([-90,0,0]) screw_hole(type=end_stop_mounting_screw, h=end_stop_mount_thickness, horizontal=horizontal, $fn=$fn);
		translate([(end_stop_size[0]-end_stop_hole_spacing[0])/2+end_stop_hole_spacing[0],0,(end_stop_size[2]-end_stop_hole_spacing[1])/2]) 
			rotate([-90,0,0]) screw_hole(type=end_stop_mounting_screw, h=end_stop_mount_thickness, horizontal=horizontal, $fn=$fn);

		translate([(end_stop_size[0]-end_stop_hole_spacing[0])/2,0,(end_stop_size[2]-end_stop_hole_spacing[1])/2+end_stop_hole_spacing[1]]) 
			rotate([-90,0,0]) screw_hole(type=end_stop_mounting_screw, h=end_stop_mount_thickness, horizontal=horizontal, $fn=$fn);
		translate([(end_stop_size[0]-end_stop_hole_spacing[0])/2+end_stop_hole_spacing[0],0,(end_stop_size[2]-end_stop_hole_spacing[1])/2+end_stop_hole_spacing[1]]) 
			rotate([-90,0,0]) screw_hole(type=end_stop_mounting_screw, h=end_stop_mount_thickness, horizontal=horizontal, $fn=$fn);
	}
}

end_stop_holder();
