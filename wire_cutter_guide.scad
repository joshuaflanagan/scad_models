//Number of 0.1" increments of insulation to remove
strip_insulation_length = 3;

/* [Wirecutter] */
// Width of gap needed to grip wirecutter
grip_thickness = 3.2;
// Height of grip around wirecutter
grip_height = 5; 
// Length of grip that holds onto wirecutter
length = 22;
// Height of the backwall that serves as a stop for wire when stripping insulation
backwall_height = 12; // based on height of wirecutter

/* [Measurement Surface]*/
number_of_pins = 20;

/* [Hidden] */
//breadboard specs
pin_gap = 2.54; // 0.1" standard breadboard
wire_strip_length = strip_insulation_length * pin_gap;
thick = pin_gap;


baseline = thick + grip_thickness + wire_strip_length + thick;

// base
cube([baseline, length, thick]);

//grip front
cube([thick, length, grip_height + thick]);

//grip back
translate([thick + grip_thickness, 0, 0]){
cube([thick, length, grip_height + thick]);
}


cutting_edge = thick + grip_thickness;

// backwall

backwall_start = cutting_edge + wire_strip_length;

translate([backwall_start, 0, 0]) {
  cube([thick, length, thick + backwall_height]);
}


translate([cutting_edge, 0, 0]){
  // measuring surface (consumes backwall)
  measure_length = length / 2;
  
  difference(){
  translate([wire_strip_length, 0, 0]){
    cube([(number_of_pins * pin_gap) - wire_strip_length, measure_length, thick + backwall_height]);
  }

  //pin guide
  guide_depth = 1;
  guide_thick = 0.6;
  guide_length = 4;
  
  for(center = [1:(number_of_pins - 1)]){
    this_offset = center * pin_gap;
    // -0.01 is to make it have hole on side
    translate([this_offset - (guide_thick / 2), -0.01, backwall_height + thick - guide_depth]){
      line_length = (center % 5 == 0) ? (guide_length * 2) : guide_length;
      
      // 100 is just to make it tall, so it always cuts thru to top
      cube([guide_thick, line_length, 100]);

    }
  }
}
}
