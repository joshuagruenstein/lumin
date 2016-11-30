$fn = 30;

use <util.scad>

///////////////////
//   CONSTANTS   //
///////////////////

gantryXLocation = 6;   //6+6*cos(800*$t)
gantryYLocation = 6;   //6+6*sin(800*$t)
gantryZLocation = 0;

rodHeight = 1;
rodDistance = 1;
zRodDistance = 1.15;

// length = 20 (final)
width = 20;
height = 6;

// for 10-32 hardware
nutWidth = 3/8 + 0.02;
nutHeight = 1/8 + 0.02;
screwRad = 0.10;

// assuming 2 LM8UU
bearingRad = 0.295276;
bearingLength = 2*0.94488189;

// for pololu nema 17 2267
stepperHeight = 38;
stepperHeightImp = 0.0393701*stepperHeight;
mainHeight = stepperHeightImp+0.25;
edgeHeight = 2.5;

module cornerBracket() {
    color([1,1,1]) difference() {
        union() {
            hull() {
                cube([1,1,mainHeight]);
                translate([2,0]) cube([1,1,mainHeight]);
                translate([0,2]) cube([1,1,mainHeight]);
                translate([2.5,2.5]) cylinder(r=0.5,h=mainHeight);
            }

            cube([3,1,edgeHeight]);
            cube([1,3,edgeHeight]);
        }

        // bracket cutout
        translate([-0.5,-0.5,-0.5]) cube([1.5,1,5]);

        translate([0.5,3,0]) limitSwitch();

        // screw and nut cutouts
        translate([1,0.5-nutWidth/2,edgeHeight-nutHeight-0.25]) cube([4,nutWidth,nutHeight]);
        translate([1.5,0.5,edgeHeight-1.5]) cylinder(r=screwRad,h=100);
        translate([2.5,0.5,edgeHeight-1.5]) cylinder(r=screwRad,h=100);

        translate([0.5-nutWidth/2,0,edgeHeight-nutHeight-0.25]) cube([nutWidth,4,nutHeight]);
        translate([0.5,1.5,edgeHeight-1.5]) cylinder(r=screwRad,h=100);
        translate([0.5,2.5,edgeHeight-1.5]) cylinder(r=screwRad,h=100);

        translate([0.5-nutWidth/2,0.75,-0.25]) cube([nutWidth,nutHeight,mainHeight+0.5]);
        translate([0.5,0.25,0.5]) rotate([-90,0,0]) cylinder(r=0.1,h=1.50);
        translate([0.5,0.25,1.5]) rotate([-90,0,0]) cylinder(r=0.1,h=1.50);

        translate([0.5,2,rodHeight]) rotate([-90,0,0]) shaft(2);
    }
}

module stepperBracket(showStepper) {
    color([1,1,1]) difference() {
        union() {
            cornerBracket();
            translate([3,2.5,0]) rotate([90,0,0]) linear_extrude(0.25) difference() {
                hull() {
                    square([0.25,0.25]);
                    translate([0,mainHeight-0.25]) square([0.25,0.25]);
                    translate([0.5,0.25]) circle(r=0.250);
                    translate([0.5,mainHeight-0.25]) circle(r=0.250);
                }

                translate([0.375,mainHeight/2 + 0.5]) circle(r=0.0750);
                translate([0.375,mainHeight/2 - 0.5]) circle(r=0.0750);
            }
        }

        // stepper cutout
        translate([1,1,-0.25]) cube([1.665354,1.665354, stepperHeightImp+0.25], center = false);
        translate([1 + 1.665354/2,1 + 1.665354/2,0]) cylinder(r=0.5,h=edgeHeight);
        translate([1 + 1.665354/2,1 + 1.665354/2,0]) scale(0.0393701) for (i = [0:3]) {
            rotate([0, 0, 90 * i]) translate([15.5, 15.5]) cylinder(h = 100, r = 1.5);
        }

        // stepper wire cutout
        translate([2.5,1+1.665354/2,0]) rotate([0,90,0]) cylinder(r=0.25,h=10);

    }

