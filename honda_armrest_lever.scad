/*

                +-+
                | |
                | | Latch
                | |                                             +---+
                | |                                           |--|  |
+----------     +-+-+-----------+                      Latch  +--+  |
|         |     |   |           |                                |  |
|   +--+  |     |   +---------+ |                                |  |
|   |  |  |     |   |         | |                                |  |  Clip
|   +--+  ++    | C |         | |                              +-+  |
|          |    | l |         | |  w                           | |  |
|          |    | i |         | |  i                           | |  |    |
|          +----+ p |         | |  d                           | |  |  31.25
|  Screw   |    |   |         | |  t                           | |  |    |
|  base    |    |   |         | |  h                           +-+  |
|          |    |   | Lever   | |                                |  |
|   +--+   |    |   |         | |                                |  |
|   |  |   +----+   |         | |                                |  |
|   +--+   |    |   |         | |          +-----------------+   |  +---------------+
|          |    |   +---------+ |          |                 +---+  |               |
|          |    |   |           |          | Screw base      +---+  |  Lever        |
+----------+    +---+-----------+          +-----------------+   +--+---------------+
                      outcrop                                          - 22.75 -
        Top View                                          Side View

(made using http://asciiflow.com/)
*/

$fa=1;
$fs=1.5;

clip_height = 31.25;
clip_width = 21.75;
clip_thickness = 3.25;
clip_inset = 18;
lever_outcrop = 22.75;
lever_width = 39.75;
lever_height = 6.8;
screwbase_outcrop = 15.75;
screwbase_width = 49.25;
screwbase_height = 4.5;
connector_length = 4.75;
connector_width = 11;
connector_height = 2;
connector_inset = 15;
screw_hole_diameter = 5;
screw_hole_radius = screw_hole_diameter / 2;
large_screw_hole_depression = 1.4;
large_screw_hole_diameter = 9;
large_screw_hole_radius = large_screw_hole_diameter / 2;

second_clip_grabber_outcrop = 1.6;
second_clip_grabber_width = clip_width + 10.75;
second_clip_grabber_height = 10;
fudge = 0.1;



screwbase();

  translate([
    screwbase_outcrop,
    connector_inset,
    screwbase_height-connector_height
  ])
connector();

  clip_offset_x = screwbase_outcrop + connector_length;
  translate([clip_offset_x, 0, 0])
cliplever();

  translate([
    clip_offset_x - second_clip_grabber_outcrop,
    clip_inset,
    clip_height - 20.75
  ])
#second_clip_grabber();




module second_clip_grabber(){
  cube([
   second_clip_grabber_outcrop,
   second_clip_grabber_width,
   second_clip_grabber_height
  ]);
}


module screwbase() {
  difference(){
    /*cube([*/
      /*screwbase_outcrop,*/
      /*screwbase_width,*/
      /*screwbase_height,*/
    /*]);*/

    linear_extrude(height = screwbase_height)
      difference(){
        square([
            screwbase_outcrop,
            screwbase_width
        ]);

        far_groove_inset = 2.5;
        far_groove_width = 9;

        translate([screwbase_outcrop - far_groove_inset,
            screwbase_width - far_groove_width])
        square([
            far_groove_inset + fudge,
            far_groove_width + fudge
        ]);
      }


    screw_hole_center = screwbase_outcrop / 2;

    // "far" hole
    distance_from_far_end = 6.25;
    translate([
      screw_hole_center,
      screwbase_width - distance_from_far_end - screw_hole_radius,
      -1
    ])
      screw_hole();

    // "close" hole
    distance_from_close_end = 8.75;
    translate([
      screw_hole_center,
      distance_from_close_end + screw_hole_radius,
      -1
    ]){
      screw_hole();
      cylinder(r=large_screw_hole_radius,
        h=large_screw_hole_depression + 1);
    }
  }
}

module connector(){
  cube([
    connector_length,
    connector_width,
    connector_height
  ]);
}

module cliplever(){
  // vertical clip
  translate([0, clip_inset, 0]) {
    cube([
        clip_thickness,
        clip_width,
        clip_height
        ]);

    // clip endgrip
    grip_outcrop = 3;
    grip_width = 15.25;
    grip_height = 3.5;

      translate([
        0 - grip_outcrop,
        grip_width,
        clip_height-grip_height])
      rotate(a=90, v=[1,0,0])
    linear_extrude(height = grip_width)
    polygon(points=[
        [0,0],
        [grip_outcrop,0],
        [grip_outcrop, grip_height]
    ]);
  }

  // base lever
  difference(){
    cube([
      lever_outcrop,
      lever_width,
      lever_height
    ]);
    lever_depression();
  }


  // lever lip
  clip_lip_height = 9.5;
  cube([
    clip_thickness,
    lever_width,
    clip_lip_height
  ]);

}

module lever_depression(){
  // lever depression
  depression_inset = 7.25;
  depression_depth = 3.25;
  depression_x = lever_outcrop - depression_inset - clip_thickness;
  depression_width = lever_width - (2*depression_inset);

  echo("x ", depression_x);
  echo("width ", depression_width);

  color([0,0,1])
  translate([
    clip_thickness,
    depression_inset,
    lever_height - depression_depth
  ])
    cube([
      depression_x,
      depression_width,
      depression_depth + fudge
    ]);

}

module screw_hole(){
  cylinder(r=screw_hole_radius, h=screwbase_height * 2);
}
