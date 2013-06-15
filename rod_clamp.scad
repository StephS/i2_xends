include <configuration.scad>
include <inc/nuts_screws.scad>;

module rod_clamp(smooth_rod=x_axis_smooth_rod_diameter){
	difference(){
		union(){
			cylinder_poly(r=v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, h=frame_threaded_smooth_rod_clamp_height);
			translate([0,-(v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness),0])
				cube_fillet([v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_gap+screw_dia(v_screw_hole(type=frame_threaded_rod, $fn=12, horizontal=true))/2+frame_threaded_smooth_rod_clamp_height/2,v_rod_hole(d=smooth_rod, allowance=0.1)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, frame_threaded_smooth_rod_clamp_height], vertical=[0,0,0,0], bottom=[0,0,0,frame_threaded_smooth_rod_clamp_height/2], top=[0,0,0,frame_threaded_smooth_rod_clamp_height/2], $fn=3);
		}
		
		// smooth rod hole
		translate([0,0,-0.01]) rod_hole(d=smooth_rod,h=frame_threaded_smooth_rod_clamp_height+0.02, allowance=0.1);
		// frame screw hole
		translate([v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_gap +screw_dia(v_screw_hole(type=frame_threaded_rod, $fn=12, horizontal=true))/2, v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_clamp_wall_thickness, frame_threaded_smooth_rod_clamp_height/2]) rotate([90,0,0]) screw_hole(type=frame_threaded_rod, h=v_rod_hole(d=smooth_rod, allowance=0.1)+frame_threaded_to_smooth_rod_clamp_wall_thickness*2, $fn=8, horizontal=true);
		
		translate([0,-frame_threaded_smooth_rod_clamp_gap/2,-0.1]) cube([v_rod_hole(d=smooth_rod, allowance=0.1)/2+frame_threaded_to_smooth_rod_gap+screw_dia(v_screw_hole(type=frame_threaded_rod, $fn=8, horizontal=true))/2+frame_threaded_smooth_rod_clamp_height/2+0.1, frame_threaded_smooth_rod_clamp_gap, frame_threaded_smooth_rod_clamp_height+0.2]);
	}
}

rod_clamp();
