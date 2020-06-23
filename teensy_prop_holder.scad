include <teensy_lc.scad>

  kt_width = 25;
  kt_length=119.5;
  kt_height=10.5;
  kt_thickness = 1.5;


holder_bottom_groove_depth = 2;
holder_side_groove_depth = 2;
holder_side_length = 5;
holder_end_thickness = holder_side_length - holder_side_groove_depth;
holder_face_thickness = 2;
holder_bottom_length = kt_length + (2 * holder_end_thickness);
holder_bottom_width = kt_width + (2 * holder_face_thickness);
holder_bottom_thickness = 4;


// holder bottom
difference() {
  cube([ holder_bottom_length, holder_bottom_width, holder_bottom_thickness]);

//grooves
  translate([holder_end_thickness, holder_face_thickness, holder_bottom_groove_depth])
  cube([kt_length, kt_thickness, kt_height]);

  translate([holder_end_thickness, kt_width - holder_face_thickness, holder_bottom_groove_depth])
  cube([kt_length, kt_thickness, kt_height]);


}


#holder_end();
#translate([holder_bottom_length - holder_side_length, 0, 0])
holder_end();

module holder_end(){
cube([holder_side_length, holder_bottom_width, kt_height + holder_bottom_thickness]);

}

/*
translate([
  holder_end_thickness,
  holder_face_thickness,
  holder_bottom_thickness - holder_bottom_groove_depth
  ])
 keytester();
*/

module keytester(){
  inner_offset = 1;
  
  //base
  color("grey")
  difference(){
  cube([kt_length, kt_width, kt_height]);
  
  translate([-inner_offset, kt_thickness, -kt_thickness])
  cube([
    kt_length + inner_offset * 2,
    kt_width - (2 * kt_thickness),
    kt_height
  ]);
  }
  
  //keys
  key_inset_l = 4.4;
  key_inset_w = 4.7;
  key_inset_h = 1.25;
  
  color("blue")
  translate([key_inset_l, key_inset_w, kt_height])
  cube([
    kt_length - (2 * key_inset_l),
    kt_width - (2 * key_inset_w),
    key_inset_h
  ]);

  key_bottom_height = 5.5;
  
  color("blue")
  translate([key_inset_l, key_inset_w, kt_height - kt_thickness - key_bottom_height])
  cube([
    kt_length - (2 * key_inset_l),
    kt_width - (2 * key_inset_w),
    key_bottom_height
  ]);  
  
}

teensy_tray_bottom_thickness = 0.8;
teensy_tray_top_thickness = 0.8;
!teensy_tray();
tray_wall_thickness = 1;

module teensy_tray(){
  tray_width = (tray_wall_thickness * 2) + teensy_lc_board_width;
  tray_length = (tray_wall_thickness * 2) + teensy_lc_board_length;
  tray_height = 6;
  tray_give = 0.2;
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
    translate([ (tray_length - pin_window_l) / 2, tray_wall_thickness, 0])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness]);
    translate([ (tray_length - pin_window_l) / 2, tray_width - tray_wall_thickness - 4, 0])
    cube([pin_window_l, 4, teensy_tray_bottom_thickness]);

  }  // end difference
  
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


  //temp cap test
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
    
  //show the teensy
  %translate([tray_wall_thickness + tray_give/2, tray_wall_thickness + tray_give/2, teensy_tray_bottom_thickness]) 
  teensy_lc(bounding_box=false);
}
