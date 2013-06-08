include <configuration.scad>
include <inc/nuts_screws.scad>;

module end_stop_holder(smooth_rod=x_axis_smooth_rod_diameter){
	difference(){
		union(){
			cylinder_poly(r=v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, h=end_stop_plate_size[2]);
			
			translate([0,-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				cube_fillet([v_rod_hole(d=smooth_rod)/2+end_stop_smooth_rod_to_screw_gap+screw_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true))/2+screw_head_top_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true)),v_rod_hole(d=smooth_rod)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, end_stop_plate_size[2]], vertical=[0,0,0,0], bottom=[0,0,0,end_stop_size[2]/2], top=[0,0,0,end_stop_size[2]/2], $fn=4);
			translate([-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness)-end_stop_plate_size[0]-end_stop_plate_offset,-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				end_stop_plate(horizontal=true);
			translate([-(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness+end_stop_plate_offset)-0.1, -(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				cube([(v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness+end_stop_plate_offset)+0.1,end_stop_mount_thickness, end_stop_plate_size[2]]);
		}
		
		// smooth rod hole
		translate([0,0,-0.01]) rod_hole(d=smooth_rod,h=end_stop_plate_size[2]+0.02);
		// clamp screw hole
		translate([v_rod_hole(d=smooth_rod)/2+end_stop_smooth_rod_to_screw_gap +screw_dia(v_screw_hole(type=screw_M4_socket_head, $fn=12, horizontal=true))/2, v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, end_stop_plate_size[2]/2]) rotate([90,0,0]) screw_hole(type=screw_M4_socket_head, h=v_rod_hole(d=smooth_rod)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, $fn=12, horizontal=true);
		
		translate([0,-frame_threaded_smooth_rod_clamp_gap/2,-0.1]) cube([v_rod_hole(d=smooth_rod)/2+frame_threaded_to_smooth_rod_gap+screw_dia(v_screw_hole(type=frame_threaded_rod, $fn=12, horizontal=true))/2+frame_threaded_smooth_rod_clamp_height/2+0.1, frame_threaded_smooth_rod_clamp_gap, end_stop_plate_size[2]+0.2]);
	}
}

module end_stop_plate(size=end_stop_plate_size, nut_drop=0, horizontal=true, holes=true, $fn=8){
	difference () {
		cube(size);
		if (holes)
			translate([(size[0]-end_stop_hole_spacing[0])/2,0,(size[2]-end_stop_hole_spacing[1])/2])
				end_stop_screw_holes(h=size[1], nut_drop=nut_drop, horizontal=horizontal, $fn=$fn);
	}
}

module end_stop_plate_vertical(size=end_stop_plate_size, nut_drop=0, horizontal=true, holes=true, $fn=8){
	difference () {
		cube([size[2], size[1], size[0]]);
		if (holes)
			translate([(size[2]-end_stop_hole_spacing[1])/2+(end_stop_hole_spacing[1]),0,(size[0]-end_stop_hole_spacing[0])/2])
				rotate([0,-90,0]) end_stop_screw_holes(h=size[1], nut_drop=nut_drop, horizontal=horizontal, $fn=$fn, rotate_z=90);
	}
}

module end_stop_screw_holes(h=end_stop_plate_size[1], nut_drop=0, horizontal=true, rotate_z=0, $fn=8, holes=[1,1,1,1], nuts=[1,1,1,1]){
	if (holes[0]==1)	
		rotate([-90,rotate_z,0]) screw_hole(type=end_stop_mounting_screw, h=h, horizontal=horizontal, $fn=$fn);
	if (holes[1]==1)			
	translate([end_stop_hole_spacing[0],0,0]) 
		rotate([-90,rotate_z,0]) screw_hole(type=end_stop_mounting_screw, h=h, horizontal=horizontal, $fn=$fn);
	if (holes[2]==1)	
	translate([0,0,end_stop_hole_spacing[1]]) 
		rotate([-90,rotate_z,0]) screw_hole(type=end_stop_mounting_screw, h=h, horizontal=horizontal, $fn=$fn);
	if (holes[3]==1)	
	translate([end_stop_hole_spacing[0], 0, end_stop_hole_spacing[1]]) 
		rotate([-90,rotate_z,0]) screw_hole(type=end_stop_mounting_screw, h=h, horizontal=horizontal, $fn=$fn);
				
	if(nut_drop>0) {
		if (nuts[0]==1)	
		translate([0, h-nut_drop,0]) 
			rotate([-90,rotate_z,0]) nut_hole(type=end_stop_mounting_nut, thickness=nut_drop, horizontal=horizontal);
		if (nuts[1]==1)	
		translate([end_stop_hole_spacing[0],h-nut_drop,0]) 
			rotate([-90,rotate_z,0]) nut_hole(type=end_stop_mounting_nut, thickness=nut_drop, horizontal=horizontal);
		if (nuts[2]==1)	
		translate([0, h-nut_drop, end_stop_hole_spacing[1]]) 
			rotate([-90,rotate_z,0]) nut_hole(type=end_stop_mounting_nut, thickness=nut_drop, horizontal=horizontal);
		if (nuts[3]==1)	
		translate([end_stop_hole_spacing[0],h-nut_drop,end_stop_hole_spacing[1]]) 
			rotate([-90,rotate_z,0]) nut_hole(type=end_stop_mounting_nut, thickness=nut_drop, horizontal=horizontal);
	}
}

//end_stop_screw_holes(nut_drop=1, horizontal=true, rotate_z=0, $fn=8);
//end_stop_plate_vertical(size=end_stop_plate_size, nut_drop=1, horizontal=true, $fn=8);

end_stop_holder();
//end_stop_plate(size=end_stop_plate_size, nut_drop=1, horizontal=true, $fn=8);