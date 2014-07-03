include <functions.scad>;
include <nuts_screws.scad>;

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
