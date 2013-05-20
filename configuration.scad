// PRUSA iteration3
// Configuration file
// GNU GPL v3
// Josef Pr?sa <josefprusa@me.com>
// Václav 'ax' H?la <axtheb@gmail.com>
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

// PLEASE SELECT ONE OF THE CONFIGURATIONS BELOW
// BY UN-COMMENTING IT

// functions
include <inc/functions.scad>;
include <inc/nuts_screws.scad>;
include <inc/conf_bushing.scad>;
include <inc/conf_bearing.scad>;

stepper_motor_height=42;
stepper_motor_width=42;
stepper_motor_padded=stepper_motor_width+2;

layer_height = 0.3;
width_over_thickness = 2.2;
//calculated from settings
single_wall_width = width_over_thickness * layer_height;

use_fillets=true;
// Custom settings here, tailor to your supplies and print settings

rod_allowance=0.2;
lead_screw = screw_M6;
lead_screw_nut = nut_M6;
x_axis_smooth_rod_diameter = 8;
x_axis_smooth_rod_separation = 50;

base_size = [68.2, 40, 9];

lead_screw_to_smooth_rod_separation = 30;

base_clamp_gap=1;

y_offset=3;

bushing_mounting_screw = screw_M4_socket_head;
bushing_mounting_nut = nut_M4;

bushing = conf_b_lm8uu;
max_bushing_length = 30;
bushing_retainer_add=(9*layer_height);

bushing_rod_to_wall = 16;

bushing_holder_height= (max_bushing_length+bushing_retainer_add);
bushing_mount_thickness = 5;
max_bushing_outside_diameter = 22;

bushing_mount_hole_spacing = (max_bushing_outside_diameter + 8*single_wall_width + 2 + screw_head_top_dia(v_screw_hole(screw_M4_socket_head))/2);

z_axis_smooth_rod_diameter = (bushing[0]*2);

idler_screw = screw_M8_socket_head;
idler_nut = nut_M8;
idler_height = 27; // 25
idler_bearing = bearing_608;
idler_wall_height=bushing_holder_height+base_size[2]+1; //(idler_height+ bearing_out_dia(idler_bearing)/2);
idler_wall_thickness=6;

motor_support_height=3;
motor_wall_thickness=6;

smooth_rod_clamp_screw_hole_spacing_x = 32;
smooth_rod_clamp_screw_hole_spacing_y = 27;

smooth_rod_clamp_screw = screw_M4_socket_head;
smooth_rod_clamp_nut = nut_M4;

lead_screw_nut_support_outer_dia = (nut_outer_dia(v_nut_hole(lead_screw_nut))+6);