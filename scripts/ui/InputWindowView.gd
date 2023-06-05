class_name InputWindowView
extends RefCounted

#arc sections are created by the radial display itself so we can just pass in the polygon
#the particle system can be passed in as well?
#the index will be important
#primary things are just like functions i suppose

var index: int
var shape: Polygon2D
var particleSystem : CPUParticles2D


func _init(index,shape,particleSystem:):
	self.index = index 
	self.shape = shape 
	self.particleSystem = particleSystem
	

func HandleGoodHit():
	PulseShapeTween()
	
func HandleBadHit():
	pass
	
#so this is a little bit of a tricky problem
#basically we want to take the shape, and tween the points outwards
#i think it should be fine as long as the resolution is high enough?
#basically we want to take all the points that are on either side of the line and move them
#a certain amount along the arc
#this might actually need to be a shader tbh
#ok yeah this seems to just work actually?
#so we can hypothetically tween these
#it might not be that performant at high resolution though keep in mind

#hmmm i just need to probably re-evaluate what exactly these indexes are?
#ok this DOES work now
#keep in mind we gotta work on moving the outlines as well
#weirdly the corner isnt in there?
#so just top seem wrong

#ok so lets start with the rotation bit
#thats gonna take brain so come back to this

func PulseShapeTween():
	pass
	for point in shape.topIndexes:
		shape.polygon[point] -= Vector2(0,50)
#
	for point in shape.bottomIndexes:
		shape.polygon[point] += Vector2(0,50)
