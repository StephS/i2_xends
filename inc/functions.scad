// PRUSA iteration3
// Functions used in many files
// GNU GPL v3
// Josef Pr?ša <josefprusa@me.com>
// Václav 'ax' H?la <axtheb@gmail.com>
// Vlnofka <>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel
include <fillets.scad>

use_fillets=true;

module chamfer(x=10,y=10,z=10) {
 rotate(a=[90,-90,0])
 linear_extrude(height = y, center = true, convexity = 2, twist = 0)
 polygon(points = [
[-1.00,-1.00]
,[-1.00,x-1.00]
,[0.00,x]
,[z,0.00]
,[z-1.00,-1.00]
]
,paths = [
[0,1,2,3,4]]
       );
}

function sagitta_arc(r, angle) = (r* (1 - cos(angle/2) ));

function sagitta(r, l) = r - sqrt(pow(r,2) - pow(l,2));

function sagitta_radius(s, l) = (pow(s,2) + pow(l,2))/ (2*s);
//function sagitta_radius(s, l) = (hypotenuse / 2) / cos(90 - atan(short side / long side));

// This will size an outer diameter to fit inside dia with $fn sides
// use this to set the diameter before passing to polyhole
function hole_fit( dia=0,$fn=0) = dia/cos(180/(($fn>0) ? $fn : 0.01));
function hole_fit_poly( dia=0) = dia/cos(180/poly_sides(dia));

// This determines the number of sides of a hole that is printable
// I added +1 because nobody wants to print a triangle. (plus it looks nicer, havn't tested printability yet.)
function poly_sides(d) = (max(round(2 * d),3)+1);

// Based on nophead research
module polyhole(d, d1, d2, h, center=false, $fn=0) {
    n = max((($fn>0) ? $fn : poly_sides(d)), (($fn>0) ? $fn : poly_sides(d1)), (($fn>0) ? $fn : poly_sides(d2)));
    cylinder(h = h, r = (d / 2), r1 = (d1 / 2), r2 = (d2 / 2), $fn = n, center=center);
}

// make it interchangeable between this and cylinder
module cylinder_poly(r, r1, r2, h, center=false, $fn=0){
    polyhole(d=r*2, d1=r1*2, d2=r2*2, h=h, center=center, $fn=$fn);
}

module cylinder_slot(r=0, r1, r2, h, length=0, center=false, $fn=0) {
	n = ($fn > 0) ? $fn : max(poly_sides(r*2), poly_sides(r1*2), poly_sides(r2*2));
	
	union() {
		rotate([0,0, 180/n]) cylinder_poly(h=h, r=r, r1=r1, r2=r2, center=center, $fn=n);
		if (length>0) {
			translate([((center) ? length/2 : 0),((center) ? 0 : -((r>0) ? r : r1)*cos(180/n)), 0]) trapezoid(cube=[length, ((r>0) ? r*2 : r1*2) *cos(180/n),h], y1=(r1-r2)*cos(180/n), y2=(r1-r2)*cos(180/n), center=center);
			//cube([length, dia*cos(180/n),h]);
			translate([length, 0, 0]) rotate([0,0, 180/n]) cylinder_poly(h=h, r=r, r1=r1, r2=r2, center=center, $fn=n);
		}
	}
}

module trapezoid(cube=[10, 10, 10], x1=0, x2=0, y1=0, y2=0, center=false) {
	translate((center) ? [0,0,0] : [cube[0]/2, cube[1]/2, cube[2]/2] ) {
		difference() {
			translate([0, 0 ,0]) cube(cube, center=true);
			if (x2 >0 ) translate([cube[0]/2, -(cube[1]+0.1)/2, -cube[2]/2]) rotate([0,-atan(x2/cube[2]),0]) cube([x2*cos(atan(x2/cube[2]))+0.1, cube[1]+0.1, sqrt( pow(cube[2], 2) + pow(x2, 2))]);
			if (x1 >0 ) translate([-cube[0]/2, -(cube[1]+0.1)/2, -cube[2]/2]) rotate([0,atan(x1/cube[2]),0]) translate([ -(x1*cos(atan(x1/cube[2]))+0.1), 0, 0]) cube([x1*cos(atan(x1/cube[2]))+0.1, cube[1]+0.1, sqrt( pow(cube[2], 2) + pow(x1, 2))]);
			if (y1 >0 ) translate([-(cube[0]+0.1)/2, -cube[1]/2, -cube[2]/2]) rotate([-atan(y1/cube[2]),0,0]) translate([ 0, -(y1*cos(atan(y1/cube[2]))+0.1), 0]) cube([cube[0]+0.1, y1*cos(atan(y1/cube[2]))+0.1, sqrt( pow(cube[2], 2) + pow(y1, 2))]);
			if (y2 >0 ) translate([-(cube[0]+0.1)/2, cube[1]/2, -cube[2]/2]) rotate([atan(y2/cube[2]),0,0]) cube([cube[0]+0.1, y2*cos(atan(y2/cube[2]))+0.1, sqrt( pow(cube[2], 2) + pow(y2, 2))]);
		}
	}
}

module cube_fillet(size, radius=-1, vertical=[3,3,3,3], top=[0,0,0,0], bottom=[0,0,0,0], center=false, $fn=0, vertical_fn=[0,0,0,0], top_fn=[0,0,0,0], bottom_fn=[0,0,0,0]){
    //
    render(convexity = 2)
    if (use_fillets) {
        if (center) {
            cube_fillet_inside(size, radius, vertical, top, bottom, $fn, vertical_fn, top_fn, bottom_fn);
        } else {
            translate([size[0]/2, size[1]/2, size[2]/2])
                cube_fillet_inside(size, radius, vertical, top, bottom, $fn, vertical_fn, top_fn, bottom_fn);
        }
    } else {
        cube(size, center);
    }
}