    if (showStepper) translate([1,1,0]) stepper(stepperHeight);
}

module pulleyBracket() {
    color([1,1,1]) difference() {
        cornerBracket();

        // material savings cutout
        translate([1,-0.5,-0.25]) cube([3,4,stepperHeightImp]);

        // idler heat set inserts
        translate([1 + 1.665354/2,1 + 1.665354/2,mainHeight]) {
            heatSetInsert();
            translate([0.5,0.5]) heatSetInsert();
        }
    }
}

module initStage(showShafts) {
    curveRad = 0.4375;

    idlerSpacing = 1;
    idlerDistance = 0.5 + 1.665354/2;

    rodStored = 2;

    color([1,1,1]) difference() {
        union() {
            hull() {
                cylinder(h=bearingLength,r=curveRad);
                translate([0,rodHeight-curveRad]) cylinder(h=bearingLength,r=curveRad);
            } translate([0,-curveRad]) cube([0.5+rodStored,1,bearingLength]);
        }

        translate([curveRad+0.25,1-curveRad,-0.25]) cylinder(h=bearingLength+0.5,r=0.25);
        translate([curveRad+0.25,1-curveRad-0.25,-0.25]) cube([rodStored,1,bearingLength+0.5]);

        // bearings
        translate([0,0,-0.1]) cylinder(h=bearingLength+0.25,r=bearingRad);

        // rods
        translate([0.5,0,bearingLength/2-rodDistance/2]) rotate([0,90,0]) shaft(2);
    translate([0.5,0,bearingLength/2+rodDistance/2]) rotate([0,90,0]) shaft(2);

        // limit switch
        translate([0.5+rodStored,1-curveRad-0.25,bearingLength/2]) rotate([90,90,0]) limitSwitch();

        // idler inserts
        translate([idlerDistance,-curveRad,bearingLength/2-idlerSpacing/2]) rotate([90,0,0]) heatSetInsert();
        translate([idlerDistance,-curveRad,bearingLength/2+idlerSpacing/2]) rotate([90,0,0]) heatSetInsert();
    }

    if (showShafts) {
        shaftLength = width-2;

        translate([-0.5,0,bearingLength/2-rodDistance/2]) rotate([0,90,0]) shaft(shaftLength);
        translate([-0.5,0,bearingLength/2+rodDistance/2]) rotate([0,90,0]) shaft(shaftLength);
    }
}

// using nema 14 pololu 1208
module xyCarriage(showStepper) {
    curveRad = 0.4375;

    carriageHeight = 0.75;

    stepperScrewDistance = 0.7238100909803151;
    stepperScrewRad = 0.0629921;


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
        translate([-0.25,bearingLength/2-rodDistance/2,0.315]) rotate([0,90,0]) cylinder(r=bearingRad,h=bearingLength+0.5);
        translate([-0.25,bearingLength/2+rodDistance/2,0.315]) rotate([0,90,0]) cylinder(r=bearingRad,h=bearingLength+0.5);

        // large hole
        translate([bearingLength/2,bearingLength/2,carriageHeight-.125]) cylinder(r=0.5,h=30);

        // smaller hole
        translate([bearingLength/2,bearingLength/2,-0.1]) cylinder(r=0.1875,h=10);

        // m3 holes and head cutouts
        translate([bearingLength/2+stepperScrewDistance,bearingLength/2,-0.1]) {
            cylinder(r=stepperScrewRad,h=50);
            translate([0,0,-0.0875]) cylinder(r=0.095,h=0.75);
        } translate([bearingLength/2-stepperScrewDistance,bearingLength/2,-0.1]) {
            cylinder(r=stepperScrewRad,h=50);
            translate([0,0,-0.0875]) cylinder(r=0.095,h=0.75);
        }

