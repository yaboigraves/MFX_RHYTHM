class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

@export var windowSize : float = 0.015625


#ok fist things first
#we gotta change how spawning markers works


#okie doke
#so markers probably need to be polygons
#reason being, the size of input windows needs to be toggleable

#so the idea is, depending on what lane we're in, we spawn a polygon that stretches based on the start and end of the window
#for now, lets assume a window is a 16/th of a beat

#hmmm so these need to get spawned relative to the current rotation

func _ready():
	super._ready()
	DrawInputWindows()
	
#use the input width to draw polys for the input windows
#markers are going to spawn on top of these


func DrawInputWindows():
	pass


func SpawnMarker(index,beatPosition: float):
	#so to start lets just like, draw a polygon at all
	var poly = Polygon2D.new()
	
	#OK
	#so...
	#first we gotta figure out where our anchor is
	#lets just draw a rectangle around that first
	var beatPos = fposmod(beatPosition,beatsPerRotation)/beatsPerRotation
	beatPos *= 2 * PI
	
	#so how much of 2PI is the window size?

	var windowSizeRadians = 2 * PI *( (beatsPerRotation * windowSize) / beatsPerRotation)

	
	var topBound = origin.rotated(rotation - beatPos-windowSizeRadians)
	var bottomBound = origin.rotated(rotation - beatPos+windowSizeRadians)

	
	var pivot = origin.rotated(rotation - beatPos) * (startDist + (laneSize/2.0) + (index * laneSize))
	

	var points : PackedVector2Array = [
		topBound * (startDist + (laneMargins/2.0) +  + (index * laneSize)) , 
		topBound * (startDist + (laneMargins/-2.0)+ (laneSize) + (index * laneSize)), 
		bottomBound * (startDist + (laneMargins/-2.0) + (laneSize) + (index * laneSize)), 
		bottomBound *(startDist + (laneMargins/2.0) + (index * laneSize)) 
	]
	
	
	poly.set_polygon(points)
	%Markers.add_child(poly)
	
	markers.append(poly)
	


func _on_metronome_tick(timeSeconds, timeBeats) -> void:
	%Markers.rotation =  origin.angle() + ((timeBeats * PI)/(beatsPerRotation/2.0))
	
	
#===DEBUG===
func _on_main_spawn_hit(index, timeInBeats) -> void:
	SpawnMarker(index,timeInBeats)

func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()
