$fa=1;
$fs=.7;

erase=100; // used to make something extend through holes
z=1; // a fudge factor to punch through the plane

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

// distance between 2 screw hole centers: 49. which means they are 10 off from edge
distance_between_screws=49;
screw_hole_diameter=3.75;
screw_hole_r=screw_hole_diameter/2;
screw_sink_diameter=8.4;
screw_sink_r = screw_sink_diameter/2;
screw_sink_depth=6.26;
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

screw_tower_base_square_offset=7.2; //trial and error to get the cube to line up with cylinder

slide_ridge_diameter=18;
slide_ridge_r=slide_ridge_diameter / 2;
slide_inner_diameter=13;
slide_inner_r=slide_inner_diameter / 2;
slide_floor_height=2.4;
slide_ridge_height=mount_floor_height-slide_floor_height;


slide_hole_distance_from_short=12.7;
slide_hole_distance_from_tall=12.5;

// Draw it
main();

//main_block();
//block_hollow();
//full_slide();
 


module main(){
  difference(){
    main_block();
    translate([mount_wall_width, mount_wall_width, mount_floor_height])
      block_hollow();
    handle_placeholder();
    slide();
    
    hollow_out_length=18.5;
    translate([mount_wall_width, (mount_width-hollow_out_length)/2, -z])
    cube([mount_depth-2*mount_wall_width, hollow_out_length, erase]);
  }
}

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


module handle_placeholder(){
  translate([0,0,mount_short_height-handle_seat_depth])
rotate([-83.9,0,0]) // figured by trial and error to get sharp point at tall side
translate([mount_depth/2,-handle_radius,0])
  cylinder(h=100, r=handle_radius);
}



module block_hollow(){
  inner_depth=mount_depth-(2*mount_wall_width);

  difference(){
    cube([inner_depth, mount_width-(2*mount_wall_width), mount_tall_height+erase]);
    
    translate([inner_depth/2, screw_hole_distance_from_side-mount_wall_width,-z]){
      cylinder(h=screw_tower_height_short+z, r=screw_tower_r);
      cylinder(h=screw_tower_base_height_short+z, r=screw_tower_base_r);
    }
    translate([inner_depth/2 - screw_tower_base_r, 0, -z])
      cube([screw_tower_base_diameter, screw_tower_base_square_offset, screw_tower_base_height_short+z]);

    
    translate([inner_depth/2, screw_hole_distance_from_side-mount_wall_width + distance_between_screws,-z]){
      cylinder(h=screw_tower_height_tall+z, r=screw_tower_r);
      cylinder(h=screw_tower_base_height_tall+z, r=screw_tower_base_r);
      
      translate([-screw_tower_base_r,0,0])
        cube([screw_tower_base_diameter, screw_tower_base_square_offset, screw_tower_base_height_tall+z]);
    }
  }
}


module main_block(){

  
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


module full_slide(){
outer_depth=mount_width/2+5;


// build 2 slides across from each other
slide_end();
rotate([0,0,180])
translate([mount_depth,-outer_depth, 0])
translate([0, outer_depth-mount_width, 0])
slide_end();



module slide_end(){

  translate([0,0,mount_floor_height])
  rotate([0,180,0])
  difference(){
    color("green")
    cube([mount_depth, outer_depth, mount_floor_height+0]);
  
    // inner gap
    translate([mount_depth/2, 20, -z]){
        cylinder(h=erase, r=slide_inner_r);

    }
    translate([mount_depth/2 - slide_inner_r, 20, -z])
        cube([slide_inner_r*2, erase, erase]);
    
    // inner gap ridge
    translate([mount_depth/2, 20, slide_ridge_height-erase]){
        cylinder(h=erase, r=slide_ridge_r);
    }
    
    translate([mount_depth/2 - slide_ridge_r, 20, slide_ridge_height-erase]){
        cube([slide_ridge_r*2, erase, erase]);
    }

  }
}
}