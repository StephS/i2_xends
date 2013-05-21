// PRUSA iteration3
// Bushing/bearing housings
// GNU GPL v3
// Josef Pr?ša <josefprusa@me.com>
// Václav 'ax' H?la <axtheb@gmail.com>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel
include <configuration.scad>

// ensure that the part length is at least the length of bushing barrel plus add
function adjust_bushing_len(conf_b, h, add=layer_height*2) = ((conf_b[2]+add) > h) ? conf_b[2]+add : h;

//distance from the flat side of bushing holder to rod center
function bushing_foot_len(conf_b, h=10.5, add=4*single_wall_width) = ((conf_b[1]+add) > h) ? conf_b[1]+add : h;

function bushing_clamp_outer_radius(conf_b) = conf_b[1] + 4*single_wall_width;

// basic building blocks, housings for 1 bushing/bearing
// at [0,0] there is center of the smooth rod, pointing in Z

module linear_bushing_negative_single(conf_b=bushing, h=0){
    // barrel with the dimensions of a bushing/bearing
    // to be substracted as needed
    translate([0, 0, -0.01])  cylinder(r = conf_b[1], h = adjust_bushing_len(conf_b, h) + 0.02);
}

module linear_bearing_negative_single(conf_b=bushing, h=0){
    // as above but moved by 3 layers up
    cylinder_poly(r = conf_b[1], h = adjust_bushing_len(conf_b, h) + 0.02,center=true);
}

module linear_bushing_single(conf_b=bushing, h=0) {
    // This is the printed barrel around bushing
    // with foot pointing to -x
    translate([-bushing_foot_len(conf_b), -7, 0]) cube([bushing_foot_len(conf_b), 14, adjust_bushing_len(conf_b, h)]);
    cylinder_poly(r=bushing_clamp_outer_radius(conf_b), h=adjust_bushing_len(conf_b, h));
}

module linear_bushing_negative(conf_b=bushing, h=0){
    // return simple negative stretched all along and a smooth rod
    translate([0,0,-0.1]) cylinder(r = conf_b[0] + single_wall_width, h=adjust_bushing_len(conf_b, h)+0.2);
    linear_bushing_negative_single(conf_b, h=adjust_bushing_len(conf_b, h));
}

module linear_bearing_negative(conf_b = bushing, h = 0){
    //same as linear_bushing_negative, but with z direction constrained parts
    cylinder_poly(r = conf_b[0] + single_wall_width, h=adjust_bushing_len(conf_b, h, bushing_retainer_add)+0.2,center=true);
    
    //lower bearing
    linear_bearing_negative_single(conf_b);
    
    if (h > 2*conf_b[2] + 9*layer_height){
        translate([0,0,h]) mirror([0,0,1]) linear_bearing_negative_single(conf_b);
    }
}

module linear_negative_preclean(conf_b = bushing) {
    // makes sure there is nothing interfering
    // to be substracted before linear()
    cylinder(r = conf_b[1] + single_wall_width, h=300, center=true);
}

module linear_bushing_sloped(conf_b=bushing, h= 100){
    // cut the bushing at angle, so it can be printed upside down
    intersection(){
        linear_bushing_single(conf_b, h = h);
        // hardcoded, may need fixing for different barelled bushings
        // atm there is only one and I am too lazy
        translate([0, 0, -2]) rotate([0,-50,0]) cube([30, 40, 80], center=true);
    }
}

module linear_bushing(conf_b=bushing, h=0){
    // this is the function to be used for type 1 linears (barrel holder)
    // It has bushing on bottom and for parts longer than 3x the barel length on top too
    difference() {
        union() {
            translate([-bushing_foot_len(conf_b), -7, 0]) cube([2, 14, adjust_bushing_len(conf_b, h)]);
            linear_bushing_single(conf_b);
            if (h>3*conf_b[2]) {
                translate([0,0,h]) mirror([0,0,1]) linear_bushing_sloped(conf_b);
            }
        }
        linear_bushing_negative(conf_b, h);
    }
}

module linear_bearing(conf_b=bushing, h=0){
	clamp_length=adjust_bushing_len(conf_b, h, bushing_retainer_add);
	difference() {
	    union() {
		    difference() {
				union(){
			        //main block
		            //translate([-bushing_foot_len(conf_b), -7, 0]) cube([4, 14, adjust_bushing_len(conf_b, h, 9*layer_height)]);   <- removed for duplicity:)
		            cylinder_poly(h = clamp_length, r=bushing_clamp_outer_radius(conf_b), center=true);
		          	difference(){
		           	    //lower clamp
						bearing_clamp2(conf_b, w1=2*bushing_clamp_outer_radius(conf_b), w2=2*conf_b[1]+4*single_wall_width, h=clamp_length);
		           	    translate([-(bushing_clamp_outer_radius(conf_b)/2), 0, 0]) cube([bushing_clamp_outer_radius(conf_b), bushing_clamp_outer_radius(conf_b)*2 , clamp_length+1],center=true);
		           	}
		        }
		        //main axis
		        translate([0,0,-2]) cylinder_poly(h = clamp_length+10, r=conf_b[1],center=true);
		        //main cut
		        translate([0, -conf_b[1]+1, -(clamp_length+1)/2]) cube([30, 2*conf_b[1]-2, clamp_length+1]);
		    }
		    difference() {
		        translate([-bushing_foot_len(conf_b), -7, -clamp_length/2]) cube([4, 14, clamp_length]);
		        linear_negative(conf_b, clamp_length);
		    }
		}
		translate([-bushing_foot_len(conf_b)-3.5, -conf_b[1], -(clamp_length+1)/2]) cube([4, conf_b[1]*2, clamp_length+1]);
	}
}

