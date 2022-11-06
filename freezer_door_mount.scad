$fa=1;
$fs=.7;

erase=100; // used to make something extend through holes
z=1; // a fudge factor to punch through the plane

// The entire piece is the "mount". width along y, depth along x, height along z
// The "bottom" is the part that touches the freezer. It is at z=0.
// The "top" is the part that connects to the handle.


mount_width = 69;
mount_depth=28.6;
mount_short_height=20;
mount_tall_height=27.4;
mount_wall_width=2.5;
mount_floor_height=4.3; //was 5? remeasured and 4.3 seems right
handle_seat_depth=mount_tall_height-21;

// find radius of handle
//  radius of an arc = H/2 + W^2 / 8*H https://www.mathopenref.com/arcradius.html
handle_radius = handle_seat_depth/2 + (mount_depth*mount_depth)/(8 * handle_seat_depth);

// distance between 2 screw hole centers
distance_between_screws=56;
screw_hole_diameter=4.6;
screw_hole_r=screw_hole_diameter/2;

screw_tower_diameter=7.6;
screw_tower_r=screw_tower_diameter/2;
screw_hole_distance_from_side=(mount_width-distance_between_screws)/2; //4.5 + screw_hole_r;
screw_tower_height_short=12; //8.8; // top of tower down to base plastic top
screw_tower_height_tall=16; // this might not matter, should get chopped by handle cylinder
screw_tower_base_diameter=12.45;
screw_tower_base_r=screw_tower_base_diameter/2;
screw_tower_base_height_short=2.6;
screw_tower_base_height_tall=6;

screw_head_hole_wall_width=1.2;
screw_head_hole_depth_short=6.1;
screw_head_hole_depth_tall=8.3;
screw_head_hole_diameter=screw_tower_base_diameter-(2*screw_head_hole_wall_width);
screw_head_hole_r=screw_head_hole_diameter/2;

screw_tower_base_square_offset=5.0; //trial and error to get the cube to line up with cylinder

slide_ridge_diameter=18;
slide_ridge_r=slide_ridge_diameter / 2;
slide_inner_diameter=13;
slide_inner_r=slide_inner_diameter / 2;
slide_floor_height=2.4;
slide_ridge_height=mount_floor_height-slide_floor_height;

slide_hole_distance_from_short=12.7;
slide_hole_distance_from_tall=12.5;

tower_rise_angle=8; //only used for end walls and screw towers

hollow_out_length=18.5; // big enough for freezer clip square
hollow_out_offset_from_end=(mount_width-hollow_out_length)/2;


// Draw it
main();

module slant(angle){
  multmatrix(m = [ 
  [1, 0,           0, 0],
  [0, 1, sin(angle), 0],
  [0,0,1,0],
  [0,          0,           0, 1]

  ]) children();
}

module main(){
  difference(){
    main_block();
    translate([mount_wall_width, mount_wall_width, mount_floor_height])
      block_hollow();
    handle_placeholder();
    slide();
    

    translate([mount_wall_width, hollow_out_offset_from_end, -z])
    cube([mount_depth-2*mount_wall_width, hollow_out_length, erase]);
  }
}

// Two long ovals, the smaller one is a hole, the larger one is the ridge
// that will slide onto the freezer clasp
module slide(){
  hull(){
    translate([mount_depth/2, slide_hole_distance_from_short+slide_inner_r, -z])
    cylinder(h=erase, r=slide_inner_r);
    translate([mount_depth/2, mount_width-(slide_hole_distance_from_tall+slide_inner_r), -z])
    cylinder(h=erase, r=slide_inner_r);
  }
  
  hull(){
    translate([mount_depth/2, slide_hole_distance_from_short+slide_inner_r, -z])
    cylinder(h=slide_ridge_height+z, r=slide_ridge_r);
    translate([mount_depth/2, mount_width-(slide_hole_distance_from_tall+slide_inner_r), -z])
    cylinder(h=slide_ridge_height+z, r=slide_ridge_r);
  }
}


