screw_hole=4.5;
width=13.5;
length=13.5;

washer(1);
translate([width + 1, 0, 0])
washer(2);

module washer(thick){
difference(){
  cube([width, length, thick]);

  translate([width/2, length/2, -1])
  cylinder(r= (screw_hole / 2), h=10);
}
}