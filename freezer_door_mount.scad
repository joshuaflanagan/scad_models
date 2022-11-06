$fa=1;
$fs=.7;

erase=100; // used to make something extend through holes

mount_width = 69;
mount_depth=28.6;
mount_short_height=20;
mount_tall_height=27.4;
mount_wall_width=2.5;
mount_floor_height=5;
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

// Draw it!
main();



 

module handle_placeholder(){
  translate([0,0,mount_short_height-handle_seat_depth])
rotate([-83.9,0,0]) // figured by trial and error to get sharp point at tall side
translate([mount_depth/2,-handle_radius,0])
  cylinder(h=100, r=handle_radius);
}

module main(){
  difference(){
    main_block();
  //full_slide();
    translate([mount_wall_width, mount_wall_width, mount_floor_height])
    block_hollow();
    
    handle_placeholder();
  }
}

module block_hollow(){
  cube([mount_depth-(2*mount_wall_width), mount_width-(2*mount_wall_width), mount_tall_height+erase]);
}


module main_block(){
  screw_hole_distance_from_side=(mount_width-distance_between_screws)/2;
  
  difference(){
    cube([mount_depth, mount_width, mount_tall_height]);
    
    //short end screw (closest to origin)
    translate([ mount_depth/2, screw_hole_distance_from_side, -1])
    screw_hole();
    
    //tall end screw (furthest to origin)
    translate([ mount_depth/2, screw_hole_distance_from_side + distance_between_screws, -1])
    screw_hole();
  }
  
  module screw_hole(){
    cylinder(h=erase, r=screw_hole_r);
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
inner_radius=13 / 2;
ridge_radius=18 / 2;

ridge_height=mount_floor_height-2.4;
  
  translate([0,0,mount_floor_height])
  rotate([0,180,0])
  difference(){
    color("green")
    cube([mount_depth, outer_depth, mount_floor_height+0]);
  
    // inner gap
    translate([mount_depth/2, 20, -1]){
        cylinder(h=erase, r=inner_radius);

    }
    translate([mount_depth/2 - inner_radius, 20, -1])
        cube([inner_radius*2, erase, erase]);
    
    // inner gap ridge
    translate([mount_depth/2, 20, ridge_height-erase]){
        cylinder(h=erase, r=ridge_radius);
    }
    
    translate([mount_depth/2 - ridge_radius, 20, ridge_height-erase]){
        cube([ridge_radius*2, erase, erase]);
    }

  }
}
}