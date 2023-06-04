class_name OutlinedPolygon2D
extends Polygon2D

#so honestly it seems like just using a line2d around this might provide better results...
#these will look like shit 
#so yeah why don't we just use a line rendered?
#they seem to work better and support rounded caps
#we can extend this to also contain the top and bottom seperation?

var topIndexes : Array[int]
var bottomIndexes : Array[int]

@export var outlineColor :Color = Color(0,0,0)
@export var outlineWidth : float = 2.0 

func _ready():
	var poly = get_polygon()
	
	var outline = Line2D.new()
	outline.begin_cap_mode = Line2D.LINE_CAP_ROUND
	outline.end_cap_mode = Line2D.LINE_CAP_ROUND
	outline.width = outlineWidth
	outline.default_color = outlineColor
	
	for i in range(0 , poly.size()):
#		draw_line(poly[i-1] , poly[i], OutLine , Width,true)
		outline.add_point(poly[i])
	outline.add_point(poly[0])
	
	add_child(outline)


