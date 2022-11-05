// 6-key keyboard with foot pedal
$fa=1;
$fs=.7;

/*
 ISSUES

1) DONE phone box isnt hollowed out in front. not enough room
2) DONE need a little more room in the length of the tray gap
3) key plate needs to be on a raft? print holes a little larger? specified 14 - printed 13.8
4) DONE lip the edges so the fasten together
5) DONE reduce post insertion. too strong
6) HOLD add posts to corners? may not be needed with lipped edges
7) DONE slope the front. looks better - can differentiate front from back

*/

cherry_switch_side = 14.0;
key_plate_thickness = 1.4;
switch_end_gap = 5;
switch_between_gap = 5;

switch_under_gap = 8;

phone_box_w = 22;
phone_box_h = 15.4;
phone_box_depth = 15.4;
phone_holder_w = phone_box_w + 0.2;
phone_holder_h = phone_box_h;
phone_holder_depth = phone_box_depth + 0.2;

include <teensy_lc.scad>

teensy_tray_bottom_thickness = 1;
teensy_tray_top_thickness = 0.8;
tray_wall_thickness = 1;
tray_width = (tray_wall_thickness * 2) + teensy_lc_board_width;
tray_length = (tray_wall_thickness * 2) + teensy_lc_board_length; // + 1.4;
tray_height = 6;
tray_give_x = 0.2 + 2;
tray_give_y = 0.2;

key_plate_wall_thickness = 2;
key_plate_width =(2*switch_end_gap) + (3*cherry_switch_side) + (2*switch_between_gap);
key_plate_depth =(2*switch_end_gap) + (2*cherry_switch_side) + switch_between_gap;
key_plate_wall_height = switch_under_gap;
key_post_insertion = 3.5;
key_post_height = key_plate_wall_height + key_post_insertion;
key_post_sides = 6;

top_padding_front_y = 1.8;
top_padding_back_y = 1;
outer_w = key_plate_width + (2*key_plate_wall_thickness);
outer_d = key_plate_depth + (2*key_plate_wall_thickness) + top_padding_front_y + top_padding_back_y;

base_bottom_thickness = 1;
base_wall_thickness = key_plate_wall_thickness;
base_d = outer_d;
base_l = outer_w;
base_h = base_bottom_thickness + phone_holder_h;

// position the components
tray_x = 0;
tray_y = base_wall_thickness;
tray_z = base_bottom_thickness;

phone_box_face_thickness = 0.8;
phone_box_x = phone_box_face_thickness;
phone_box_y = tray_y + tray_width;
phone_box_z = base_bottom_thickness;

phone_holder_backup_x = phone_box_x + phone_holder_depth;
phone_holder_backup_y = tray_y + tray_width;
phone_holder_backup_z = base_bottom_thickness;
phone_holder_backup_thickness = 2;
phone_holder_side_thickness = 1;

post_offset = 0.2;
post_thickness = switch_between_gap - (2*post_offset);
key_post_radius = post_thickness/2;
base_post_inner_radius = key_post_radius;
base_post_wall_thickness = 1;
base_post_radius = base_post_inner_radius + base_post_wall_thickness;
base_post_side = base_post_radius * 2;


translate([0, outer_d, base_h + key_plate_wall_height])
//rotate(a=180, v=[1,0,0])
//color("blue")
lid();

color("orange")
base();

translate([tray_x, tray_y, tray_z])
teensy_tray();

%color("white")
translate([phone_box_x, phone_box_y, phone_box_z])
phone_box();

translate([phone_holder_backup_x, phone_holder_backup_y, phone_holder_backup_z])
phone_holder_backup();

translate([phone_box_x, phone_box_y + phone_holder_w, 0])
phone_holder_side();

translate([
  key_plate_wall_thickness,
  outer_d - key_plate_wall_thickness - top_padding_back_y,
  0])
{
  base_post_y_line = -switch_end_gap - cherry_switch_side - post_offset - base_post_side + base_post_wall_thickness;

  translate([switch_end_gap + cherry_switch_side - base_post_wall_thickness + post_offset,
     base_post_y_line,
     0])
  base_post();

  translate([switch_end_gap + cherry_switch_side - base_post_wall_thickness + post_offset + switch_between_gap + cherry_switch_side,
     base_post_y_line,
     0])
  base_post();
}

color("purple")
translate([0,0, base_h])
connection_rim();

rim_height = 2;
rim_thickness = 1;


module connection_rim(){
  difference(){
    cube([outer_w, outer_d, rim_height]);
    translate([rim_thickness, rim_thickness, - 0.5])
    cube([outer_w - (2*rim_thickness), outer_d - (2*rim_thickness), 10]);
  }
}

