use <tslot.scad>

res = 100;

module flippedCornerBracket() {
    mirror([1,0,0]) cornerBracket();
}

module cornerBracket() {
    color([0.95,0.95,0.95,0.75]) difference() {
        union() {
            cube([2.5,1.5,1.5]);
            translate([0,1.5,0]) cube([1.5,1,1.5]);
        }

        translate([0.75,0.75,0.25]) tslot(1.5);
        translate([0.75,1.5,0.75]) rotate([270,0,0]) tslot(1.25);
        translate([1.5,0.75,0.75]) rotate([270,0,270]) tslot(1.25);
    }
}

module frontAngleBracket(angle) {
    color([0.95,0.95,0.95,0.75]) difference() {
        union() {
            cube([2.5,1.5,1.5]);
            translate([0,1.5,0]) cube([1.5,1,1.5]);

            translate([0,0,1.5]) mirror([0,0,1]) rotate([-angle,0,0]) cube([1.5,2,3]);

            translate([0,0,1.5]) rotate([angle,0,0]) translate([1.5,1,-0.75]) difference() {
                union() {
                    translate([.25,0,0]) cylinder(0.75,0.25,0.25,$fn=res);
                    translate([0,-0.25,0]) cube([0.25,0.5,0.75]);
                } translate([.25,0,-0.1]) cylinder(1,0.0984252,0.0984252,$fn=res);
            }
        }

        // cleanup
        translate([-5,2.5,-5]) cube([10,10,10]);
        translate([-5,-5,-5]) cube([10,10,5]);

        translate([0.25,0.25,1.5]) rotate([-90+angle,0,0]) translate([0.5,0.5,0.75]) tslot(5);

        translate([0.75,1.5,0.75]) rotate([270,0,0]) tslot(1.25);
        translate([1.5,0.75,0.75]) rotate([270,0,270]) tslot(1.25);
    }

}

module angleBracket(angle) {
    m3rad = 0.0590551;

    color([0.95,0.95,0.95,0.75]) difference() {
        union() {
            cube([2.5,2.5,1.5]);
            translate([0,1.5,0]) cube([1.5,1,1.5]);

            translate([0,0,1.5]) mirror([0,0,1]) rotate([-angle,0,0]) cube([2.5,2,3]);

            translate([0,0,1.5]) mirror([0,0,1]) rotate([-angle,0,0]) translate([0,0,-0.5]) linear_extrude(0.5) difference() {
                square([3.5,3]);

                translate([1.5+0.167323+0.2224409,1+0.167323+0.2224409]) union() {
                    circle(m3rad,$fn=res);
                    translate([0,1.22047]) circle(m3rad,$fn=res);
                    translate([1.22047,1.22047]) circle(m3rad,$fn=res);
                    translate([1.22047,0]) circle(m3rad,$fn=res);

                    translate([0.610235,0.610235]) circle(0.45,$fn=res);
                }

            }
        }

        // cleanup
        translate([-5,2.5,-5]) cube([10,10,10]);
        translate([-5,-5,-5]) cube([10,10,5]);
        translate([0,0,1.5]) rotate([angle-90,0,0]) translate([1.5+0.167323,0,1+0.167323]) cube([1.665354,1.88976,1.665354]);

        translate([0.25,0.25,1.5]) rotate([-90+angle,0,0]) translate([0.5,0.5,0.75]) tslot(5);

        translate([0.75,1.5,0.75]) rotate([270,0,0]) tslot(1.25);
        translate([1.5,0.75,0.75]) rotate([270,0,270]) tslot(1.25);
    }
}
