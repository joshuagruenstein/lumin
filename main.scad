gantryXLocation = 6;   //6+6*cos(800*$t)
gantryYLocation = 6;   //6+6*sin(800*$t)

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
            } color([0.4, 0.4, 0.4]) translate([0, 0, motor_height]) cylinder(h = 2, r = 11, $fn = 24);
            color([0.8, 0.8, 0.8]) translate([0, 0, motor_height + 2]) cylinder(h = 20, r = 2.5, $fn = 24);
        } for (i = [0: 3]) {
            rotate([0, 0, 90 * i]) translate([15.5, 15.5, motor_height - 4.5]) cylinder(h = 5, r = 1.5, $fn = 24);
        }
    }
}

module shaft(length,centered) {
    shaftRad = 0.314961/2;
    color([0.8,0.8,0.8]) cylinder(h=length,r=shaftRad,center=centered,$fn=30);
}

// MCMASTER 94180A333
module heatSetInsert() {
    translate([0,0,-0.251969]) cylinder(r1=0.09251969,r2=0.10295276,h=0.251969,$fn=30);
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

rodHeight = 1.3;
rodDistance = 1;


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
        
        translate([0.5,3,0]) limitSwitch();
        
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

        translate([0.5,2,rodHeight]) rotate([-90,0,0]) shaft(2);
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

module initStage(showShafts) {
    bearingRad = 0.295276;
    bearingLength = 2*0.94488189;
    
    curveRad = 0.4375;
    
    idlerDistance = 1;
    
    color([1,1,1]) difference() {
        union() {
            hull() {
                cylinder(h=bearingLength,r=curveRad,$fn=50);
                translate([0,rodHeight-curveRad]) cylinder(h=bearingLength,r=curveRad,$fn=50);
                

            } translate([0,-curveRad]) cube([1.5,1,bearingLength]);
        }
        
        translate([curveRad+0.25,1-curveRad,-0.25]) cylinder(h=bearingLength+0.5,r=0.25,$fn=50);
        translate([curveRad+0.25,1-curveRad-0.25,-0.25]) cube([1,1,bearingLength+0.5]);

        // bearings
        translate([0,0,-0.1]) cylinder(h=bearingLength+0.25,r=bearingRad,$fn=30);
        
        // rods
        translate([0.5,0,bearingLength/2-rodDistance/2]) rotate([0,90,0]) shaft(2);
    translate([0.5,0,bearingLength/2+rodDistance/2]) rotate([0,90,0]) shaft(2);
        
        // limit switch
        translate([1.5,1-curveRad-0.25,bearingLength/2]) rotate([90,90,0]) limitSwitch();

        // idler inserts
        translate([1,-curveRad,bearingLength/2-idlerDistance/2]) rotate([90,0,0]) heatSetInsert();
        translate([1,-curveRad,bearingLength/2+idlerDistance/2]) rotate([90,0,0]) heatSetInsert();
    }
    
    if (showShafts) {
        shaftLength = width-2;
        echo(shaftLength);
        
        translate([0.5,0,bearingLength/2-rodDistance/2]) rotate([0,90,0]) shaft(shaftLength);
        translate([0.5,0,bearingLength/2+rodDistance/2]) rotate([0,90,0]) shaft(shaftLength);
    }
}

module finalCarriage() {
    bearingRad = 0.295276;
    bearingLength = 2*0.94488189;
    curveRad = 0.4375;

    carriageHeight = 0.75;
    
    stepperScrewDistance = 0.7238100909803151;
    stepperScrewRad = 0.0629921;
    
    zRodDistance = 0.875;
    
    stepperMountHeight = 0;
    
    module beltHolder(holderHeight) {
        difference() {
            cube([0.5,0.25,holderHeight]);
            translate([0,0.125,0]) belting(0.5,holderHeight);
        }
    }
    
    color([1,1,1]) difference() {
        union() {
            cube([bearingLength,bearingLength,carriageHeight]);
            
            translate([bearingLength/2,bearingLength/2,stepperMountHeight/2+0.75]) rotate(45) cube([1.385827,1.385827,stepperMountHeight],center=true);
            
            
            translate([0.5,0.375,carriageHeight]) rotate(180)beltHolder(0.5);
            translate([0,bearingLength-0.375,carriageHeight]) beltHolder(0.5);
            translate([bearingLength,0.375,carriageHeight]) rotate(180)beltHolder(0.5);
            translate([bearingLength-0.5,bearingLength-0.375,carriageHeight]) beltHolder(0.5);
           
        }
        
        // edges cleanup
        translate([0,-1,0]) cube([5,1,5]);
        translate([bearingLength,0,0]) cube([1,5,5]);
        translate([0,bearingLength,0]) cube([5,1,5]);
        translate([-1,0,0]) cube([1,5,5]);

        // bearing pockets
        translate([-0.25,bearingLength/2-rodDistance/2,0.315]) rotate([0,90,0]) cylinder(r=bearingRad,h=bearingLength+0.5,$fn=40);
        translate([-0.25,bearingLength/2+rodDistance/2,0.315]) rotate([0,90,0]) cylinder(r=bearingRad,h=bearingLength+0.5,$fn=40);
        
        // large hole
        translate([bearingLength/2,bearingLength/2,carriageHeight-.125]) cylinder(r=0.5,h=3,$fn=30);
        
        // smaller hole
        translate([bearingLength/2,bearingLength/2,-0.1]) cylinder(r=0.1875,h=1,$fn=30);

        translate([bearingLength/2+stepperScrewDistance,bearingLength/2,-0.1]) cylinder(r=stepperScrewRad,h=5,$fn=30);
        translate([bearingLength/2-stepperScrewDistance,bearingLength/2,-0.1]) cylinder(r=stepperScrewRad,h=5,$fn=30);

        translate([bearingLength/2-zRodDistance/2,bearingLength/2,-0.25]) shaft(0.75);
        translate([bearingLength/2+zRodDistance/2,bearingLength/2,-0.25]) shaft(0.75);

    }
    
    color([0.4,0.4,0.4]) translate([bearingLength/2,bearingLength/2,stepperMountHeight+1.10236/2+0.75]) rotate(45) cube([1.385827,1.385827,1.10236],center=true);
}

//cylinder(r=20,h=4,$fn=100);

// length = 20 (final)
width = 18;
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
    translate([0.5,2,height-3+rodHeight]) rotate([-90,0,0]) shaft(16);
    translate([width-0.5,2,height-3+rodHeight]) rotate([-90,0,0]) shaft(16);
   
    translate([0.5,3+gantryYLocation,height-3+rodHeight]) rotate([-90,0,0]) initStage(true);
    
    translate([width-0.5,3+gantryYLocation,height-3+rodHeight]) mirror([1,0,0]) rotate([-90,0,0]) initStage();
    
    translate([2+gantryXLocation,3+gantryYLocation,height-3+rodHeight-0.315]) finalCarriage();
 }

brackets(true);
scaffolding();
gantry();
