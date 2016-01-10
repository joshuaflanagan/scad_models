offset = 0.1;
$fn=16;

hole_diameter = 3;
hole_radius= hole_diameter / 2;
thickness = 8;

top_platform_width = 11.5;
top_platform_length = 22;

height_off_platform = 7;
distance_between_holes = 84;

hole_offset_x = 4;
hole_offset_y = 10;

// Top Platform where screw is inserted
difference(){
  cube([top_platform_width, top_platform_length , height_off_platform]);

  translate([hole_offset_x + hole_radius,
             hole_offset_y + hole_radius,
             -offset
            ])
  cylinder(r=hole_radius, h=height_off_platform + 2*offset);
}


support_wall_thickness = 2.5;

// side support
side_support_dip = 14;
side_support_height = side_support_dip + height_off_platform;

color([0,1,0])

translate([-support_wall_thickness,
           0,
           -side_support_dip])

cube([support_wall_thickness,
      top_platform_length,
      side_support_height]);


//back support
back_support_dip = 8;
back_support_height = back_support_dip + height_off_platform;
back_support_width = top_platform_width + support_wall_thickness;

color([0,0,1])

translate([-support_wall_thickness,
           top_platform_length,
           -back_support_dip])

cube([
      back_support_width,
      support_wall_thickness,
      back_support_height
     ]);
