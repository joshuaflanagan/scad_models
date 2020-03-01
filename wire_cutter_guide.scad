thick = 3;
grip = 3.2;
length = 22;
wire = 8;
grip_height = 5;
gap = 3.2;
backwall_height = 12;

baseline = thick + gap + wire + thick;

// base
cube([baseline, length, thick]);

//grip front
cube([thick, length, grip_height + thick]);

//grip back
translate([thick + grip, 0, 0]){
cube([thick, length, grip_height + thick]);
}

// backwall
backwall_start = thick + gap + wire;
translate([thick + grip + wire, 0, 0]) {
cube([thick, length, backwall_height]);
}