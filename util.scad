module GT2_2mm(width = 2) {
	linear_extrude(height=width) polygon([[0.747183,-0.5],[0.747183,0],[0.647876,0.037218],[0.598311,0.130528],[0.578556,0.238423],[0.547158,0.343077],[0.504649,0.443762],[0.451556,0.53975],[0.358229,0.636924],[0.2484,0.707276],[0.127259,0.750044],[0,0.76447],[-0.127259,0.750044],[-0.2484,0.707276],[-0.358229,0.636924],[-0.451556,0.53975],[-0.504797,0.443762],[-0.547291,0.343077],[-0.578605,0.238423],[-0.598311,0.130528],[-0.648009,0.037218],[-0.747183,0],[-0.747183,-0.5]]);
}


module belting(length,width) {
    belt_width = width ? width*25.4 : 6;
	tooth_cnt = ceil(length*25.4/2);
	scale(0.0393701) union() {
		translate([-1,-0.76,0]) cube([2*tooth_cnt,0.76,belt_width]);
		for(i=[0:tooth_cnt-1]) {
			translate([2*i,0,0]) GT2_2mm(width = belt_width);
		}
	}
}

module stepper(motor_height, centered) {
    scale(0.0393701) translate([centered?0:21.15,centered?0:21.15]) difference() {
        union() {
            color([0.6, 0.6, 0.6]) translate([0, 0, motor_height / 2]) {
                intersection() {
                    cube([42.3, 42.3, motor_height], center = true);
                    rotate([0, 0, 45]) translate([0, 0, -1]) cube([74.3 * sin(45), 73.3 * sin(45), motor_height + 2], center = true);
                }
            } color([0.4, 0.4, 0.4]) translate([0, 0, motor_height]) cylinder(h = 2, r = 11);
            color([0.8, 0.8, 0.8]) translate([0, 0, motor_height + 2]) cylinder(h = 20, r = 2.5);
        } for (i = [0: 3]) {
            rotate([0, 0, 90 * i]) translate([15.5, 15.5, motor_height - 4.5]) cylinder(h = 5, r = 1.5);
        }
    }
}

module shaft(length,centered) {
    shaftRad = 0.314961/2;
    color([0.8,0.8,0.8]) cylinder(h=length,r=shaftRad,center=centered);
}

// MCMASTER 94180A333
module heatSetInsert() {
    translate([0,0,-0.251969]) cylinder(r1=0.09251969,r2=0.10295276,h=0.251969);
}

module limitSwitch() {
    switchWidth = 0.5019685;
    switchDepth = 0.5;
    switchHeight = 0.228346;
    switchHoleInset = 0.200787;
    switchHoleDistance = 0.255906;

    translate([-switchWidth/2,-switchDepth,-0.25]) cube([switchWidth,switchDepth+0.25,switchHeight+0.25]);
    translate([+switchHoleDistance/2,-switchHoleInset,switchHeight]) rotate([180,0,0]) heatSetInsert();
    translate([-switchHoleDistance/2,-switchHoleInset,switchHeight]) rotate([180,0,0]) heatSetInsert();
}
