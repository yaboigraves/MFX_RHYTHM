class_name InputWindowView
extends RefCounted

#arc sections are created by the radial display itself so we can just pass in the polygon
#the particle system can be passed in as well?
#the index will be important
#primary things are just like functions i suppose

#SO
#we cant tween this
#we have to create an animation player
#and keyframe the positions
#which is annoying but do able

var index: int
var shape: OutlinedPolygon2D
var particleSystem : CPUParticles2D

var animationPlayer : AnimationPlayer


func _init(index,shape,particleSystem:):
	self.index = index 
	self.shape = shape 
	self.particleSystem = particleSystem
	self.animationPlayer = AnimationPlayer.new()
	self.shape.add_child(self.animationPlayer)
	
	
	#try creating the animation
	var animation = Animation.new()
	animation.length = 1
	animationPlayer.speed_scale = 5
	
	animation.add_track(0)

	
	animation.track_set_path(0, NodePath(":polygon"))





	
	animation.track_insert_key(0,0,shape.polygon)

	
	
	var polygonMoved = shape.polygon.duplicate()
		
	for top in shape.topIndexes:
		polygonMoved[top] = polygonMoved[top].rotated(PI/48.0)
	for top in shape.bottomIndexes:
		polygonMoved[top] = polygonMoved[top].rotated(-PI/48.0)
	
	
	animation.track_insert_key(0,0.2,polygonMoved)	
	
	animation.track_insert_key(0,1,shape.polygon)

	
	var lib = AnimationLibrary.new()
	lib.add_animation("lol",animation)
	animationPlayer.add_animation_library("thing",lib)

	

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

var pulseTween

func PulseShapeTween():
	animationPlayer.stop()
	animationPlayer.play("thing/lol")