module base_post(){
  post_hole_depth = key_post_insertion + 0.6; // allow some wiggle at bottom
  base_post_base_leeway = 0.2;
  difference(){
    cube([base_post_side, base_post_side, base_h - base_post_base_leeway]);
    translate([base_post_radius, base_post_radius, (base_h - post_hole_depth)])
    cylinder(r=base_post_inner_radius, h=post_hole_depth + 1);
  }
}

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
    translate([-1, base_wall_thickness, base_bottom_thickness])
    cube([1 + tray_length, tray_width, tray_height]);

    //cutout for phone jack
    jack_w = 12;
    jack_h = 12;
    jack_bottom_overhang = 1.5;
    jack_side_overhang = 0.8;
    translate([
      -1,
      phone_box_y + phone_holder_w - jack_w - jack_side_overhang, // lower left corner of cutout
      base_bottom_thickness + jack_bottom_overhang
    ])
    cube([5, jack_w, jack_h]);

    translate([phone_box_x, phone_box_y, phone_box_z])
    phone_box();
  }
}



module phone_holder_backup(){
  translate([phone_holder_backup_thickness, 0, 0])
  rotate(a=-90, v=[0,1,0])
  linear_extrude(height=phone_holder_backup_thickness){
    cutout_r = phone_holder_w/2 - 1;
    holder_wall_height = 0.8 * phone_holder_h;

    difference(){
      square([ holder_wall_height, phone_holder_w + phone_holder_side_thickness]);
      translate([holder_wall_height, cutout_r + 1])
      circle(r=cutout_r);
    }
  }
}

module phone_holder_side(){
  cube([
    phone_holder_depth,
    phone_holder_side_thickness,
    phone_holder_h/2
  ]);
}

module phone_box(){
  cube([phone_box_depth, phone_box_w, phone_box_h]);
}


module lid(){
  // the key plate
  color("pink")
  translate([key_plate_wall_thickness, key_plate_wall_thickness, 0])
  linear_extrude(height=key_plate_thickness){
    difference(){
      square([
        key_plate_width,
        key_plate_depth + top_padding_front_y + top_padding_back_y
      ]);

      translate([0, top_padding_back_y, 0]){
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
  }

  //top walls
  difference(){
    cube([outer_w, outer_d, key_plate_wall_height]);
    translate([key_plate_wall_thickness, key_plate_wall_thickness, -1])
    cube([
      key_plate_width,
      key_plate_depth + top_padding_front_y + top_padding_back_y,
      2 * key_plate_wall_height 
    ]);
    translate([0, 0, key_plate_wall_height - rim_height])
    connection_rim();

#color("green")
translate([-10, outer_d - key_plate_wall_thickness, 0])
rotate(a=30, v=[-1, 0, 0])
cube([outer_w +20, key_plate_wall_thickness * 4, 20]);

   }


  // posts
  translate([key_plate_wall_thickness, key_plate_wall_thickness + top_padding_back_y, 0]){
    translate([
      switch_end_gap + cherry_switch_side + post_offset,
      switch_end_gap + cherry_switch_side + post_offset,
      0
    ])
    keyplate_post();

    translate([
      switch_end_gap + (2*cherry_switch_side) + switch_between_gap + post_offset,
      switch_end_gap + cherry_switch_side + post_offset,
      0
    ])
    keyplate_post();
  }


  module keyplate_post(){
    cube([post_thickness, post_thickness, key_plate_wall_height]);
    /*cube([post_thickness, post_thickness, key_post_height]);*/
    translate([key_post_radius, key_post_radius, 0])
    cylinder(r=key_post_radius, h=key_post_height, $fn=key_post_sides);
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
     teensy_lc_board_length + tray_give_x,
     teensy_lc_board_width + tray_give_y,
     30
  ]);
  
    usb_gap = 8.5;
    translate([-0.5, (tray_width - usb_gap) / 2, teensy_tray_bottom_thickness + teensy_lc_board_thickness - 0.3])
    cube([tray_wall_thickness * 2, usb_gap, 10]);

  // filament saver
  saver_gap_w = teensy_lc_board_width; // * 0.8;
  saver_gap_l = teensy_lc_board_length * 0.8;
  translate([(tray_length - saver_gap_l) / 2,  (tray_width - saver_gap_w) / 2, -2])
  cube([ saver_gap_l,
        saver_gap_w,
        30
        ]);
  
  
/*
  //pin allowance
  pin_window_l = teensy_lc_pin_separation * 7;
    translate([ (tray_length - pin_window_l) / 2, tray_wall_thickness, -0.1])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness + 1]);
    translate([ (tray_length - pin_window_l) / 2, tray_width - tray_wall_thickness - 4, -0.1])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness+ 1]);
*/

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
