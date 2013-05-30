// Steph's i3 Varient

// Select your belt type ******************************************************

//tooth_distance = 0;
//tooth_ratio = 1;
//tooth_height = 2;
//height = 3;
//base_height = 4; //belt_height - tooth_height

//T2.5
conf_belt_T2_5 = [ 2.5, 0.5, 0.7, 1.3, 1.3-0.7];
//T5 (strongly discouraged)
conf_belt_T5 = [ 5, 0.75, 1.2, 2.2, 2.2-1.2];
//HTD3
conf_belt_HTD3 = [ 3, 0.75, 1.22, 2.41, 2.41-1.22];
//MXL
conf_belt_MXL = [ 2.032, 0.64, 0.46, 1.2, 1.2-0.46];
//GT2
conf_belt_GT2 = [ 2, 0.5, 0.76, 1.52, 1.52-0.76];
//GT2-3mm
conf_belt_GT2_3mm = [ 3, 0.5, 1.14, 2.41, 2.41-1.14];

// For some reason SDP-SI doesn't give us the height dimensions of the flange. So it has to be calculated.
// height=0;
// hub_height=1;
// belt_height=2;
// setscrew_height=3;
// setscrew_diameter=4;
// diameter=5;
// hub_diameter=6;
// flange_diameter=7;
// belt_center=8; (pulley_height-pulley_hub_height)/2+pulley_hub_height;

// values for GT2-3mm 17 groove pulley
conf_pulley_17_GT2_3mm = [ 20.6, 6.3, 11.1, 3.5, 3, 15.4, 17.5, 22, (20.6-6.3)/2+6.3];
// values for GT2 36 groove pulley
conf_pulley_36_GT2 = [ 17.5, 6.3, 8, 3.5, 3, 22.4, 17.5, 28, (17.5-6.3)/2+6.3];
// values for GT2 40 groove pulley
conf_pulley_40_GT2 = [ 17.5, 6.3, 8, 3.5, 3, 25, 17.5, 30, (17.5-6.3)/2+6.3];