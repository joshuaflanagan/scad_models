phone_width = 130; // iPhone 5s held horizontal, with case
phone_thickness = 11.8; // with case

phone_angle = 76.5;
phone_insert_depth = 18; // how much of phone you want inserted
phone_insert_height = phone_insert_depth * sin(phone_angle); // how far into block we need to go to achieve depth
stand_base_height = 7.5;
stand_height = stand_base_height + phone_insert_height;
slide_gap = 2; // how much wiggle room to add between phone and stand


side_wall_thickness = 5;
front_wall_thickness = 6;
front_wall_width = 15;
back_wall_thickness = 7;
support_extends = 30;
support_thickness = 20;
support_angle = 40;

phone_hole_width = phone_width + slide_gap;
phone_hole_thickness = phone_thickness + slide_gap;
phone_hole_height = phone_insert_depth * 4; // will extend out top

block_width = phone_hole_width + (side_wall_thickness * 2);
block_depth = phone_hole_thickness + back_wall_thickness + front_wall_thickness;
block_height = stand_height;

extra = 1;



stand();

translate([0, block_depth, 0])
support();

translate([block_width - support_thickness, block_depth, 0])
support();


module stand(){
  difference(){
    union(){
      cube([block_width, block_depth, block_height]);

      translate([0, -front_wall_thickness, 0])
        cube([block_width, front_wall_thickness, block_height]);
    }

    phone_insert();

    front_angle_shave();

    #front_viewer();
  }
}

module support(){
  color([0,0,1])
  rotate([90,0,90])
  linear_extrude(height=support_thickness)
  polygon(points=[
    [0,0],
    [support_extends,0],
    [0, stand_height]
      ]);
}

module phone_insert(){
  // the extra thickness added to the bottom of the back wall, because of angled phone insert
  backstop_base = phone_insert_depth * sin(90 - phone_angle);
  //  color([0,1,0])
  translate([side_wall_thickness, block_depth - back_wall_thickness - backstop_base, stand_base_height])
    rotate([(phone_angle-90), 0, 0])
    translate([0, -phone_hole_thickness, 0]) // to rotate around back left bottom corner
    cube([phone_hole_width, phone_hole_thickness, phone_hole_height]);
}

module front_angle_shave(){
  color([0,1,0])
    translate([-extra, -front_wall_thickness, 0 ])
    rotate([phone_angle-90, 0, 0])
    translate([0, -block_depth, 0])
    cube([block_width + 2 * extra, block_depth, block_height*2]);
}

module front_viewer(){
  viewer_inset = block_height * sin(90-phone_angle) / sin(phone_angle);

  translate([front_wall_width, viewer_inset + front_wall_thickness - block_depth, -extra])
    cube([block_width - (front_wall_width * 2), block_depth, block_height * 2]);
}
