include <hingebox_code.scad>
// https://github.com/h2odragon/MarksEnclosureHelper
VIS=0;
corner_radius=0.6;
top_rat = 0.3;
lip_rat = 0.1;

hinge_points = [ 0.5 ];
hinge_len = 30;
hinge_xrat = 0.5;
hinge_ztnotch = 3;

catch_points = [ 0.5 ];

hingedbox( outside_box );


shield_length = 48.55;
shield_width = 17.84;
shield_post_hole_radius = 1.11;

wall_thick=1.2;
roominess = 0.2;


base_void_length = shield_length + 2 * roominess;
base_void_width = shield_width + 2 * roominess;
base_void_wall_height = 16;

outside_length = base_void_length + 2 * wall_thick;
outside_width = base_void_width + 2 * wall_thick;
outside_height = base_void_wall_height + wall_thick;


outside_box = [
 outside_length,
 outside_width,
 outside_height
];

module cutout_top(d){
  //translate([0,d.x/2,0])
  //center_scale(d, 1)
  translate([0,5,-1])
  cube([10,13,8]);
  
  translate([36,7,-1])
  cube([8,8,8]);
}
module cutout_bottom(d){
  translate([-4,3,5])
  cube([10,13,8]);
}
  
//  color("green")
//  translate([wall_thick + roominess, wall_thick + roominess, wall_thick])
//  shield();

module shield(){

    cube([
      shield_length,
      shield_width,
      4 // board + solder pins
    ]);
  

}