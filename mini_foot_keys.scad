// 6-key keyboard with foot pedal

cherry_switch_side = 14;
cherry_switch_thickness = 1.4;
switch_end_gap = 5;
switch_between_gap = 5;

switch_under_gap = 8;

phone_box_w = 22;
phone_box_h = 15.4;
phone_box_depth = 15.4;
phone_holder_w = phone_box_w;
phone_holder_h = phone_box_h;
phone_holder_depth = phone_box_depth + 0.1;

include <teensy_lc.scad>

teensy_tray_bottom_thickness = 1;
teensy_tray_top_thickness = 0.8;
tray_wall_thickness = 1;
tray_width = (tray_wall_thickness * 2) + teensy_lc_board_width;
tray_length = (tray_wall_thickness * 2) + teensy_lc_board_length;
tray_height = 6;
tray_give = 0.2;

key_plate_wall_thickness = 3;
key_plate_width =(2*switch_end_gap) + (3*cherry_switch_side) + (2*switch_between_gap) + (2*key_plate_wall_thickness);
key_plate_depth =(2*switch_end_gap) + (2*cherry_switch_side) + switch_between_gap + (2*key_plate_wall_thickness);
key_plate_wall_height = switch_under_gap;

base_bottom_thickness = 1;
base_wall_thickness = key_plate_wall_thickness;
base_d = key_plate_depth;
base_l = key_plate_width;
base_h = base_bottom_thickness + phone_holder_h;


// position the components
tray_x = 0;
tray_y = base_wall_thickness;
tray_z = base_bottom_thickness;

phone_box_x = base_wall_thickness;
phone_box_y = tray_y + tray_width;
phone_box_z = base_bottom_thickness;

phone_holder_backup_x = phone_box_x + phone_holder_depth;
phone_holder_backup_y = tray_y + tray_width;
phone_holder_backup_z = base_bottom_thickness;
phone_holder_backup_thickness = 1.6;



translate([0, key_plate_depth, base_h + key_plate_wall_height])
//rotate(a=180, v=[1,0,0])
color("blue")
key_plate();

color("orange")
base();

translate([tray_x, tray_y, tray_z])
teensy_tray();

%color("white")
translate([phone_box_x, phone_box_y, phone_box_z])
phone_box();

translate([phone_holder_backup_x, phone_holder_backup_y, phone_holder_backup_z])
phone_holder_backup();





module base(){
  difference(){
    cube([base_l, base_d, base_h]);

    // hollow it out
    translate([base_wall_thickness, base_wall_thickness, base_bottom_thickness])
    cube([
      base_l - (2*base_wall_thickness),
      base_d - (2*base_wall_thickness),
      base_h * 2 //meaningless - big enough to protrude out top
    ]);

    //cutout for teensy tray
    translate([-1, 0, base_bottom_thickness])
    cube([1 + tray_length, tray_width, tray_height]);

    //cutout for phone jack
    jack_w = 12;
    jack_h = 12;
    jack_bottom_overhang = 1.5;
    jack_side_overhang = 0.8;
    translate([
      -1,
      base_d - jack_w - base_wall_thickness - jack_side_overhang, // lower left corner of cutout
      base_bottom_thickness + jack_bottom_overhang
    ])
    cube([5, jack_w, jack_h]);
  }
}


module phone_holder_backup(){
  translate([phone_holder_backup_thickness, 0, 0])
  rotate(a=-90, v=[0,1,0])
  linear_extrude(height=phone_holder_backup_thickness){
    cutout_r = phone_holder_w/2 - 1;
    holder_wall_height = 0.8 * phone_holder_h;

    difference(){
      square([ holder_wall_height, phone_holder_w]);
      translate([holder_wall_height, cutout_r + 1])
      circle(r=cutout_r);
    }
  }
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