// this should be more parametric
module firm_foot(conf_b, hole_spacing=bushing_mount_hole_spacing, foot_thickness=bushing_mount_thickness, h=bushing_holder_height){
    difference(){
        union() {
            translate([foot_thickness/2,0,0]) cube_fillet([foot_thickness, hole_spacing+9.5, h], center=true, vertical=[2,2,2,2]);
        }
        
        translate([foot_thickness, hole_spacing/2, h/2-6]) rotate([0, -90, 0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8);
        translate([foot_thickness,-hole_spacing/2, h/2-6]) rotate([0,-90,0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8);
        translate([foot_thickness, hole_spacing/2, -h/2+6]) rotate([0, -90, 0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8);
        translate([foot_thickness,-hole_spacing/2, -h/2+6]) rotate([0,-90,0]) screw_hole(type=bushing_mounting_screw, head_drop=0, $fn=8);
    }
}

module linear_bearing_clamp_with_foot(conf_b=bushing, height=bushing_mount_thickness, length=bushing_holder_height, hole_spacing=bushing_mount_hole_spacing){
	echo (length);
    difference() {
        union() {
            difference() {
                union() {
                    translate([-13+0.05, 0, 0]) firm_foot(conf_b, foot_thickness=height, hole_spacing=hole_spacing, h=length);
                    
                    if (conf_b[2] > 45) {
                        translate([-bushing_foot_len(conf_b), 0, adjust_bushing_len(conf_b, 45) - 8]) mirror([0, 0, 1]) firm_foot();
                    }
                }
                linear_negative_preclean();
            }
            linear();
        }
        //linear_negative(bushing, 20);
    }
}

module bearing_clamp_brick2(conf_b=bushing, w1=0, w2=0, h=bushing[2]+9*layer_height){
	translate ([(conf_b[1]+nut_outer_dia(v_nut_hole(nut_M3)))/2.75+0.3,0,h/2])
	rotate([0,90,0])
	trapezoid(cube=[h, w1, conf_b[1]+nut_outer_dia(v_nut_hole(nut_M3))/1.39+0.3], x1=0, x2=0, y1=(w1-w2)/2, y2=(w1-w2)/2, center=true);
}

// w1 is outside dimensions, w2 is beveled dimensions
module bearing_clamp2(conf_b=bushing, w1=0, w2=0, h=bushing[2]+9*layer_height){
	difference() {
		union() {
		
		translate([0,0,-h/2]) bearing_clamp_brick2(conf_b,w1,w2,h);
		
		translate([screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8)) / 2 + conf_b[1] + 0.3, -(w2/2), 0])
			rotate([90,0,0]) rotate([0,0,180/8]) cylinder(r2=hole_fit(nut_outer_dia(v_nut_hole(nut_M3))/2+0.2,$fn=8), r1=hole_fit(nut_outer_dia(v_nut_hole(nut_M3))/2+0.5+(w1-w2)/2,$fn=8), h=(w1-w2)/2, $fn=8);
		translate([screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8)) / 2 + conf_b[1] + 0.3, (w1/2), 0])
			rotate([90,0, 0]) rotate([0,0,180/8]) cylinder(r1=hole_fit(nut_outer_dia(v_nut_hole(nut_M3))/2+0.2,$fn=8), r2=hole_fit(nut_outer_dia(v_nut_hole(nut_M3))/2+0.5+(w1-w2)/2,$fn=8), h=(w1-w2)/2, $fn=8);
		translate([screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8)) / 2 + conf_b[1] + 0.3, 0, 0])
			rotate([90,0, 0]) rotate([0,0,180/8]) cylinder(r=hole_fit(nut_outer_dia(v_nut_hole(nut_M3))/2+0.5+(w1-w2)/2,$fn=8), h=w2, $fn=8, center=true);	
		}
		//translate([m3_diameter / 2 + conf_b[1] + 0.3, 0, h/2]) rotate([90,0,0]) cylinder(r=m3_diameter / 2, h=w1+2, center=true);
		
		// nut trap
		translate([screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8)) / 2 + conf_b[1] + 0.3, -(w2/2), 0])
			rotate([90,0,0])
				nut_hole(type=nut_M3);
	
		// screw head hole
		translate([screw_dia(v_screw_hole(screw_M3_socket_head,$fn=8)) / 2 + conf_b[1] + 0.3, (w1/2), 0])
			rotate([90,0, 0])
				screw_hole(type=screw_M3_socket_head, h=w1+2, head_drop=(w1-w2)/2, washer_type=washer_M3, $fn=8);

	}
}


module linear_negative(conf_b = bushing, h = 0){
    //selects right negative based on type
    if (conf_b[3] == 0) {
        linear_bearing_negative(conf_b, h);
    } else {
        linear_bushing_negative(conf_b, h);
    }
}

module linear(conf_b = bushing, h = bushing_holder_height){
    //selects right negative based on type
    if (conf_b[3] == 0) {
        linear_bearing(conf_b, h);
    } else {
        linear_bushing(conf_b, h);
    }
    %linear_negative(conf_b, h);
}

//linear_bearing(conf_b=bushing, h=bushing_holder_height);

    linear_bearing_clamp_with_foot(length=bushing_holder_height);
    //translate([0,52,0]) bearing_clamp2(w1=30,w2=20 );
    
    //translate([0,52,0]) linear();