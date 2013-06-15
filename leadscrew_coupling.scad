include <configuration.scad>
include <inc/nuts_screws.scad>;

holeX = 7.5;
holeY = ((screw_dia(lead_screw)+lead_screw_coupling_tubing_wall_thickness*2)/2 +screw_dia(v_screw_hole(lead_screw_coupling_screw))/2+1);
coupling_size=[30,25,8];

module leadscrew_coupling(){
    union(){
        difference(){
            translate([0, 0, coupling_size[2]/2]) cube_fillet(size = coupling_size, center = true, vertical =[(coupling_size[1]-screw_dia(lead_screw)-lead_screw_coupling_tubing_wall_thickness*2-1)/2, (coupling_size[1]-screw_dia(lead_screw)-lead_screw_coupling_tubing_wall_thickness*2-1)/2, (coupling_size[1]-screw_dia(lead_screw)-lead_screw_coupling_tubing_wall_thickness*2-1)/2, (coupling_size[1]-screw_dia(lead_screw)-lead_screw_coupling_tubing_wall_thickness*2-1)/2]);

            //shaft groves
            translate([ -coupling_size[0]/2-0.1, 0, coupling_size[2]+lead_screw_coupling_gap/2]) rotate([0,90,0]) rod_hole(d=screw_dia(lead_screw)-0.5, h=coupling_size[0]/2+0.1, horizontal=true);
            translate([-0.1, 0, coupling_size[2]+lead_screw_coupling_gap/2]) rotate([0,90,0]) rod_hole(d=5+lead_screw_coupling_tubing_wall_thickness*2, h=coupling_size[0]/2+0.2, horizontal=true);

            //screw holes
            translate([ holeX,  holeY, 0]) screw_hole(type=lead_screw_coupling_screw, h=coupling_size[2]+0.1);
            translate([ holeX, -holeY, 0]) screw_hole(type=lead_screw_coupling_screw, h=coupling_size[2]+0.1);
            translate([-holeX,  holeY, 0]) screw_hole(type=lead_screw_coupling_screw, h=coupling_size[2]+0.1);
            translate([-holeX, -holeY, 0]) screw_hole(type=lead_screw_coupling_screw, h=coupling_size[2]+0.1);
            
            translate([ holeX, -holeY, -0.01]) nut_hole(type=lead_screw_coupling_nut);
            translate([-holeX, -holeY, -0.01]) nut_hole(type=lead_screw_coupling_nut);
        }
        translate([holeX, -holeY, nut_thickness(v_nut_hole(lead_screw_coupling_nut))+layer_height/2]) cube([screw_dia(v_screw_hole(lead_screw_coupling_screw))+0.5, screw_dia(v_screw_hole(lead_screw_coupling_screw))+0.5, layer_height], center=true);
        translate([-holeX, -holeY, nut_thickness(v_nut_hole(lead_screw_coupling_nut))+layer_height/2]) cube([screw_dia(v_screw_hole(lead_screw_coupling_screw))+0.5, screw_dia(v_screw_hole(lead_screw_coupling_screw))+0.5, layer_height], center=true);
    }
}

translate([0, 16, 0]) leadscrew_coupling();
translate([0, -16, 0]) leadscrew_coupling();