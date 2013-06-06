include <inc/functions.scad>
include <configuration.scad>

dxf=true;

module side_plate() {
	difference() {
		union() {
			translate([-frame_plate_width/2, 0, 0]) cube([frame_plate_width,frame_plate_height,10]);
			// feet
			translate([frame_threaded_rod_distance/2+frame_rod_distance_to_edge-30, -10, -0.5])
				cube([30,11,10+1]);
			translate([-(frame_threaded_rod_distance/2+frame_rod_distance_to_edge), -10, -0.5])
				cube([30,11,10+1]);
		}
		translate([frame_threaded_rod_distance/2, frame_rod_distance_to_edge,-0.5]) rotate([0,0,-frame_bottom_vertex_angle]) {		
			rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);
			translate([0, frame_vertex_rod_to_rod_distance, 0]) rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);
		}
		translate([-frame_threaded_rod_distance/2, frame_rod_distance_to_edge,-0.5]) rotate([0,0,frame_bottom_vertex_angle]) {		
			rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);
			translate([0, frame_vertex_rod_to_rod_distance, 0]) rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);
		}

		// Top vertex holes
		translate([frame_vertex_rod_to_rod_distance/2, frame_vertex_y+frame_top_vertex_y+frame_rod_distance_to_edge, -0.5])
			rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);
		translate([-frame_vertex_rod_to_rod_distance/2, frame_vertex_y+frame_top_vertex_y+frame_rod_distance_to_edge, -0.5])
			rod_hole(d=frame_threaded_rod_diameter, h=10+1, allowance=frame_threaded_rod_allowance);

		// bottom support hole
		translate([-frame_threaded_rod_diameter-frame_center_rod_offset, frame_rod_distance_to_edge, -0.5])
			rod_hole(d=frame_threaded_rod_diameter, h=10+1, length=frame_center_rod_offset, allowance=frame_threaded_rod_allowance);

		// center cutout
		translate([-frame_center_cutout_width/2,frame_vertex_y+frame_rod_distance_to_edge,-0.5])
			cube_fillet([frame_center_cutout_width,frame_plate_height-frame_vertex_y-frame_rod_distance_to_cutout-frame_rod_distance_to_edge*2,10+1], vertical=[40,40,10,10]);

		// side cutoffs
		translate([frame_plate_width/2, frame_vertex_y+frame_rod_distance_to_edge*2, -0.5])
			rotate([0,0,frame_bottom_vertex_angle])
			cube([frame_plate_width/2,frame_plate_height,10+1]);
		mirror([1,0,0]) translate([frame_plate_width/2, frame_vertex_y+frame_rod_distance_to_edge*2, -0.5])
			rotate([0,0,frame_bottom_vertex_angle])
			cube([frame_plate_width/2,frame_plate_height,10+1]);

		translate([frame_threaded_rod_distance/2+frame_rod_distance_to_edge, 0, -0.5])
			rotate([0,0,-frame_bottom_vertex_angle])
			cube([frame_vertex_x+1,frame_vertex_rod_to_rod_distance+frame_rod_distance_to_edge,10+1]);

		mirror([1,0,0]) translate([frame_threaded_rod_distance/2+frame_rod_distance_to_edge, 0, -0.5])
			rotate([0,0,-frame_bottom_vertex_angle])
			cube([frame_vertex_x+1,frame_vertex_rod_to_rod_distance+frame_rod_distance_to_edge,10+1]);
	}
}

if (dxf){
	projection() side_plate();
}
else {
	side_plate();
}