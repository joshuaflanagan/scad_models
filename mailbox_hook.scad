$fa=1;
$fs=1;

thickness = 3.5;

mount_height=33;
mount_width=21.75;

stud_distance_from_top = 5;
stud_distance_between = 21.5;

hook_radius = 15;
hook_diameter = hook_radius * 2;
hook_offset = 1.5; //offset from mount
hook_lip = 10; // extends straight at end of hook

stud_base_width=8; //diameter
stud_base_r = stud_base_width / 2;
stud_base_height=2;
stud_neck_width = 5; //diameter
stud_neck_r = stud_neck_width / 2;
stud_neck_height = 1.65;
stud_shoulder_height=1.35; // connects base to neck
stud_head_width = 7.75; //diameter
stud_head_r = stud_head_width / 2;
stud_head_height=3;


mount();
//translate([0,-hook_offset,-hook_offset])
rotate([90, 0, 90])
hook();
//stud();

module hook(){
hook_inner_r = hook_radius;
hook_outer_r = hook_radius + thickness;
    extra = 1;
    
    translate([0, -hook_radius, 0])
    linear_extrude(height=mount_width){
        
    difference(){
circle(hook_outer_r);
circle(hook_inner_r);
translate([0, -hook_outer_r - extra])
square(hook_outer_r * 2 + extra);
    }
    translate([0, -hook_outer_r])
    square([hook_lip, thickness]);
    
    
}
    
}

module mount(){
  midpoint = mount_width / 2;
  
  linear_extrude(height=thickness){

    square([mount_width, mount_height]);
    

    
      translate([midpoint,mount_height])
    circle(midpoint);
      
  }
  
  translate([midpoint, stud_distance_from_top, thickness])
  stud();
  
  translate([midpoint, stud_distance_from_top + stud_distance_between, thickness])
  stud();
}

module stud(){
   //base
  cylinder(r=stud_base_r, h=stud_base_height);

   //shoulders
   translate([0,0,stud_base_height])
   cylinder(r=stud_base_r, r2=stud_neck_r, h=stud_shoulder_height);
    
    //neck
    translate([0,0,stud_base_height + stud_shoulder_height])
    cylinder(r=stud_neck_r, h=stud_neck_height);
    
    //head
    translate([0,0,stud_base_height + stud_shoulder_height + stud_neck_height])
    cylinder(r=stud_head_r, h=stud_head_height);
}