        // 8mm shaft mounts
        translate([bearingLength/2-zRodDistance/2,bearingLength/2,-0.1875]) shaft(0.75);
        translate([bearingLength/2+zRodDistance/2,bearingLength/2,-0.1875]) shaft(0.75);

    }

    if (showStepper) color([0.4,0.4,0.4]) translate([bearingLength/2,bearingLength/2,stepperMountHeight+1.10236/2+0.75]) rotate(45) cube([1.385827,1.385827,1.10236],center=true);
}

module zCarriage() {
    leadNutHeight = 0.266;
    leadNutWidth = 0.55;

    m3Dist = 0.21;

    boltSquare = 1.25;

    color([1,1,1]) difference() {
        translate([-bearingLength/2,-bearingLength/2]) cube([bearingLength,bearingLength,bearingLength]);


        // bearing pockets
        translate([zRodDistance/2,0,0]) cylinder(r=bearingRad,h=bearingLength);
        translate([-zRodDistance/2,0,0]) cylinder(r=bearingRad,h=bearingLength);

        // nut pocket
        translate([-leadNutWidth/2,-5,bearingLength/2-leadNutHeight/2]) cube([leadNutWidth,10,leadNutHeight]);

        //threaded rod hole
        cylinder(r=0.165,h=bearingLength);

        // limit switch
        translate([0,-bearingLength/2,0]) rotate([-90,0,0]) limitSwitch();

        // bolt square
        translate([boltSquare/2,bearingLength/2+0.01,bearingLength/2+boltSquare/2]) rotate([90,0,0]) cylinder(r=screwRad,h=0.6);
        translate([-boltSquare/2,bearingLength/2+0.01,bearingLength/2+boltSquare/2]) rotate([90,0,0]) cylinder(r=screwRad,h=0.6);
        translate([boltSquare/2,bearingLength/2+0.01,bearingLength/2-boltSquare/2]) rotate([90,0,0]) cylinder(r=screwRad,h=0.6);
        translate([-boltSquare/2,bearingLength/2+0.01,bearingLength/2-boltSquare/2]) rotate([90,0,0]) cylinder(r=screwRad,h=0.6);

        // bolt square nut pockets
        translate([boltSquare/2-nutWidth/2,bearingLength/2-nutHeight-0.25,0]) cube([nutWidth,nutHeight,10]);
        translate([-boltSquare/2-nutWidth/2,bearingLength/2-nutHeight-0.25,0]) cube([nutWidth,nutHeight,10]);

    }

}

module zCap() {
    shellRad = (bearingLength-zRodDistance)/2;
    capHeight = 0.75;
    capEmbed = 0.5;

    color([1,1,1,0.5]) difference() {
        hull() {
            translate([zRodDistance/2,0,0]) cylinder(r=shellRad,h=0.75);
            translate([-zRodDistance/2,0,0]) cylinder(r=shellRad,h=0.75);
        } translate([zRodDistance/2,0,capHeight-capEmbed]) shaft(5);
        translate([-zRodDistance/2,0,capHeight-capEmbed]) shaft(5);
        translate([0,0,capHeight-capEmbed]) cylinder(r=0.2,h=5);
    }
}

// uses 1"x 0.5" box tubing, in particular 6061 aluminum with 1/16" wall
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

    translate([3+gantryXLocation,3+gantryYLocation,height-3+rodHeight-0.315]) xyCarriage(true);

    translate([2+0.94488189+gantryXLocation+1,0.94488189+3+gantryYLocation,height-3+rodHeight-0.315-gantryZLocation]) rotate([0,180,0]) zCarriage();

    shaftLength = (height+rodHeight-2.82) - 0.25;
    translate([2+0.94488189+gantryXLocation+1+zRodDistance/2,0.94488189+3+gantryYLocation,height-3+rodHeight-0.315+0.5]) rotate([0,180,0]) shaft(shaftLength);
    translate([2+0.94488189+gantryXLocation+1-zRodDistance/2,0.94488189+3+gantryYLocation,height-3+rodHeight-0.315+0.5]) rotate([0,180,0]) shaft(shaftLength);

    translate([3+gantryXLocation+bearingLength/2,3+gantryYLocation+bearingLength/2]) zCap();
}

brackets(true);
scaffolding();
gantry();
