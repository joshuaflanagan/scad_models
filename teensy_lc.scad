// Teensy LC
//
// Dimensions from:
// https://pjrc.com/teensy/dimensions.html
//


teensy_lc(pin_holes=true, microcontroller=true);

module teensy_lc(pin_holes=true, microcontroller=true){
//$fa=1;
//$fs=.7;
$fn=8;

spec_length=35.56;
spec_width=17.78; // +-0.6
board_thickness=1.57;
board_length = spec_length;
manufacturing_variance = 0.18; // change this per board?
board_width = spec_width + manufacturing_variance;

pin_separation=2.54;
pin_offset=pin_separation / 2;

top_pin_line = board_width - pin_offset;
bottom_pin_line = top_pin_line - (6 * pin_separation);
center_line = top_pin_line - (pin_separation * 3);

center_of_first_pin_to_center_of_reset = 29.85;

color("green")
pcb(pin_holes=pin_holes);

if (microcontroller) {
  color("black")
  // offset from right edge is an approximation
  translate([board_length - 12.5, center_line, board_thickness])
  microcontroller();
}

color("silver")
usb_connector();

translate([pin_offset + center_of_first_pin_to_center_of_reset,
           center_line,
           board_thickness])
reset_button();



module usb_connector(){
  usb_width = 7.5;
  usb_length = 5;
  usb_height = 2.5;

  usb_flap_width = 8.06;
  usb_flap_height = 3.07;
  usb_flap_length = 0.06;

  usb_overhang = 0.7;


  translate([-usb_overhang, center_line - (usb_width / 2), board_thickness]){
  cube([usb_length, usb_width, usb_height]);

  translate([
    0,
    -(usb_flap_width - usb_width) / 2,
    -(usb_flap_height - usb_height) / 2,
    ])
  cube([usb_flap_length, usb_flap_width, usb_flap_height]);
  }
}


module reset_button(){
  button_length=2.2;
  button_width=3;
  button_height=2.5;
  housing_height=1.8;
  
  button_radius = button_length / 2;
  inner_rectangle_height = button_width - button_length;
  
  color("white")
  translate([0, -inner_rectangle_height/2, 0])
  linear_extrude(height=button_height)
  hull() {
      translate([0, inner_rectangle_height,0]) 
      circle(button_radius);
      circle(button_radius);
  }
  
  housing_length=3.2; //undocumented
  housing_width=4.2;  //undocumented
  color("silver")
  translate([-housing_length/2, -housing_width/2,0])
  cube([housing_length, housing_width, housing_height]);
}

module pcb(pin_holes){
  linear_extrude(height=board_thickness)
  difference(){
    // Everything is specified relative to the top line (y=board_width).
    // As manufacturing_variance increases, everything moves up, adding
    // more empty board to the bottom.
    square([board_length, board_width]);
    if (pin_holes) {
    translate([pin_offset, top_pin_line])
      pin_series(14);
    translate([pin_offset, bottom_pin_line])
      pin_series(14);
    
    translate([pin_offset + pin_separation, top_pin_line - pin_separation])
    pin();

    translate([pin_offset + 3 * pin_separation, top_pin_line - pin_separation])
    pin_series(3);
    

    translate([(14 * pin_separation) - pin_offset, top_pin_line - pin_separation])
    rotate(a=270)
    pin_series(5);
    }
  }


  module pin(){
    circle(r=0.5);
  }

  module pin_series(count) {
    for(i=[0:1:count - 1]){
      translate([pin_separation * i,0])
      pin();
    }
  }
}

module microcontroller(){
  mc_side=7;
  mc_height=1;
  
  rotate(a=45)
  translate([-mc_side/2, -mc_side/2, 0])
  cube([mc_side, mc_side, mc_height]);
}

}

