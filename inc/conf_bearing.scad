// Select idler bearing size **************************************************
function bearing_out_dia(type)  = type[0];
function bearing_width(type)  = type[1];
function bearing_inn_dia(type)  = type[2];
function bearing_uses_guide(type)  = type[3];

// [outer_diameter, width, inner_diameter, uses_guide]
// 608 [standard skate bearings] with bearing guide
bearing_608 = [22, 7, 8, 1];
//608 bearings with fender washers
bearing_608_washers = [22, 10, 8, 0];
// 624 [roughly same diameter as pulley, makes belt parallel so its prettier]
bearing_624 = [16, 5, 4, 1];
// two 624 - for use without bearing guides. My favourite [ax]
bearing_624_double = [16, 10, 4, 0];
// Size for 1/4" R4RS bearing
bearing_R4RS = [15.875, 4.9784, 6.35, 0];
// Size for 6mm 626RS bearing
bearing_626RS = [19, 6, 6, 0];

module idler(idler_bearing=[22, 7, 8, 1], center=false) {
	difference(){
		cylinder(r=idler_bearing[0]/2,h=idler_bearing[1], center = center);
		cylinder_poly(r=idler_bearing[2]/2,h=idler_bearing[1]+1, center = center);
	}
	
}