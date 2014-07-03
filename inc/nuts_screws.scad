// Nuts_screws.scad
// Released under Attribution 3.0 Unported (CC BY 3.0) 
// http://creativecommons.org/licenses/by/3.0/
// Stephanie Shaltes
include <functions.scad>;
include <../printer_conf.scad>

// Allowances for tolerance
// Horizontal settings
screw_hole_allowance_horizontal = 0.2;
screw_head_allowance_horizontal = 0.6;
screw_head_allowance_tight_horizontal = 0.2;

rod_hole_allowance_horizontal = 0.2;

nut_hole_allowance_horizontal = 0.2;
nut_thickness_allowance_horizontal = 0.2;

washer_hole_allowance_horizontal = 0.5;
washer_hole_allowance_tight_horizontal = 0.2;
washer_thickness_allowance_horizontal = 0.05;

// Vertical settings
screw_hole_allowance_vertical = 0.2;
screw_head_allowance_vertical = 0.6;
screw_head_allowance_tight_vertical = 0.2;

rod_hole_allowance_vertical = 0.2;

nut_hole_allowance_vertical = 0.2;
nut_thickness_allowance_vertical = 0.2;

washer_hole_allowance_vertical = 0.5;
washer_hole_allowance_tight_vertical = 0.2;
washer_thickness_allowance_vertical = 0.05;

//************* screw access functions *************
function screw_dia(type)  = type[0];
function screw_head_bottom_dia(type)  = type[1];
function screw_head_top_dia(type)  = type[2];
function screw_head_height(type) = type[3];
function screw_name(type) = type[4];
// diameter = 0; head_dia_bottom = 1; head_dia_top = 2; head_height = 3
// name = 4
function v_screw_hole(type, hole_allowance=-1, head_allowance=-1, $fn, horizontal=false) = 
	[((hole_fit(screw_dia(type),$fn))+ ((hole_allowance==-1) ? ((horizontal) ? screw_hole_allowance_horizontal : screw_hole_allowance_vertical) : hole_allowance)),
	(hole_fit(screw_head_bottom_dia(type), $fn))+ ((head_allowance==-1) ? ((horizontal) ? screw_head_allowance_horizontal : screw_head_allowance_vertical) : head_allowance),
	(hole_fit(screw_head_top_dia(type), $fn))+ ((head_allowance==-1) ? ((horizontal) ? screw_head_allowance_horizontal : screw_head_allowance_vertical) : head_allowance),
	screw_head_height(type),
	screw_name(type)];

function Inch_screw_to_Metric(type) = 
	[screw_dia(type) * 24.5,
	screw_head_bottom_dia(type) * 24.5,
	screw_head_top_dia(type) * 24.5,
	screw_head_height(type) * 24.5,
	screw_name(type)];

//************* nut access functions *************
function nut_dia(type)  = type[0];
function nut_flat(type)  = type[1];
function nut_outer_dia(type)  = (nut_flat(type)/cos(30));
function nut_thickness(type)  = type[2];
function nut_name(type)  = type[3];
// diameter = 0; nut flat = 1; nut thickness = 2; multiplier = 3 (multiplier should be set to 1, since values are already converted)
function v_nut_hole(type, hole_allowance=-1, thickness_allowance=-1, horizontal=false) = 
	[nut_dia(type),
	nut_flat(type)+ ((hole_allowance==-1) ? ((horizontal) ? nut_hole_allowance_horizontal : nut_hole_allowance_vertical) : hole_allowance),
	nut_thickness(type)+ ((thickness_allowance==-1) ? ((horizontal) ? nut_thickness_allowance_horizontal : nut_thickness_allowance_vertical) : thickness_allowance),
	nut_name(type)];

function Inch_nut_to_Metric(type) = 
	[nut_dia(type) * 24.5,
	nut_flat(type) * 24.5,
	nut_thickness(type) * 24.5,
	nut_name(type)];


//************* washer access functions *************
function washer_dia(type)  = type[0];
function washer_outer_dia(type)  = type[1];
function washer_thickness(type)  = type[2];
function washer_name(type)  = type[3];
// diameter = 0; outer diameter = 1; washer thickness = 2; multiplier = 3 (multiplier should be set to 1, since values are already converted)
function v_washer_hole(type, hole_allowance=-1, thickness_allowance=-1, $fn, horizontal=false) =
	[washer_dia(type),
	(hole_fit(washer_outer_dia(type), $fn)) + ((hole_allowance==-1) ? ((horizontal) ? washer_hole_allowance_horizontal : washer_hole_allowance_vertical) : hole_allowance),
	washer_thickness(type) + ((thickness_allowance==-1) ? ((horizontal) ? washer_thickness_allowance_horizontal : washer_thickness_allowance_vertical) : thickness_allowance) ,
	washer_name(type)];

