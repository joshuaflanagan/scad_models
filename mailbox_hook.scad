$fa=1;
$fs=.7;

thickness = 3.5;

mount_height=33;
mount_width=21.75;

stud_distance_from_top = 5;
stud_distance_between = 21.5;

hook_diameter = 30;
hook_radius = hook_diameter / 2;

hook_offset = 1.5; //offset from mount
//hook_lip = 10; // extends straight at end of hook

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

//connector();


mount();
//translate([0,-hook_offset,-hook_offset])
rotate([90, 0, 90])
hook();
//stud();

        square_size = hook_offset + thickness;
module connector(){

  connector_curve([-1, 0]);
  translate([0, (square_size + hook_offset)/2])
  connector_curve([0, -1]);
}

module connector_curve(quadrant){
  inner_connector_r = hook_offset / 2;
  outer_connector_r = (hook_offset + thickness) / 2;
  

    intersection(){
     translate(square_size * quadrant)
     square(square_size);   
    difference(){
    circle(outer_connector_r);
        circle(inner_connector_r);
    }
}
}

module hook(){
hook_outer_r = hook_radius;
hook_inner_r = hook_radius - thickness;

    extra = 1;
    
    translate([0, -hook_inner_r, 0])
    linear_extrude(height=mount_width){
        
    difference(){
circle(hook_outer_r);
circle(hook_inner_r);
translate([0, -hook_outer_r - extra])
square(hook_outer_r * 2 + extra);
    }
    
    // just enough to connect to mount, prevent manifold issue
    translate([0, hook_outer_r - thickness])
    square([extra, thickness]);    

    
    
}



    rounded_end_r = mount_width / 2;
    translate([0, -hook_diameter + thickness, rounded_end_r])
    rotate([0, 90, 90])
    linear_extrude(thickness)
    difference(){
      circle(rounded_end_r);
      translate([-rounded_end_r - 1, 0])
      square(rounded_end_r*2 + 2);
    }

    
}

module mount(){
  midpoint = mount_width / 2;
  
  linear_extrude(height=thickness){
    mount_length = mount_height - midpoint;
    square([mount_width, mount_length]);
    

    
      translate([midpoint,mount_length])
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
