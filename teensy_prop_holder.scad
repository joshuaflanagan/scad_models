
shield_length = 48.55;
shield_width = 17.84;
shield_board_height = 4; // approximate - with solder pins
shield_post_hole_radius = 1.11;
//shield_post_hole_radius = 2;

shield_post_hole_length_offset=3.8;
shield_post_hole_width_offset=2;
shield_post_height = shield_board_height + 1;
shield_post_sides=6; // determine shape of post

wall_thickness=2;
base_bottom_thickness=1;
roominess = 0.2;

base_post_platform_length = 12;
base_void_length =shield_length + 2 * roominess;
base_void_width = shield_width + 2 * roominess;
base_void_wall_height = 16;
 
base_length = base_void_length + 2 * wall_thickness + base_post_platform_length;
base_width = base_void_width + 2 * wall_thickness;
base_height = base_void_wall_height + base_bottom_thickness;

rim_overhang = wall_thickness / 2;
rim_depth = 3;

lid_void_length = base_void_length;
lid_void_width = base_void_width;
lid_void_height = 4;

lid_length = base_length;
lid_width = base_width;
lid_height = lid_void_height + base_bottom_thickness;

lid_post_radius=5;
lid_post_height=5;

usb_gap_width = 13;
    
base();

translate([0, base_width + 4, 0]){
  lid();
}

module lid(){
  difference(){
    union(){
      cube([
        lid_length,
        lid_width,
        lid_height
      ]);
      
      // rim
      translate([rim_overhang, rim_overhang, lid_height])
      cube([
        base_length - 2*rim_overhang,
        base_width - 2*rim_overhang,
        rim_depth - 0.2 
      ]);
    }

    translate([wall_thickness, wall_thickness,base_bottom_thickness])
    cube([
      lid_void_length,
      lid_void_width,
      lid_void_height + 20
    ]);
    
    // Hole for USB cable
    usb_gap_length = 10;
    translate([-1, (lid_width-usb_gap_width)/2, -1])
    cube([
      usb_gap_length + 1,
      usb_gap_width,
      20 //protrude
    ]);
  }
  
  // button protector
  protector_length_offset = 29; // how far from edge of shield
  protector_width = 3;
  protector_height = 3;

  translate([wall_thickness + protector_length_offset, lid_width/2, base_bottom_thickness])
  cylinder(r=protector_width, h=protector_height);
  
  // connection posts
  translate([wall_thickness + base_void_length + (base_post_platform_length/2), 0, base_void_wall_height + base_bottom_thickness - 10]){
    translate([0,base_width/2,0])
    cylinder(r=lid_post_radius, h=lid_post_height, $fn=8);

  }

    
}

module base(){

  
  

  difference(){
    cube([
    base_length,
    base_width,
    base_height
    ]);
    
    translate([wall_thickness, wall_thickness,base_bottom_thickness])
    cube([
    base_void_length,
    base_void_width,
    base_void_wall_height + 20 // ensure it protrudes through top
    ]);
    

    translate([rim_overhang, rim_overhang, base_height - rim_depth])
    cube([
      base_length - 2*rim_overhang,
      base_width - 2*rim_overhang,
      20 // ensure it protrudes through top
    ]);
    
    //usb cable allowance
    base_usb_gap_depth = 8;
    translate([-1, (base_width - usb_gap_width)/2, base_height - base_usb_gap_depth])
    cube([
      20,
      usb_gap_width,
      20
    ]);
    

    //connection post holes
    post_depth_roominess = 2;
    translate([wall_thickness + base_void_length + (base_post_platform_length/2), 0, base_height - rim_depth- lid_post_height - post_depth_roominess]){
      translate([0,base_width/2,0])
      cylinder(r=lid_post_radius, h=lid_post_height + 20, $fn=0);

    }
  }
  
  //posts
  translate([wall_thickness + roominess, wall_thickness + roominess, base_bottom_thickness]){

    translate([shield_post_hole_length_offset, shield_width - shield_post_hole_width_offset, 0])
    cylinder(r=shield_post_hole_radius - 0, h=shield_post_height);

  }
  
  %translate([wall_thickness + roominess, wall_thickness + roominess, base_bottom_thickness])
  shield();

}

module shield(){
  difference(){
    cube([
      shield_length,
      shield_width,
      shield_board_height // board + solder pins
    ]);
  
    translate([shield_post_hole_length_offset, shield_post_hole_width_offset, -1])
    shield_post(height=20, sides=20);
    
    translate([shield_length - shield_post_hole_length_offset, shield_post_hole_width_offset, -1])
    shield_post(height=20, sides=20);
    
    translate([shield_post_hole_length_offset, shield_width - shield_post_hole_width_offset, -1])
    shield_post(height=20, sides=20);
    
    translate([shield_length - shield_post_hole_length_offset, shield_width - shield_post_hole_width_offset, -1])
    shield_post(height=20, sides=20);
  }
}

module shield_post(height=shield_post_height, sides=0){
  cylinder(r=shield_post_hole_radius, h=height, $fn=sides);
}