function Inch_washer_to_Metric(type) =
	[washer_dia(type) * 24.5,
	washer_outer_dia(type) * 24.5,
	washer_thickness(type) * 24.5,
	washer_name(type)];


function v_rod_hole(d=0, allowance=-1, $fn=0, horizontal=false) =
	hole_fit(d, (($fn>0) ? $fn : poly_sides(d))) + ((allowance==-1) ? ((horizontal) ? rod_hole_allowance_horizontal : rod_hole_allowance_vertical) : allowance);

// modules
module screw(h=20, head_drop=0, type=screw_M3_socket_head, washer_type=0, poly=false, $fn=0){
    //makes screw with head
    
    head_bottom_dia= screw_head_bottom_dia(type);
    head_top_dia= screw_head_top_dia(type);
	
	head_height= screw_head_height(type);
	
    union() {
	    translate([0, 0, head_drop- ((washer_type[0]>0) ? washer_thickness(washer_type) : 0)]) {
			translate([0, 0, -0.01]) {
			    if (poly) {
			        cylinder_poly(h=h+0.01, r=screw_dia(type)/2, $fn=$fn);
			    } else {
			        cylinder(h=h+0.01, r=screw_dia(type)/2, $fn=$fn);
			    }
			}
		    
		    translate([0, 0, ((screw_head_bottom_dia(type) < screw_head_top_dia(type)) ? 0 : -head_height)]) {
				translate([0, 0, head_height]) washer(type=washer_type, $fn=$fn);
		    	translate([0, 0, -0.01])
		    	cylinder(h=head_height+0.02, r2=head_bottom_dia/2, r1=head_top_dia/2, $fn=$fn);
			}
		}
	}
}

// length is used to create a slotted hole
module screw_hole(h=20, length=0, head_drop=0, type=screw_M3_socket_head, washer_type=0, hole_support=false, allowance=-1, horizontal=false){
    //makes screw with head
    screw=v_screw_hole(type, hole_allowance = allowance, head_allowance = ((screw_head_bottom_dia(type) < screw_head_top_dia(type)) ? ((horizontal) ? screw_head_allowance_tight_horizontal : screw_head_allowance_tight_vertical) : ((horizontal) ? screw_head_allowance_horizontal : screw_head_allowance_vertical)), $fn=$fn, horizontal=horizontal);
    
    head_bottom_dia= (washer_outer_dia(washer_type)>screw_head_bottom_dia(screw)) ? washer_outer_dia(v_washer_hole(washer_type, $fn=$fn)) : screw_head_bottom_dia(screw);
    head_top_dia= (washer_outer_dia(washer_type)>screw_head_top_dia(screw)) ? washer_outer_dia(v_washer_hole(washer_type, $fn=$fn)) : screw_head_top_dia(screw);
	
	head_height = ((screw_head_bottom_dia(screw) < screw_head_top_dia(screw)) ? screw_head_height(screw) : head_drop);
	head_drop1= ((screw_head_bottom_dia(screw) < screw_head_top_dia(screw)) ? screw_head_height(screw)+head_drop : head_drop);
	
    translate([0, 0, head_drop1]) {
	     difference() {
	     	union() {
				translate([0, 0, -0.01]) {
					cylinder_slot(h=h+0.02, r=screw_dia(screw)/2, length=length, $fn=$fn);
               }
		 	   render(convexity = 6)
		 	   if (head_height>0) {
				    translate([0, 0, -head_height-0.01]) {						
						cylinder_slot(h=head_height+0.02, r2=head_bottom_dia/2, r1=head_top_dia/2, length=length, $fn=$fn);
					}
					translate([0, 0, -head_drop1]) {
						cylinder_slot(h=head_drop1-head_height, r=head_top_dia/2, length=length, $fn=$fn);
					}
				}
			}
			render(convexity = 6)
			if (hole_support) translate([0, 0, -0.01]) {
				cylinder_slot(h=layer_height+0.02, r=head_top_dia/2, length=length, $fn=$fn);
			}
		}
	}
}

module rod_hole(d=0, h=0, allowance=-1, length=0, $fn=0, center=false, horizontal=false){
	//makes a rod hole
	dia = v_rod_hole(d=d, allowance=allowance, $fn=$fn, horizontal=horizontal);
	cylinder_slot(h=h, r=dia/2, length=length, $fn=$fn, center=center);
}

module nut(type=nut_M3, h=0){
	//makes a nut
	cylinder(h=((h>0) ? h : nut_thickness(type)), r=nut_outer_dia(type)/2, $fn=6);
}

