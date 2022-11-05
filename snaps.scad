$fa=1;
$fs=.5;

hole_d = 6;
hole_r = hole_d / 2;

part_x = 20;
part_y = 20;
hole_depth = 5;
part_z = hole_depth + 1;

x_offset = hole_r + 1;
y_offset = hole_r + 1;
z_offset = part_z - hole_depth;

female();
translate([part_x + 2, 0, 0]) male();

module female() {
  difference() {
    cube([part_x, part_y, part_z]);
    translate([x_offset, y_offset, z_offset]) cylinder(r=hole_r, h=part_z * 2);
    translate([part_x - x_offset, part_y - y_offset, z_offset]) cylinder(r=hole_r, h=part_z * 2);
  }
}

module male() {
  cube([part_x, part_y, 2]);
  translate([x_offset, y_offset, z_offset]) cylinder(r=hole_r, h=hole_depth, $fn=8);
  translate([part_x - x_offset, part_y - y_offset, z_offset]) cylinder(r=hole_r, h=hole_depth, $fn=8);
}
