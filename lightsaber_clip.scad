fudge = 0.01;

color([1,0,0]) clip();
color([0,1,0]) grip();

module clip(){
// Cmd-8 for side-view
height=60;
width=20;
gap=8;
thickness=4;
top_thickness = thickness + 4;
    
    translate([-thickness, width/2, 0])
    rotate(a=90, v=[1, 0, 0])
    linear_extrude(height=width){
        // joint side
        square([thickness, height]);

        // joint side bottom nub
        translate([thickness/2, height])
        circle(r=thickness/2, $fn=16);

            
        // body side
        body_side_height = height - top_thickness;
        rotate(2)
        translate([thickness + gap, 0]){
            translate([0, top_thickness])
            #square([thickness, body_side_height]);

            //body side bottom nub
            translate([thickness/2, height])
            circle(r=thickness/2, $fn=16);
        }


        top_curve_r = gap / 2 + fudge;
        // "top" bridge
        difference(){
            color([0,1,0])
            square([thickness + gap + thickness, top_thickness + top_curve_r]);
            
            color([1,0,0])
            translate([thickness + top_curve_r, top_thickness + top_curve_r])
            circle(r=top_curve_r);      
        }
        
    }
}

module grip(){
// Cmd-4 for top-view
height=20;
thickness=6;
gap=38;
item_diameter=42;
item_r = item_diameter / 2;
outer_r = item_r + thickness;
    


translate([-outer_r,0])
linear_extrude(height=height){
    
    difference(){
        //outer
        circle(r=outer_r);
        //inner (hole)
        circle(r=item_r);

        //gap
        translate([-item_r,0])
        #square([item_diameter, gap], center=true);

    }
}

}