module nut_hole(type=nut_M3, thickness=0, nut_slot=0, horizontal=false, allowance=-1){
	//makes a nut hole
	nut_h=v_nut_hole(type, horizontal=horizontal, hole_allowance = allowance);
	nut_thickness=((thickness>0) ? (thickness+0.01) : (nut_thickness(nut_h)+0.01));
	start=((nut_slot>0) ? 2 : 1);
	stop=((nut_slot>0) ? 4 : 6);
	// fix manifold
	//translate ([0,0,-0.001])
	render() union() {
		hull() {
	 		cylinder(h=nut_thickness, r=nut_outer_dia(nut_h)/2, $fn=6);
			if (nut_slot>0) translate([0, -(nut_flat(nut_h))/2, 0]) cube([nut_slot+0.01, (nut_flat(nut_h)), nut_thickness]);
	    }
		if (!horizontal) for(i = [start:stop])
			rotate([0,0,60*i]) translate([nut_outer_dia(nut_h)/2-0.45,0,0]) rotate([0,0,-45]) cylinder(r=0.75, h=nut_thickness, $fn=8);
	}
}

module washer(type=washer_M3, $fn=0){
	//makes a washer
	color([150/255, 150/255, 150/255, 0.7]) rotate([0,0, 180/(($fn>0) ? $fn : poly_sides(washer_outer_dia(type)))])
	render(convexity = 4) cylinder_poly(h=washer_thickness(type), r=washer_outer_dia(type)/2, $fn=$fn);
}

module washer_hole(type=washer_M3, $fn=0, horizontal=false){
	//makes a washer hole
	washer_h=v_washer_hole(type=type, $fn=$fn, horizontal=horizontal);
	cylinder_poly(h=washer_thickness(washer_h)+0.01, r=washer_outer_dia(washer_h)/2, $fn=$fn);
}

// Use this for screw clamps
// Length will be l + outer_radius_add*2
module screw_trap(l=20, screw=screw_M3_socket_head, nut=nut_M3, add_inner_support=0.5, outer_radius_add=2, $fn=8, horizontal=false){
	inner_r = (
		(screw_head_top_dia(v_screw_hole(screw,$fn=$fn, horizontal=horizontal)) > nut_outer_dia(v_nut_hole(nut, horizontal=horizontal)))
		? screw_head_top_dia(v_screw_hole(screw,$fn=$fn, horizontal=horizontal)) : nut_outer_dia(v_nut_hole(nut, horizontal=horizontal))
		)/2 + add_inner_support;
	intersection() {
		rotate([0,0,180/$fn])
		union() {
			translate([0, 0, l/2])
				cylinder(r2=inner_r, r1=inner_r + outer_radius_add, h=outer_radius_add, $fn=$fn);
			
			translate([0, 0, -l/2-outer_radius_add])
				cylinder(r1=inner_r, r2=inner_r + outer_radius_add, h=outer_radius_add, $fn=$fn);
			
			translate([0, 0, 0])
				cylinder(r=inner_r + outer_radius_add, h=l+0.002, $fn=$fn, center=true);
		}
		
		translate([(inner_r)+outer_radius_add/2-sagitta_radius( inner_r-outer_radius_add/2,
			(inner_r + outer_radius_add)), 0, 0])
			cylinder_poly(r=
			sagitta_radius( inner_r-outer_radius_add/2,
			(inner_r + outer_radius_add)),
			h=l+outer_radius_add*2+1,
			center=true);
			
	}
}

module screw_nut_negative(l=20, screw=screw_M3_socket_head, nut=nut_M3, nut_slot=0, nut_drop=0, nut_thickness=0, head_drop=0, washer_type, $fn=0, center=false, horizontal=false){
	translate([0,0,((center) ? -(l)/2 : 0)]) {
		// nut trap
		translate([0,0,l-nut_drop])
			nut_hole(type=nut_M3, nut_slot=nut_slot, horizontal=horizontal, thickness=nut_thickness);
	
		// screw head hole
		screw_hole(type=screw, h=l-head_drop+0.001, head_drop=head_drop, washer_type=washer_type, $fn=$fn, horizontal=horizontal);
	}
}

// Inch diameters
INCH_n1 =   0.073; // 0.073  * 25.4
INCH_n2 =   0.086; // 0.086  * 25.4
INCH_n3 =   0.099; // 0.099  * 25.4
INCH_n4 =   0.112; // 0.112  * 25.4
INCH_n5 =   0.125; // 0.125  * 25.4
INCH_n6 =   0.138; // 0.138  * 25.4
INCH_n8 =   0.164; // 0.164  * 25.4
INCH_n10 =  0.190; // 0.190  * 25.4
INCH_n12 =  0.216; // 0.216  * 25.4
INCH_1_4  = 0.250;   // 1/4  * 25.4
INCH_5_16 = 0.3125; // 5/16  * 25.4
INCH_3_8  = 0.375;  // 3/8  * 25.4
INCH_1_2  = 0.500;   // 1/2  * 25.4

