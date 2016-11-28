module stepper(motor_height, centered) {
    scale(0.0393701) translate([centered?0:21.15,centered?0:21.15]) difference() {
        union() {
            color([0.6, 0.6, 0.6]) translate([0, 0, motor_height / 2]) {
                intersection() {
                    cube([42.3, 42.3, motor_height], center = true);
                    rotate([0, 0, 45]) translate([0, 0, -1]) cube([74.3 * sin(45), 73.3 * sin(45), motor_height + 2], center = true);
                }
            } color([0.4, 0.4, 0.4]) translate([0, 0, motor_height]) cylinder(h = 2, r = 11, $fn = 24);
            color([0.8, 0.8, 0.8]) translate([0, 0, motor_height + 2]) cylinder(h = 20, r = 2.5, $fn = 24);
        } for (i = [0: 3]) {
            rotate([0, 0, 90 * i]) translate([15.5, 15.5, motor_height - 4.5]) cylinder(h = 5, r = 1.5, $fn = 24);
        }
    }
}

module shaft(length,centered) {
    shaftRad = 0.314961/2;
    color([0.9,0.9,0.9]) cylinder(h=length,r=shaftRad,center=centered,$fn=30);
}

// MCMASTER 94180A333
module heatSetInsert() {
    translate([0,0,-0.251969]) cylinder(r1=0.09251969,r2=0.10295276,h=0.251969,$fn=30);
}

module cornerBracket() {
    stepperHeight = 38;
    stepperHeightImp = 0.0393701*stepperHeight;

    mainHeight = stepperHeightImp+0.25;
    edgeHeight = 2.5;
    color([1,1,1]) difference() {
        union() { 
            hull() {
                cube([1,1,mainHeight]);
                translate([2,0]) cube([1,1,mainHeight]);
                translate([0,2]) cube([1,1,mainHeight]);
                translate([2.5,2.5]) cylinder(r=0.5,h=mainHeight,$fn=30);
            }
            
            cube([3,1,edgeHeight]);
            cube([1,3,edgeHeight]);
        }
        
        // bracket cutout
        translate([-0.5,-0.5,-0.5]) cube([1.5,1,5]);
        
        // limit switch cutout
        switchWidth = 0.5019685;
        switchDepth = 0.5;
        switchHeight = 0.228346;
        switchHoleInset = 0.200787;
        switchHoleDistance = 0.255906;
    
        translate([0.5-switchWidth/2,3-switchDepth,-0.25]) cube([switchWidth,switchDepth+0.25,switchHeight+0.25]);
        translate([0.5+switchHoleDistance/2,3-switchHoleInset,switchHeight]) rotate([180,0,0]) heatSetInsert();
        translate([0.5-switchHoleDistance/2,3-switchHoleInset,switchHeight]) rotate([180,0,0]) heatSetInsert();
        
        // screw and nut cutouts
        nutWidth = 3/8 + 0.02;
        nutHeight = 1/8 + 0.02;
        screwRad = 0.10;
        translate([1,0.5-nutWidth/2,edgeHeight-nutHeight-0.25]) cube([4,nutWidth,nutHeight]);
        translate([1.5,0.5,edgeHeight-1.5]) cylinder(r=screwRad,h=10,$fn=30);
        translate([2.5,0.5,edgeHeight-1.5]) cylinder(r=screwRad,h=10,$fn=30);
      
        translate([0.5-nutWidth/2,0,edgeHeight-nutHeight-0.25]) cube([nutWidth,4,nutHeight]);
        translate([0.5,1.5,edgeHeight-1.5]) cylinder(r=screwRad,h=10,$fn=30);
        translate([0.5,2.5,edgeHeight-1.5]) cylinder(r=screwRad,h=10,$fn=30);

        translate([0.5-nutWidth/2,0.75,-0.25]) cube([nutWidth,nutHeight,mainHeight+0.25]);
        translate([0.5,0.25,0.5]) rotate([-90,0,0]) cylinder(r=0.1,h=1.5,$fn=30);
        translate([0.5,0.25,1.5]) rotate([-90,0,0]) cylinder(r=0.1,h=1.5,$fn=30);

        translate([0.5,2,1]) rotate([-90,0,0]) shaft(2);
    }
    
        
}

module stepperBracket(showStepper) {
    stepperHeight = 38;
    stepperHeightImp = 0.0393701*stepperHeight;

    mainHeight = stepperHeightImp+0.25;
    edgeHeight = 2.5;
    color([1,1,1]) difference() {
        union() {
            cornerBracket();
            translate([3,2.5,0]) rotate([90,0,0]) linear_extrude(0.25) difference() {
                hull() {
                    square([0.25,0.25]);
                    translate([0,mainHeight-0.25]) square([0.25,0.25]);
                    translate([0.5,0.25]) circle(r=0.25,$fn=30);
                    translate([0.5,mainHeight-0.25]) circle(r=0.25,$fn=30);
                    
                }

                translate([0.375,mainHeight/2 + 0.5]) circle(r=0.075,$fn=30);
                translate([0.375,mainHeight/2 - 0.5]) circle(r=0.075,$fn=30);
            }
        }
        
        // stepper cutout
        translate([1,1,-0.25]) cube([1.665354,1.665354, stepperHeightImp+0.25], center = false);
        translate([1 + 1.665354/2,1 + 1.665354/2,0]) cylinder(r=0.5,h=edgeHeight,$fn=30);
        translate([1 + 1.665354/2,1 + 1.665354/2,0]) scale(0.0393701) for (i = [0:3]) {
            rotate([0, 0, 90 * i]) translate([15.5, 15.5]) cylinder(h = 100, r = 1.5, $fn = 24);
        }
        
        // stepper wire cutout
        translate([2.5,1+1.665354/2,0]) rotate([0,90,0]) cylinder(r=0.25,h=1,$fn=30);

    }

    if (showStepper) translate([1,1,0]) stepper(stepperHeight);
}



module pulleyBracket() {
    stepperHeight = 38;
    stepperHeightImp = 0.0393701*stepperHeight;

    mainHeight = stepperHeightImp+0.25;

    difference() {
        cornerBracket();
        
        translate([1 + 1.665354/2,1 + 1.665354/2,mainHeight]) {
            heatSetInsert();
            translate([0.5,0.5]) heatSetInsert(); 
        }
    }
}

// length = 20 (final)
width = 16;
height = 4;

module scaffolding() {
    color([0.3,0.3,0.3]) {
        translate([0,0,height-0.5]) {
            cube([1,20,0.5]);
            translate([width-1,0,0]) cube([1,20,0.5]);
            cube([width,1,0.5]);
            translate([0,19,0]) cube([width,1,0.5]);
        }
        
        cube([1,0.5,height-0.5]);
        translate([width-1,0,0]) cube([1,0.5,height-0.5]);
        translate([0,19.5,0]) cube([1,0.5,height-0.5]);
        translate([width-1,19.5,0]) cube([1,0.5,height-0.5]);
    }
}

module brackets(showStepOrPull) {
    translate([0,0,height-3]) {
        stepperBracket(showStepOrPull);
        translate([width,0,0]) mirror([1,0,0]) stepperBracket(showStepOrPull);
        translate([0,20,0]) mirror([0,1,0]) pulleyBracket(showStepOrPull);
        translate([width,20,0]) rotate([0,0,180]) pulleyBracket(showStepOrPull);
    }
}

module gantry() {
    translate([0.5,2,height-2]) rotate([-90,0,0]) shaft(16);
    translate([width-0.5,2,height-2]) rotate([-90,0,0]) shaft(16);
}

brackets(true);
scaffolding();
gantry();
