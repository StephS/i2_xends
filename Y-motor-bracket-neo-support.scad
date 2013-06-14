// from http://www.thingiverse.com/thing:21703

m8_nut_diameter = 10 / cos(180 / 6);
m8_diameter = 8.5;
m3_diameter = 3.2 / cos(180 / 8);

m3_washer_diameter = 8;

endstop_height = 24;
endstop_mount = 0;

// from frame-vertex.scad
hole_separation=58.5;

pulley_clearance_radius = 12;

height = 20;

layer_height = 0.30;

$fa = 1;

module bearing608()
{
	difference()
	{
		cylinder(r=22 / 2, h=7);
		translate([0, 0, -1])
			cylinder(r=8 / 2, h = 9);
	}
}

module bearing608_negative()
{
	cylinder(r=22 / 2, h=7);
}

module nema17()
{
	render()
	{
		difference()
		{
			intersection()
			{
				translate([-21, -21, -48])
					cube([42, 42, 48]);
				translate([0, 0, -49])
					cylinder(r=54 / 2, h=100, $fn=256);
			}
			translate([ 31 / 2,  31 / 2, -5])
				cylinder(r=1.5, h=10, $fn=8);
			translate([-31 / 2,  31 / 2, -5])
				cylinder(r=1.5, h=10, $fn=8);
			translate([ 31 / 2, -31 / 2, -5])
				cylinder(r=1.5, h=10, $fn=8);
			translate([-31 / 2, -31 / 2, -5])
				cylinder(r=1.5, h=10, $fn=8);
		}
		cylinder(r=23 / 2, h=2, $fn=64);
		cylinder(r=2.5, h=22, $fn=16);
	}
}

module nema17_negative()
{
	render()
	{
		intersection()
		{
			translate([-21.5, -21.5, -48])
				cube([43, 43, 48]);
			translate([0, 0, -50])
				cylinder(r=56 / 2, h=100, $fn=256);
		}
		cylinder(r=23 / 2, h=23, $fn=64);
		translate([ 31 / 2,  31 / 2, -5])
			cylinder(r=1.6 / cos(180 / 8), h=11, $fn=8);
		translate([-31 / 2,  31 / 2, -5])
			cylinder(r=1.6 / cos(180 / 8), h=11, $fn=8);
		translate([ 31 / 2, -31 / 2, -5])
			cylinder(r=1.6 / cos(180 / 8), h=11, $fn=8);
		translate([-31 / 2, -31 / 2, -5])
			cylinder(r=1.6 / cos(180 / 8), h=11, $fn=8);
		translate([ 31 / 2,  31 / 2, 5])
			cylinder(r=m3_washer_diameter / 2, h=50, $fn=16);
		translate([-31 / 2,  31 / 2, 5])
			cylinder(r=m3_washer_diameter / 2, h=50, $fn=16);
		translate([ 31 / 2, -31 / 2, 5])
			cylinder(r=m3_washer_diameter / 2, h=50, $fn=16);
		translate([-31 / 2, -31 / 2, 5])
			cylinder(r=m3_washer_diameter / 2, h=50, $fn=16);
	}
}

module bridge_support()
{
	translate([ 0,  0, -7])
	{
		difference()
		{
			cylinder(r=23 / 2, h=7, $fn=64);
			translate([0,0,-1])
				cylinder(r=20 / 2, h=9, $fn=64);
		}
		for (quadrant=[0:3])
			rotate([0,0,quadrant*90])
			{
				translate([ 31 / 2,  31 / 2, 0])
					cylinder(r=1.6 / cos(180 / 8), h=7, $fn=8);
				rotate([0,0,45])
					translate([10,-1,0])
						cube([11,2,7]);
			}
	}
}

//translate([0, 0, 100]) nema17_negative();

module motor_mount()
{
	rotate([0, 0, 180])
	{
		difference()
		{
			translate([0, 0, 7])
			{
				difference()
				{
					union()
					{
						translate([hole_separation, 0, -10])
							cylinder(r=10, h=height);
						rotate([0, 0, 60])
							translate([hole_separation, 0, -10])
								cylinder(r=10, h=15);
						difference()
						{
							translate([5, 20, -10])
								cylinder(r=30, h=height);
							translate([5, 10, 10])
								cube([100, 30, 100]);
							translate([15, 10, 10])
								cube([100, 50, 100]);
							translate([5, 20, 0])
								rotate([0, 0, 58])
									translate([0, pulley_clearance_radius, 1]) 
										mirror([0, 1, 0])
											cube([100, pulley_clearance_radius, 25]);
						}
						translate([hole_separation, 0, -10])
							rotate([0, 0, 30])
								translate([-17, 0, 0])
									cube([27, hole_separation, 19.98]);
						rotate([0, 0, -90])
							translate([-10, 5, -10])
								cube([20, hole_separation - 5, height]);
						translate([5, 20, 0])
							rotate([0, 0, 21])
								translate([0, 20, 0])
									rotate([0, 0, -90])
										translate([-10, 0, -10])
											cube([20, 33.5, 10]);
						translate([5, 20, 0])
							rotate([0, 0, -20])
								translate([31 / 2, 31 / 2, 0])
									cylinder(r=5, h=10);
					}
					translate([5, 20, 0])
					{
						rotate([0, 0, -20])
						{
							//%nema17();
							nema17_negative();
							translate([0, 0, 2])
								cylinder(r=pulley_clearance_radius, h=30);
						}
						translate([0, -pulley_clearance_radius, 1])
							cube([100, pulley_clearance_radius, 25]);
						rotate([0, 0, 58])
							translate([0, pulley_clearance_radius, 1])
								mirror([0, 1, 0])
									cube([100, 8, 25]);
					}
					// slot
					translate([hole_separation, 0, -10])
						rotate([0, 0, 30])
							translate([-4, hole_separation, -1])
								cube([7.9, hole_separation, 30]);
					render() intersection()
					{
						translate([hole_separation, 0, -10])
							rotate([0, 0, 30])
								translate([0, hole_separation, -1])
									difference()
									{
										cylinder(r=hole_separation + 3.95, h=50);
										translate([0, 0, -1])
											cylinder(r=hole_separation - 3.95, h=100);
									}
									translate([hole_separation, 0, -10])
										rotate([0, 0, 30])
											translate([0, hole_separation / -2, -1])
												cube([40, hole_separation, 30]);
					}
		
					for (hole=[0:1])
						rotate([0, 0, hole*60])
							translate([hole_separation,0,-20])
								cylinder(h=50,r=(m8_diameter/2), $fn=64);
		
					rotate([0, 0, 60])
						translate([hole_separation, 0, 2])
						{
							bearing608_negative(); 
							//%bearing608();
							translate([0, 0, -2])
									cylinder(r=35 / 2, h=30);
						}
				}

				translate([5, 20, 0])
					rotate([0, 0, -20])
						render() intersection()
						{
							translate([-22, -22, 0])
								cube([44, 44, layer_height]);
							translate([0, 0, -1])
								cylinder(r=29.8, h=3, $fn=128);
						}
			}
			translate([-250, -250, -50])
				cube([500, 500, 50]);
		}
		#translate([5, 20, 7])
			rotate([0, 0, -20])
				bridge_support();

	}
}

motor_mount();