// Metric diameters
METRIC_M2p5 = 2.5;
METRIC_M3 =   3;
METRIC_M4 =   4;
METRIC_M5 =   5;
METRIC_M6 =   6;
METRIC_M8 =   8;
METRIC_M10 =  10;
METRIC_M12 =  12;

// Screw parameters
// diameter = 0
// head_dia_bottom = 1
// head_dia_top = 2
// head_height = 3
// name = 4
// [screw_dia, head_bottom_dia, head_top_dia, head_height, name]

//(inch) Rods (Generic)
rod_inch_n1 =   Inch_screw_to_Metric([INCH_n1, 0, 0, 0, "(Generic) (inch) #2 Rod"]);
rod_inch_n2 =   Inch_screw_to_Metric([INCH_n2, 0, 0, 0, "(Generic) (inch) #2 Rod"]);
rod_inch_n3 =   Inch_screw_to_Metric([INCH_n3, 0, 0, 0, "(Generic) (inch) #3 Rod"]);
rod_inch_n4 =   Inch_screw_to_Metric([INCH_n4, 0, 0, 0, "(Generic) (inch) #4 Rod"]);
rod_inch_n5 =   Inch_screw_to_Metric([INCH_n5, 0, 0, 0, "(Generic) (inch) #5 Rod"]);
rod_inch_n6 =   Inch_screw_to_Metric([INCH_n6, 0, 0, 0, "(Generic) (inch) #6 Rod"]);
rod_inch_n8 =   Inch_screw_to_Metric([INCH_n8, 0, 0, 0, "(Generic) (inch) #8 Rod"]);
rod_inch_n10 =  Inch_screw_to_Metric([INCH_n10, 0, 0, 0, "(Generic) (inch) #10 Rod"]);
rod_inch_n12 =  Inch_screw_to_Metric([INCH_n12, 0, 0, 0, "(Generic) (inch) #10 Rod"]);
rod_inch_1_4 =  Inch_screw_to_Metric([INCH_1_4,  0, 0, 0, "(Generic) (inch) 1/4 Rod"]);
rod_inch_5_16 = Inch_screw_to_Metric([INCH_5_16, 0, 0, 0, "(Generic) (inch) 5/16 Rod"]);
rod_inch_3_8 =  Inch_screw_to_Metric([INCH_3_8,  0, 0, 0, "(Generic) (inch) 3/8 Rod"]);
rod_inch_1_2 =  Inch_screw_to_Metric([INCH_1_2,  0, 0, 0, "(Generic) (inch) 1/2 Rod"]);

// Metric Rods (Generic)
rod_M2p5 = [METRIC_M2p5, 0, 0, 0, "(Generic) Metric Rod M2.5 "];
rod_M3 =   [  METRIC_M3, 0, 0, 0, "(Generic) Metric Rod M3"];
rod_M4 =   [  METRIC_M4, 0, 0, 0, "(Generic) Metric Rod M4"];
rod_M5 =   [  METRIC_M5, 0, 0, 0, "(Generic) Metric Rod M5"];
rod_M6 =   [  METRIC_M6, 0, 0, 0, "(Generic) Metric Rod M6"];
rod_M8 =   [  METRIC_M8, 0, 0, 0, "(Generic) Metric Rod M8"];
rod_M10 =  [ METRIC_M10, 0, 0, 0, "(Generic) Metric Rod M10"];
rod_M12 =  [ METRIC_M12, 0, 0, 0, "(Generic) Metric Rod M10"];


//************* 8020inc(inch) screws *************
// http://www.3dcontentcentral.com/parts/supplier/80%2020-Inc/9/14/620.aspx
//                            [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_8020_1_4_flange_head =  [6.35, 13.08, 13.08, 3.08, "8020inc #3066 #3342 #3390 1/4-20 Flange Screw"];
screw_8020_5_16_flange_head = [7.94, 16.93, 16.93, 4.13, "8020inc #3330 #3340 5/16-18 Flange Screw"];
screw_8020_1_4_button_head =  [6.35,  11.1,  11.1, 3.35, "8020inc #3059 1/4-20 Button Head Screw"];
screw_8020_5_16_button_head = [7.94, 13.89, 13.89, 4.22, "8020inc #3104 5/16-18 Button Head Screw"];
screw_8020_1_4_socket_head =  [6.35,  9.52,  9.52, 6.35, "8020inc #3058 1/4-20 Socket Head Screw"];
screw_8020_5_16_socket_head = [7.94, 12.41, 12.41, 8.45, "8020inc #3106 5/16-18 Socket Head Screw"];
screw_8020_1_4_flat_head =    [6.35,  6.35, 13.56, 4.14, "8020inc #3400 1/4-20 CounterSunk Flat Head Screw"];
screw_8020_5_16_flat_head =   [7.94,  7.94, 16.66, 5.07, "8020inc #3410 5/16-18 CounterSunk Flat Head Screw"];

