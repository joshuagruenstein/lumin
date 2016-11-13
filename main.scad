use <tslot.scad>
use <brackets.scad>


width = 16;
height = 22;
length = 16;

angle = atan((height)/(length-.5));

////////////////////
///   BRACKETS   ///
////////////////////

// backbottom
cornerBracket();
translate([width,0,0]) flippedCornerBracket();

// frontbottom
translate([width,length,0]) rotate([0,0,180]) frontAngleBracket(angle);
translate([0,length,0]) rotate([0,0,180]) mirror([1,0,0]) frontAngleBracket(angle);

// backtop
translate([width,0,height]) rotate([0,0,180]) mirror([0,1,1]) angleBracket(90-angle);
translate([0,0,height]) rotate([0,0,180]) mirror([1,0,0]) mirror([0,1,1]) angleBracket(90-angle);



////////////////////
///    TSLOT     ///
////////////////////

// bottom
translate([1.5,0.75,0.75]) rotate([270,0,270]) tslot(width-3);

translate([0.75,1.5,0.75]) rotate([270,0,0]) tslot(length-3);
translate([width-0.75,1.5,0.75]) rotate([270,0,0]) tslot(length-3);

translate([1.5,length-0.75,0.75]) rotate([270,0,270]) tslot(width-3);

// vertical
translate([0.75,0.75,0.25]) tslot(height-1.75);
translate([width-0.75,0.75,0.25]) tslot(height-1.75);

//diagonal
diagonal = sqrt((height-4)*(height-4) + length*length);
translate([width,length,0]) rotate([0,0,180]) translate([0.25,0.25,1.5]) rotate([-90+angle,0,0]) translate([0.5,0.5,0.75]) tslot(diagonal);

translate([1.5,length,0]) rotate([0,0,180]) translate([0.25,0.25,1.5]) rotate([-90+angle,0,0]) translate([0.5,0.5,0.75]) tslot(diagonal);

// top
translate([1.5,0.75,height-0.75]) rotate([270,0,270]) tslot(width-3);
