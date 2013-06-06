include <functions.scad>;
include <nuts_screws.scad>;

stepper_motor_width=42;

module nema17(places=[1,1,1,1], size=15.5, h=10, holes=false, shadow=false, head_drop=5, slot_length=0, $fn=24, hole_support=false){
    for (i=[0:3]) {
        if (places[i] == 1) {
            rotate([0, 0, 90*i]) translate([size, size, 0]) {
                if (holes) {
                    rotate([0, 0, -90*i]) screw_hole(type=screw_M3_socket_head, head_drop=head_drop, length=slot_length, $fn=$fn, h=h, hole_support=hole_support);
                } else {
                    rotate([0, 0, -90*i]) cylinder_slot(h=h, r=5.5, length=slot_length, $fn=$fn);
                }
            }
        }
    }
    if (shadow != false) {
        %translate ([0, 0, shadow+3+42]) mirror([0,0,1]) nema17_motor();
    }
}

module nema17_inwards_slot(places=[1,1,1,1], size=15.5, h=10, holes=false, shadow=false, head_drop=5, slot_length=0, $fn=24, hole_support=false){
    for (i=[0:3]) {
        if (places[i] == 1) {
            rotate([0, 0, 90*i]) translate([size, size, 0]) {
                if (holes) {
                    rotate([0, 0, -135]) screw_hole(type=screw_M3_socket_head, head_drop=head_drop, length=slot_length, $fn=$fn, h=h, hole_support=hole_support);
                } else {
                    rotate([0, 0, -90*i]) cylinder_poly(h=h, r=5.5, $fn=$fn);
                }
            }
        }
    }
    if (shadow != false) {
        %translate ([0, 0, shadow+3+42]) mirror([0,0,1]) nema17_motor();
    }
}

module nema17_motor(height=42, color=true) {
	union() {
        % translate ([0, 0, height/2]) cube([42,42,height], center = true);
	//flange
        % translate ([0, 0, height+1]) cylinder(r=11,h=2, center = true, $fn=20);
	//shaft
        % translate ([0, 0, height+7]) cylinder(r=2.5,h=14, center = true);
	}
}

module motor_plate(thickness=10, width=stepper_motor_width, slot_length=0, vertical=[0,0,0,0], head_drop=5, hole_support=false, inwards_slot=false, $fn=0){
	difference(){
		union(){
            // Motor holding part
            difference(){
				union(){
					//nema17(places=[1,1,1,1], h=thickness, slot_length=slot_length);
					translate([((inwards_slot) ? 0 :slot_length)/2, 0, thickness/2]) cube_fillet([width+((inwards_slot) ? 0 :slot_length),width,thickness], vertical=vertical, center = true);
				}

                // motor screw holes
                if (inwards_slot) {
					translate([0, 0, thickness]) mirror([0,0,1]) nema17_inwards_slot(places=[1,1,1,1], holes=true, head_drop=head_drop, h=thickness, slot_length=slot_length, $fn=$fn, hole_support=hole_support);
				} else {
					translate([0, 0, thickness]) mirror([0,0,1]) nema17(places=[1,1,1,1], holes=true, head_drop=head_drop, h=thickness, slot_length=slot_length, $fn=$fn, hole_support=hole_support);
				}
				// center hole
				if (inwards_slot) {
					translate ([0, 0, thickness/2]) cylinder_poly(r=hole_fit(11.5*2,$fn)/2,h=thickness+1, center = true, $fn=$fn);
				} else {
					translate ([0, 0, thickness/2]) cylinder_slot(r=hole_fit(11.5*2,$fn)/2,h=thickness+1, length=slot_length, center = true, $fn=$fn);
				}
            }
				translate([0, 0, -42]) nema17_motor();
        }
    }
}

module belt_pulley(pulley=[ 20.6, 6.3, 11.1, 3.5, 3, 15.4, 17.5, 22, (20.6-6.3)/2+6.3])
{
	difference() {
		union() {
			translate ([0, 0, pulley[1]/2]) cylinder(r=pulley[6]/2,h=pulley[1], center = true);
			translate ([0, 0, (pulley[0]-pulley[1]-pulley[2])/2/2+pulley[1]]) cylinder(r=pulley[7]/2,h=(pulley[0]-pulley[1]-pulley[2])/2, center = true);
			translate ([0, 0, pulley[1]+(pulley[0]-pulley[1]-pulley[2])/2+pulley[2]/2]) cylinder(r=pulley[5]/2,h=pulley[2], center = true);
			translate ([0, 0, pulley[1]+(pulley[0]-pulley[1]-pulley[2])/2+pulley[2]+(pulley[0]-pulley[1]-pulley[2])/2/2]) cylinder(r=pulley[7]/2,h=(pulley[0]-pulley[1]-pulley[2])/2, center = true);
		}
		translate ([0, 0, pulley[0]/2]) cylinder(r=2.5,h=pulley[0]+1, center = true);
	}
}

//radius of the idler assembly (to surface that touches belt, ignoring guide walls)
function idler_assy_r_inner(idler_bearing) = (idler_bearing[0] / 2) + 4 * single_wall_width * idler_bearing[3];
//radius of the idler assembly (to smooth side of belt)
function idler_assy_r_outer(idler_bearing) = (idler_bearing[0] / 2) + (idler_bearing[3] ? (5.5 * idler_bearing[3]) : belt[3]+1);

module idler(idler_bearing=[22, 7, 8, 1], center=false) {
	difference(){
		cylinder(r=idler_bearing[0]/2,h=idler_bearing[1], center = center);
		cylinder_poly(r=idler_bearing[2]/2,h=idler_bearing[1]+1, center = center);
	}
	
}

module idler_assy(idler_bearing = [22, 7, 8, 1], idler_width=x_idler_width) {

    translate([0,0,0]) rod_hole(h=120, d=idler_bearing[2], $fn=8, center=true);
    //bearing shadow
    %idler(idler_bearing, center=true)
    // cutout around the idler
    cylinder(h = idler_width + 1, r=idler_assy_r_outer(idler_bearing), center=true);
}