//************* Generic (inch) Button Head screws *************
//                                                 [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_inch_2_button_head =    Inch_screw_to_Metric([INCH_n2,  0.164, 0.164, 0.046, "(Generic) (inch) #2 Button Head"]);
screw_inch_3_button_head =    Inch_screw_to_Metric([INCH_n3,  0.188, 0.188, 0.052, "(Generic) (inch) #3 Button Head"]);
screw_inch_4_button_head =    Inch_screw_to_Metric([INCH_n4,  0.213, 0.213, 0.059, "(Generic) (inch) #4 Button Head"]);
screw_inch_5_button_head =    Inch_screw_to_Metric([INCH_n5,  0.238, 0.238, 0.066, "(Generic) (inch) #5 Button Head"]);
screw_inch_6_button_head =    Inch_screw_to_Metric([INCH_n6,  0.262, 0.262, 0.073, "(Generic) (inch) #6 Button Head"]);
screw_inch_8_button_head =    Inch_screw_to_Metric([INCH_n8,  0.312, 0.312, 0.087, "(Generic) (inch) #8 Button Head"]);
screw_inch_10_button_head =   Inch_screw_to_Metric([INCH_n10,  0.361, 0.361, 0.101, "(Generic) (inch) #10 Button Head"]);
screw_inch_1_4_button_head =  Inch_screw_to_Metric([INCH_1_4,  0.437, 0.437, 0.132, "(Generic) (inch) 1/4 Button Head"]);
screw_inch_5_16_button_head = Inch_screw_to_Metric([INCH_5_16, 0.547, 0.547, 0.166, "(Generic) (inch) 5/16 Button Head"]);
screw_inch_3_8_button_head =  Inch_screw_to_Metric([INCH_3_8,  0.656, 0.656, 0.199, "(Generic) (inch) 3/8 Button Head"]);
screw_inch_1_2_button_head =  Inch_screw_to_Metric([INCH_1_2,  0.675, 0.675, 0.265, "(Generic) (inch) 1/2 Button Head"]);

//************* Generic (inch) Socket Head screws *************
//                                                 [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_inch_2_socket_head =    Inch_screw_to_Metric([INCH_n2, 0.140, 0.140, INCH_n2, "(Generic) (inch) #2 Socket Head"]);
screw_inch_3_socket_head =    Inch_screw_to_Metric([INCH_n3, 0.161, 0.161, INCH_n3, "(Generic) (inch) #3 Socket Head"]);
screw_inch_4_socket_head =    Inch_screw_to_Metric([INCH_n4, 0.183, 0.183, INCH_n4, "(Generic) (inch) #4 Socket Head"]);
screw_inch_5_socket_head =    Inch_screw_to_Metric([INCH_n5, 0.205, 0.205, INCH_n5, "(Generic) (inch) #5 Socket Head"]);
screw_inch_6_socket_head =    Inch_screw_to_Metric([INCH_n6, 0.226, 0.226, INCH_n6, "(Generic) (inch) #6 Socket Head"]);
screw_inch_8_socket_head =    Inch_screw_to_Metric([INCH_n8, 0.270, 0.270, INCH_n8, "(Generic) (inch) #8 Socket Head"]);
screw_inch_10_socket_head =   Inch_screw_to_Metric([INCH_n10, 0.312, 0.312, INCH_n10, "(Generic) (inch) #10 Socket Head"]);
screw_inch_1_4_socket_head =  Inch_screw_to_Metric([INCH_1_4,  0.375, 0.375,  INCH_1_4, "(Generic) (inch) 1/4 Socket Head"]);
screw_inch_5_16_socket_head = Inch_screw_to_Metric([INCH_5_16, 0.469, 0.469, INCH_5_16, "(Generic) (inch) 5/16 Socket Head"]);
screw_inch_3_8_socket_head =  Inch_screw_to_Metric([INCH_3_8,  0.563, 0.563,  INCH_3_8, "(Generic) (inch) 3/8 Socket Head"]);
screw_inch_1_2_socket_head =  Inch_screw_to_Metric([INCH_1_2,  0.750, 0.750,  INCH_1_2, "(Generic) (inch) 1/2 Socket Head"]);