// gives the long rounded top where the handle will fit in 
module handle_placeholder(){
 translate([0,0,mount_short_height-handle_seat_depth])
 rotate([-83.9,0,0]) // figured by trial and error to get sharp point at tall side
 translate([mount_depth/2,-handle_radius,0])
   cylinder(h=100, r=handle_radius);
}



module block_hollow(){
  inner_depth=mount_depth-(2*mount_wall_width);

  difference(){
    slant(tower_rise_angle)
    cube([inner_depth, mount_width-(2*mount_wall_width), mount_tall_height+erase]);
    
    // screw tower short
    translate([inner_depth/2, screw_hole_distance_from_side-mount_wall_width,-z]){
      slant(tower_rise_angle)
      cylinder(h=screw_tower_height_short+z, r=screw_tower_r);
      cylinder(h=screw_tower_base_height_short+z, r=screw_tower_base_r);
    }
    translate([inner_depth/2 - screw_tower_base_r, 0, -z])
      cube([screw_tower_base_diameter, screw_tower_base_square_offset, screw_tower_base_height_short+z]);

    // screw tower tall
    translate([inner_depth/2, screw_hole_distance_from_side-mount_wall_width + distance_between_screws,-z]){
      slant(tower_rise_angle)
      cylinder(h=screw_tower_height_tall+z, r=screw_tower_r);
      cylinder(h=screw_tower_base_height_tall+z, r=screw_tower_base_r);
      
      translate([-screw_tower_base_r,0,0])
        cube([screw_tower_base_diameter, screw_tower_base_square_offset, screw_tower_base_height_tall+z]);
    }
  }
  
  hook_track_indent=0.8;

  translate([hook_track_indent, hollow_out_offset_from_end-hook_track_length-2.4, -hook_track_depth])
  hook_track();
  
  translate([inner_depth - (hook_track_width+hook_track_indent), hollow_out_offset_from_end-hook_track_length - 2.4, -hook_track_depth])
  hook_track();
  
  tall_end_track_start=hollow_out_offset_from_end+hollow_out_length-2.52;
  
  translate([hook_track_indent, tall_end_track_start, 0])
  hook_track(false);
  
  translate([inner_depth - (hook_track_width+hook_track_indent), tall_end_track_start, 0])
  hook_track(false);
}

// add ridges for clasp hooks to slide on
hook_track_width=3.9 + .2; // how wide are the hooks
hook_track_length=16.5 +1; // how long are the hooks
hook_track_depth=0.8 +0.2; //how deep of a groove into the surface, for the hook grabber

module hook_track(rise=true){
  angle=rise ? 3 : -3;
  color("red")
  rotate([angle,0,0]) // trial and error
  // add z to height to push it up into the block further, so they are connected
  cube([hook_track_width, hook_track_length, hook_track_depth+z]);
}


module main_block(){
  slant(tower_rise_angle)
  difference(){
    cube([mount_depth, mount_width, mount_tall_height]);
    
    //short end screw (closest to origin)
    translate([ mount_depth/2, screw_hole_distance_from_side, -z])
    screw_hole(screw_head_hole_depth_short);
    
    bottom_square_tower_base=screw_tower_base_diameter-2*screw_head_hole_wall_width;

    translate([mount_depth/2 - bottom_square_tower_base/2, mount_wall_width, -z])
    cube([bottom_square_tower_base, screw_tower_base_square_offset, screw_head_hole_depth_short]);
    
    //tall end screw (furthest to origin)
    translate([ mount_depth/2, screw_hole_distance_from_side + distance_between_screws, -z])
    screw_hole(screw_head_hole_depth_tall);
    
    translate([mount_depth/2 - bottom_square_tower_base/2, mount_wall_width+distance_between_screws+screw_tower_base_square_offset, -z])
    cube([bottom_square_tower_base, screw_tower_base_square_offset, screw_head_hole_depth_tall]);
  }
  
  module screw_hole(depth){
    cylinder(h=erase, r=screw_hole_r);
    //screw head hole on bottom
    cylinder(h=depth,r=screw_head_hole_r);
  }
}
