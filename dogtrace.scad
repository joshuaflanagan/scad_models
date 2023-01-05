base_height=1.5;
detail_height=15;
outline_height=19;

shape_scale=0.65;
lift=0.0;


scale([shape_scale, shape_scale, 1]){
//outline
translate([0,0,lift])
linear_extrude(height = outline_height, center = false, convexity = 10)
import("dogtrace_outline4.svg", 10, dpi=96, center=false);

//detail
color("blue")
translate([38,69,lift])
linear_extrude(height = detail_height, center = false, convexity = 10)
import("dogtrace_detail4.svg", 10, dpi=96, center=false);

//butt
color("blue")
translate([34,116,lift])
linear_extrude(height=detail_height, center=false)
polygon([[2, 0],[0,4],[4,4]]);
}

color("gray")
translate([15, 45, 0]){
    
// shoulders
cube([102,15, base_height]);

//tail    
cube([12, 69, base_height]); 
    
//highleg
translate([37,0,0])
cube([6, 48, base_height]);
    
    
//head
translate([75,0,0])
cube([28,36, base_height]);
}