//************* Generic (inch) Flat Head (countersunk) Screws *************
//                                               [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_inch_2_flat_head =    Inch_screw_to_Metric([INCH_n2,  INCH_n2,  0.197, 0.064, "(Generic) (inch) #2 Flat Head (countersunk) Screw"]);
screw_inch_3_flat_head =    Inch_screw_to_Metric([INCH_n3,  INCH_n3,  0.226, 0.073, "(Generic) (inch) #3 Flat Head (countersunk) Screw"]);
screw_inch_4_flat_head =    Inch_screw_to_Metric([INCH_n4,  INCH_n4,  0.255, 0.083, "(Generic) (inch) #4 Flat Head (countersunk) Screw"]);
screw_inch_5_flat_head =    Inch_screw_to_Metric([INCH_n5,  INCH_n5,  0.281, 0.090, "(Generic) (inch) #5 Flat Head (countersunk) Screw"]);
screw_inch_6_flat_head =    Inch_screw_to_Metric([INCH_n6,  INCH_n6,  0.307, 0.097, "(Generic) (inch) #6 Flat Head (countersunk) Screw"]);
screw_inch_8_flat_head =    Inch_screw_to_Metric([INCH_n8,  INCH_n8,  0.359, 0.112, "(Generic) (inch) #8 Flat Head (countersunk) Screw"]);
screw_inch_10_flat_head =   Inch_screw_to_Metric([INCH_n10,  INCH_n10,  0.411, 0.127, "(Generic) (inch) #10 Flat Head (countersunk) Screw"]);
screw_inch_1_4_flat_head =  Inch_screw_to_Metric([INCH_1_4,  INCH_1_4,  0.531, 0.161, "(Generic) (inch) 1/4 Flat Head (countersunk) Screw"]);
screw_inch_5_16_flat_head = Inch_screw_to_Metric([INCH_5_16, INCH_5_16, 0.656, 0.198, "(Generic) (inch) 5/16 Flat Head (countersunk) Screw"]);
screw_inch_3_8_flat_head =  Inch_screw_to_Metric([INCH_3_8,  INCH_3_8,  0.781, 0.234, "(Generic) (inch) 3/8 Flat Head (countersunk) Screw"]);
screw_inch_1_2_flat_head =  Inch_screw_to_Metric([INCH_1_2,  INCH_1_2,  0.938, 0.251, "(Generic) (inch) 1/2 Flat Head (countersunk) Screw"]);

//************* Generic Metric Button Head screws *************
//                      [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_M3_button_head =  [ METRIC_M3,  5.7,  5.7, 1.65, "(Generic) Metric M3 Button Head"];
screw_M4_button_head =  [ METRIC_M4,  7.6,  7.6,  2.2, "(Generic) Metric M4 Button Head"];
screw_M5_button_head =  [ METRIC_M5,  9.5,  9.5, 2.75, "(Generic) Metric M5 Button Head"];
screw_M6_button_head =  [ METRIC_M6, 10.5, 10.5,  3.3, "(Generic) Metric M6 Button Head"];
screw_M8_button_head =  [ METRIC_M8,   14,   14,  4.4, "(Generic) Metric M8 Button Head"];
screw_M10_button_head = [METRIC_M10, 17.5, 17.5,  5.5, "(Generic) Metric M10 Button Head"];

//************* Generic Metric Socket Head screws *************
//                       [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_M2p5_socket_head = [METRIC_M2p5, 4.5, 4.5, 2.5, "(Generic) Metric M2.5 Socket Head"];
screw_M3_socket_head =   [  METRIC_M3, 5.5, 5.5,   3, "(Generic) Metric M3 Socket Head"];
screw_M4_socket_head =   [  METRIC_M4,   7,   7,   4, "(Generic) Metric M4 Socket Head"];
screw_M5_socket_head =   [  METRIC_M5, 8.5, 8.5,   5, "(Generic) Metric M5 Socket Head"];
screw_M6_socket_head =   [  METRIC_M6,  10,  10,   6, "(Generic) Metric M6 Socket Head"];
screw_M8_socket_head =   [  METRIC_M8,  13,  13,   8, "(Generic) Metric M8 Socket Head"];
screw_M10_socket_head =  [ METRIC_M10,  16,  16,  10, "(Generic) Metric M10 Socket Head"];

//************* Generic Metric Flat Head screws *************
//                    [screw_dia, head_bottom_dia, head_top_dia, head_height, name]
screw_M3_flat_head =  [ METRIC_M3,  3,  6.72,  1.83, "(Generic) Metric M3 Flat Head"];
screw_M4_flat_head =  [ METRIC_M4,  4,  8.96,  2.48, "(Generic) Metric M4 Flat Head"];
screw_M5_flat_head =  [ METRIC_M5,  5,  11.2,  3.10, "(Generic) Metric M5 Flat Head"];
screw_M6_flat_head =  [ METRIC_M6,  6, 13.44,  3.72, "(Generic) Metric M6 Flat Head"];
screw_M8_flat_head =  [ METRIC_M8,  8, 17.92,  4.96, "(Generic) Metric M8 Flat Head"];
screw_M10_flat_head = [METRIC_M10, 10,  22.4,  6.20, "(Generic) Metric M10 Flat Head"];

