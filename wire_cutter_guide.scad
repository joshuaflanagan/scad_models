//breadboard specs
pin_gap = 2.54; // 0.1"

wire = 3 * pin_gap; // started with 8, but nice to make it a multiple of pin;
thick = pin_gap;

// dimensions specific to my wirecutter
grip = 3.2; // thickness of wirecutte
length = 22;
grip_height = 5;

backwall_height = 12; // based on height of wirecutter

baseline = thick + grip + wire + thick;

// base
cube([baseline, length, thick]);

//grip front
cube([thick, length, grip_height + thick]);

//grip back
translate([thick + grip, 0, 0]){
cube([thick, length, grip_height + thick]);
}

num_pins = 20;

cutting_edge = thick + grip;

// backwall

backwall_start = cutting_edge + wire;

translate([backwall_start, 0, 0]) {
  cube([thick, length, thick + backwall_height]);
}


translate([cutting_edge, 0, 0]){
  // measuring surface (consumes backwall)
  measure_length = length / 2;
  
  difference(){
  translate([wire, 0, 0]){
    cube([(num_pins * pin_gap) - wire, measure_length, thick + backwall_height]);
  }

  //pin guide
  guide_depth = 1;
  guide_thick = 0.6;
  guide_length = 4;
  
  for(center = [1:(num_pins - 1)]){
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
