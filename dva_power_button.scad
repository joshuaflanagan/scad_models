$fa=1;
$fs=.7;

button_outer_diameter = 25.55;
button_outer_r = button_outer_diameter / 2;
button_wall_height = 6.44;
button_wall_thickness = 1.84;
button_face_thickness = 1.6;

button_prong_height = 15.52; // from face of button
button_prong_width = 5.85;
button_prong_thickness = 1;

button_clip_overhang = 1.4;
button_clip_height = 3.15;

button_plunger_height = 8.7;
button_plunger_thickness=5.22;  //same access as prong thickness
button_plunger_width=4.2;
plunger_hollow_thickness=3;
plunger_hollow_width=1.98;
plunger_hollow_depth=3.88;

cutout_height=1;

color("blue")

difference(){
button();

//fb_side=24;
//translate([-fb_side/2,-fb_side/2,0])
//cube([fb_side,fb_side,4]);

translate([0,0,button_face_thickness*2])
resize([0,0,button_face_thickness*4])
dva_cutout();
}

module dva_cutout(){
difference() {
color("pink")

rotate(a=180, v=[0,1,0])
dva_backdrop();

color("white")
rotate(a=180, v=[0,1,0])
resize([button_outer_r, button_outer_r, 2])
dva_logo();
}
}

module button(){
difference(){
  cylinder(h=button_wall_height, r=button_outer_r);
  //hollow out the button bottom
  translate([0,0,button_face_thickness]) // raise it to allow the face
    cylinder(h=button_wall_height, r=button_outer_r-(button_wall_thickness));
}

prong_offset_x = button_outer_r - button_prong_thickness - 0.3;
prong_offset_y = button_prong_width / 2;

translate([prong_offset_x, -prong_offset_y, 0])
prong();

translate([-prong_offset_x, prong_offset_y, 0])
rotate(a=180, v=[0,0,1])
prong();

//plunger
difference(){
translate([-button_plunger_thickness/2, -button_plunger_width/2, 0])
cube([button_plunger_thickness, button_plunger_width, button_plunger_height]);
//hollow
translate([-plunger_hollow_thickness/2, -plunger_hollow_width/2, button_plunger_height-plunger_hollow_depth+0.01])
cube([plunger_hollow_thickness, plunger_hollow_width, plunger_hollow_depth]);
}



}

module prong(){
  cube([button_prong_thickness, button_prong_width, button_prong_height]);
  
  clip_x = button_clip_overhang;
  clip_y = button_clip_height;
  clip_inset = 0.01; //to make sure the surfaces join
  
  translate([button_prong_thickness-clip_inset, button_prong_width, button_prong_height - button_clip_height])
  rotate(a=90, v=[1,0,0])
  linear_extrude(height=button_prong_width)
  polygon(points=[ [0, 0], [clip_x + clip_inset, 0], [0, clip_y] ]);
}

module dva_backdrop(){
  linear_extrude(height=cutout_height)
  circle(r=7.08);
}

module dva_logo() {
logo_path = "/Users/josh/Downloads/dva_logo_white_on_black.png";

translate([0,0,-0.5])
  difference(){
    resize(newsize=[0,0,3])
      surface(file=logo_path, center=true);

    translate([0, 0, -0.5])
      cube([200,200,1], center=true);
}
}