//************* Generic Metric washers *************
// inner diameter = 0
// outer diameter = 1
// thickness = 2
// name = 3
washer_M2p5 = [ 2.7,    6, 0.5, "(Generic) Metric M2.5 Washer"];
washer_M3 =   [ 3.2,    7, 0.5, "(Generic) Metric M3 Washer"];
washer_M3p5 = [ 3.7,    8, 0.5, "(Generic) Metric M3.5 Washer"];
washer_M4 =   [ 4.3,    9, 0.8, "(Generic) Metric M4 Washer"];
washer_M5 =   [ 5.3,   10, 1.0, "(Generic) Metric M5 Washer"];
washer_M6 =   [ 6.4, 12.5, 1.6, "(Generic) Metric M6 Washer"];
washer_M8 =   [ 8.4,   17, 1.6, "(Generic) Metric M8 Washer"];
washer_M8_double =   [ 8.4,   17, 3.2, "(Generic) Metric M8 Washer (Doubled)"];
washer_M10 =  [10.5,   21,   2, "(Generic) Metric M10 Washer"];

// Metric Fender washers
washer_fender_M2p5 = [ 2.7,    8, 0.8, "(Generic) Metric M2.5 Fender Washer"];
washer_fender_M3 =   [ 3.2,    9, 0.8, "(Generic) Metric M3 Fender Washer"];
washer_fender_M4 =   [ 4.3,   12, 1.0, "(Generic) Metric M4 Fender Washer"];
washer_fender_M5 =   [ 5.3,   15, 1.2, "(Generic) Metric M5 Fender Washer"];
washer_fender_M6 =   [ 6.4,   18, 1.6, "(Generic) Metric M6 Fender Washer"];
washer_fender_M8 =   [ 8.4,   24, 2.0, "(Generic) Metric M8 Fender Washer"];
washer_fender_M10 =  [10.5,   30, 2.5, "(Generic) Metric M10 Fender Washer"];

//************* Generic(inch) washers *************
// SAE standard washers
washer_inch_2 =          Inch_washer_to_Metric([  3/32,   7/32, 0.03, "(Generic) (inch) #2 Washer"]);
washer_inch_3 =          Inch_washer_to_Metric([  7/64,    1/4, 0.03, "(Generic) (inch) #3 Washer"]);
washer_inch_4 =          Inch_washer_to_Metric([   1/8,   5/16, 0.04, "(Generic) (inch) #4 Washer"]);
washer_inch_5 =          Inch_washer_to_Metric([  9/64,   9/32, 0.04, "(Generic) (inch) #5 Washer"]);
washer_inch_6 =          Inch_washer_to_Metric([  5/32,    3/8, 0.07, "(Generic) (inch) #6 Washer"]);
washer_inch_8 =          Inch_washer_to_Metric([  3/16,   7/16, 0.07, "(Generic) (inch) #8 Washer"]);
washer_inch_10 =         Inch_washer_to_Metric([  7/32,    1/2, 0.07, "(Generic) (inch) #10 Washer"]);
washer_inch_1_4 =        Inch_washer_to_Metric([  9/32,    5/8, 0.08, "(Generic) (inch) 1/4 Washer"]);
washer_inch_5_16 =       Inch_washer_to_Metric([ 11/32,  11/16, 0.08, "(Generic) (inch) 5/16 Washer"]);
washer_inch_3_8 =        Inch_washer_to_Metric([ 13/32,  13/16, 0.08, "(Generic) (inch) 3/8 Washer"]);
washer_inch_1_2 =        Inch_washer_to_Metric([ 17/32, 1+1/16, 0.13, "(Generic) (inch) 1/2 Washer"]);

//(inch) Fender washers
washer_fender_inch_8 =          Inch_washer_to_Metric([ 11/64, 3/4, 0.05, "(Generic) (inch) #8 Fender Washer"]);
washer_fender_inch_10 =         Inch_washer_to_Metric([ 13/64, 1/2, 0.05, "(Generic) (inch) #10 Fender Washer"]);
washer_fender_inch_1_4_od_1_2 = Inch_washer_to_Metric([ 17/64, 1/2, 0.06, "(Generic) (inch) 1/4 ID 1/2 OD Fender Washer"]);
washer_fender_inch_1_4_od_1 =   Inch_washer_to_Metric([  9/32,   1, 0.06, "(Generic) (inch) 1/4 ID 1 OD Fender Washer"]);
washer_fender_inch_5_16 =       Inch_washer_to_Metric([ 11/32, 5/8, 0.08, "(Generic) (inch) 5/16 Fender Washer"]);
washer_fender_inch_3_8 =        Inch_washer_to_Metric([ 13/32,   1, 0.08, "(Generic) (inch) 3/8 Fender Washer"]);
washer_fender_inch_1_2 =        Inch_washer_to_Metric([ 17/32, 1.5, 0.08, "(Generic) (inch) 1/2 Fender Washer"]);

