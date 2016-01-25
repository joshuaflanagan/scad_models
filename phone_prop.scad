// Thickness of phone (incl. case) that will fit into clip.
phone_thickness = 11.8;
// Width of stand - wider will be more stable
stand_width = 15;
// Angle (in degrees) that phone will sit
phone_angle = 40;

/* [Advanced] */
// How high off the surface the stand should rise
stand_height = 30;
// How much leeway to allow around phone thickness
wiggle = 1.3;
// Overhang at the front of clip. Reduce if there is not a case to grab
hat_overhang = 2;
// How far back to place the hollow circle
hollow_offset = 32;

/* [Hidden] */
// Thickness of bottom layer
base_height = 4;

front_lip_height = (phone_thickness + wiggle) * sin(90-phone_angle);
front_lip_thickness = 3;

base_length = phone_thickness * sin(phone_angle);
extra = 1;

// for ghost image only
phone_width = 130;
phone_height = 65;


base();
tilt();
front_lip();
phone_ghost();


module base(){
  cube([stand_width, base_length + front_lip_thickness, base_height]);
}

module tilt(){
  overlap = base_height * sin(90-phone_angle) / sin(phone_angle);
  tilt_offset = front_lip_thickness + base_length - overlap;

  translate([0, tilt_offset, 0]) {
    difference(){
    union(){
    ramp(phone_angle, height=stand_height, width=stand_width);

    //back support
    translate([0, stand_height * sin(90-phone_angle) / sin(phone_angle), 0])
    ramp(-60, height=stand_height, width=stand_width);
    }

    //hollow
    hollow_radius= (stand_height - 2*base_height) / 3;
    translate([-extra, hollow_offset, base_height + hollow_radius])
    rotate([0, 90, 0])
    cylinder(r=hollow_radius, h=stand_width + extra * 2);
    }
  }
}

module front_lip(){
  translate([0, 0, base_height]) {
    cube([stand_width, front_lip_thickness, front_lip_height]);
    //hat
    translate([0, 0,front_lip_height])
      cube([stand_width, front_lip_thickness + hat_overhang, 1]);
  }
}

module phone_ghost(){
  translate([-(phone_width - stand_width)/2, front_lip_thickness + base_length, base_height])

  rotate([phone_angle - 90])
  translate([0, -phone_thickness, 0])
  %cube([phone_width, phone_thickness, phone_height]);
}

module ramp(angle, height, width){

  base = height * sin(90-angle) / sin(angle);
  shift = angle < 0 ? -base : 0;

  translate([0, shift, 0])
  rotate([90, 0, 90])
  linear_extrude(height=width)
  polygon([ [0, 0], [base,0], [base, height] ]);
}
