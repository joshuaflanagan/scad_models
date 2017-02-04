// 6-key keyboard with foot pedal

cherry_switch_side = 14;
cherry_switch_thickness = 1.4;
switch_end_gap = 5;
switch_between_gap = 5;

switch_under_gap = 8;

phone_box_w = 22;
phone_box_h = 15.4;
phone_box_depth = 15.4;

include <teensy_lc.scad>

teensy_tray_bottom_thickness = 0.8;
teensy_tray_top_thickness = 0.8;
tray_wall_thickness = 1;
tray_width = (tray_wall_thickness * 2) + teensy_lc_board_width;
tray_length = (tray_wall_thickness * 2) + teensy_lc_board_length;
tray_height = 6;
tray_give = 0.2;

key_plate_width =(2*switch_end_gap) + (3*cherry_switch_side) + (2*switch_between_gap);
key_plate_depth =(2*switch_end_gap) + (2*cherry_switch_side) + switch_between_gap;
key_plate_wall_height = switch_under_gap;
key_plate_wall_thickness = 1;

base_d = key_plate_depth;
base_l = key_plate_width;
base_bottom_thickness = 1;
base_wall_thickness = 1;
base_h = base_bottom_thickness + phone_box_h + key_plate_wall_height;

translate([0, key_plate_depth, base_h])
rotate(a=180, v=[1,0,0])
key_plate();

%base();

translate([0, 0, base_bottom_thickness])
teensy_tray();

color("white")
translate([base_wall_thickness, tray_width, base_bottom_thickness])
phone_box();





module base(){
  cube([base_l, base_d, base_h]);
}

module phone_box(){
  cube([phone_box_depth, phone_box_w, phone_box_h]);
}


module key_plate(){
  linear_extrude(height=cherry_switch_thickness){
    difference(){
      square([
        key_plate_width,
        key_plate_depth
      ]);
      
      for(i=[0:2]){
      translate([switch_end_gap + (i * (cherry_switch_side + switch_between_gap)), switch_end_gap])
      switch_mount();
      }
      for(i=[0:2]){
      translate([switch_end_gap + (i * (cherry_switch_side + switch_between_gap)), switch_end_gap + switch_between_gap + cherry_switch_side])
      switch_mount();
      }
    }
  }
  
  difference(){
    cube([key_plate_width, key_plate_depth, key_plate_wall_height]);
    translate([key_plate_wall_thickness, key_plate_wall_thickness, -1])
    cube([
      key_plate_width - (2*key_plate_wall_thickness),
      key_plate_depth - (2*key_plate_wall_thickness),
      2 * key_plate_wall_height 
    ]);
   }

  module switch_mount(){
    square(cherry_switch_side);
  }
}



module teensy_tray(){
  difference(){
  cube([
    tray_length,
    tray_width,
    tray_height
  ]);
  color("red")
   translate([tray_wall_thickness, tray_wall_thickness, teensy_tray_bottom_thickness])
   cube([
     teensy_lc_board_length + tray_give,
     teensy_lc_board_width + tray_give,
     30
  ]);
  
    usb_gap = 8.5;
    translate([-0.5, (tray_width - usb_gap) / 2, teensy_tray_bottom_thickness + teensy_lc_board_thickness - 0.3])
    cube([tray_wall_thickness * 2, usb_gap, 10]);

  // filament saver
  saver_gap_w = teensy_lc_board_width * 0.8;
  saver_gap_l = teensy_lc_board_length * 0.8;
  translate([(tray_length - saver_gap_l) / 2,  (tray_width - saver_gap_w) / 2, -2])
  cube([ saver_gap_l,
        saver_gap_w,
        30
        ]);
  
  
  //pin allowance
  pin_window_l = teensy_lc_pin_separation * 7;
    translate([ (tray_length - pin_window_l) / 2, tray_wall_thickness, -0.1])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness + 1]);
    translate([ (tray_length - pin_window_l) / 2, tray_width - tray_wall_thickness - 4, -0.1])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness+ 1]);

  }  // end difference
  
  /*
  // peg platform
  platform_l = 6;
  translate([tray_length, 0, 0])
  cube([platform_l, tray_width, tray_height]);
  // peg
  peg_height = 1.8;
  peg_sides = 6;
  peg_radius = 2;
  translate([tray_length + (platform_l / 2), tray_width / 4, 0])
  cylinder(r=peg_radius, h=tray_height + peg_height, $fn=peg_sides);
  translate([tray_length + (platform_l / 2), tray_width * 3 / 4, 0])
  cylinder(r=peg_radius, h=tray_height + peg_height, $fn=peg_sides);
*/

  //temp cap test
  /*
  cap_thickness = 2.4;
  translate([0, tray_width+2, 0])
  difference(){
    translate([tray_length/2,0,0])
    cube([tray_length/2, tray_width, cap_thickness]);
  
    translate([tray_length - (platform_l / 2), tray_width /4, cap_thickness - peg_height - .1])
    cylinder(r=peg_radius, h=10);
    translate([tray_length - (platform_l / 2), tray_width*3 /4, cap_thickness - peg_height - .1])
    cylinder(r=peg_radius, h=10);
  }
  */
 
/* 
  //show the teensy
  %translate([tray_wall_thickness + tray_give/2, tray_wall_thickness + tray_give/2, teensy_tray_bottom_thickness]) 
  teensy_lc(bounding_box=false);
  */
}