//************* Generic Metric nuts *************
// inner diameter = 0
// flat size = 1
// thickness = 2
// name = 3
nut_M2p5 = [ 2.5,   5,   2, "(Generic) Metric M2.5 Nut"];
nut_M3 =   [   3, 5.5, 2.4, "(Generic) Metric M3 Nut"];
nut_M4 =   [   4,   7, 3.2, "(Generic) Metric M4 Nut"];
nut_M5 =   [   5,   8,   4, "(Generic) Metric M5 Nut"];
nut_M6 =   [   6,  10,   5, "(Generic) Metric M6 Nut"];
nut_M8 =   [   8,  13, 6.5, "(Generic) Metric M8 Nut"];
nut_M10 =  [  10,  16,   8, "(Generic) Metric M10 Nut"];

// Jam nuts, also known as half height nuts
nut_jam_M2p5 = [ 2.5,   5, 1.6, "(Generic) Metric M2.5 Jam (half height) Nut"];
nut_jam_M3 =   [   3, 5.5, 1.8, "(Generic) Metric M3 Jam (half height) Nut"];
nut_jam_M4 =   [   4,   7, 2.2, "(Generic) Metric M4 Jam (half height) Nut"];
nut_jam_M5 =   [   5,   8, 2.7, "(Generic) Metric M5 Jam (half height) Nut"];
nut_jam_M6 =   [   6,  10, 3.2, "(Generic) Metric M6 Jam (half height) Nut"];
nut_jam_M8 =   [   8,  13,   4, "(Generic) Metric M8 Jam (half height) Nut"];
nut_jam_M10 =  [  10,  16,   5, "(Generic) Metric M10 Jam (half height) Nut"];

//************* Generic(inch) nuts *************
// inner diameter = 0
// flat size = 1
// thickness = 2
// name = 3
nut_inch_2 =        Inch_nut_to_Metric([INCH_n2,  3/16,  1/16, "(Generic) (inch) #2 Nut"]);
nut_inch_3 =        Inch_nut_to_Metric([INCH_n3,  3/16,  1/16, "(Generic) (inch) #3 Nut"]);
nut_inch_4 =        Inch_nut_to_Metric([INCH_n4,   1/4,  3/32, "(Generic) (inch) #4 Nut"]);
nut_inch_5 =        Inch_nut_to_Metric([INCH_n5,  5/16,  7/64, "(Generic) (inch) #5 Nut"]);
nut_inch_6 =        Inch_nut_to_Metric([INCH_n6,  5/16,  7/64, "(Generic) (inch) #6 Nut"]);
nut_inch_8 =        Inch_nut_to_Metric([INCH_n8, 11/32,   1/8, "(Generic) (inch) #8 Nut"]);
nut_inch_10 =       Inch_nut_to_Metric([INCH_n10,   3/8,   1/8, "(Generic) (inch) #10 Nut"]);
nut_inch_1_4 =      Inch_nut_to_Metric([INCH_1_4,  7/16,  7/32, "(Generic) (inch) 1/4 Nut"]);
nut_inch_5_16 =     Inch_nut_to_Metric([INCH_5_16,   1/2, 17/64, "(Generic) (inch) 5/16 Nut"]);
nut_inch_3_8 =      Inch_nut_to_Metric([INCH_3_8,  9/16, 21/64, "(Generic) (inch) 3/8 Nut"]);
nut_inch_1_2 =      Inch_nut_to_Metric([INCH_1_2,   3/4,  7/16, "(Generic) (inch) 1/2 Nut"]);

// Jam nuts, also known as half height nuts
nut_jam_inch_1_4 =  Inch_nut_to_Metric([INCH_1_4, 7/16, 5/32, "(Generic) (inch) 1/4 Jam (half height) Nut"]);
nut_jam_inch_5_16 = Inch_nut_to_Metric([INCH_5_16,  1/2, 3/16, "(Generic) (inch) 5/16 Jam (half height) Nut"]);
nut_jam_inch_3_8 =  Inch_nut_to_Metric([INCH_3_8, 9/16, 7/32, "(Generic) (inch) 3/8 Jam (half height) Nut"]);
nut_jam_inch_1_2 =  Inch_nut_to_Metric([INCH_1_2,  3/4, 5/16, "(Generic) (inch) 1/2 Jam (half height) Nut"]);