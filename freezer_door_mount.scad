inner_radius=13 / 2;
ridge_radius=18 / 2;

outer_width=28.6;
outer_depth=40;
height=5;

ridge_height=height-2.4;

erase=100;

translate([0,0,height])
rotate([0,180,0])
difference(){
    color("green")
    cube([outer_width, outer_depth, height]);
  
    // inner gap
    translate([outer_width/2, 20, -1]){
        cylinder(h=erase, r=inner_radius);

    }
    translate([outer_width/2 - inner_radius, 20, -1])
        cube([inner_radius*2, erase, erase]);
    
    // inner gap ridge
    translate([outer_width/2, 20, ridge_height-erase]){
        cylinder(h=erase, r=ridge_radius);
    }
    
    translate([outer_width/2 - ridge_radius, 20, ridge_height-erase]){
        cube([ridge_radius*2, erase, erase]);
    }
    
}