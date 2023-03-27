class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

@export var rules: GameModeRules

@export var windowSize : float = 0.015625

@export var markerColors: Array[Color]

var markerHitMap: Dictionary

#ok fist things first
#we gotta change how spawning markers works



func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()
	DrawInputWindows()
	
	
	

func DrawInputWindows():
	var windowSizeRadians = 2 * PI *( (beatsPerRotation * windowSize) / beatsPerRotation)
	for index in range(numLanes):
		var poly = OutlinedPolygon2D.new()
		poly.outlineWidth = 10
		poly.color =  markerColors[index]
		poly.color.a = 0.5
		var topBound = origin.rotated(-windowSizeRadians)
		var bottomBound = origin.rotated(windowSizeRadians)
		
		var points : PackedVector2Array = [
			topBound * (startDist + (laneMargins/2.0) +  + (index * laneSize)) , 
			topBound * (startDist + (laneMargins/-2.0)+ (laneSize) + (index * laneSize)), 
			bottomBound * (startDist + (laneMargins/-2.0) + (laneSize) + (index * laneSize)), 
			bottomBound *(startDist + (laneMargins/2.0) + (index * laneSize)) 
		]
		
		
		poly.set_polygon(points)
		
		%InputWindows.add_child(poly)

func SpawnMarker(hit:Hit):

	var poly = OutlinedPolygon2D.new()
	poly.outlineWidth = 0

	var beatPos = fposmod(hit.time,beatsPerRotation)/beatsPerRotation
	beatPos *= 2 * PI

	var windowSizeRadians = 2 * PI *( (beatsPerRotation * windowSize) / beatsPerRotation)

	var topBound = origin.rotated(rotation - beatPos-windowSizeRadians)
	var bottomBound = origin.rotated(rotation - beatPos+windowSizeRadians)

	var pivot = origin.rotated(rotation - beatPos) * (startDist + (laneSize/2.0) + (hit.laneIndex * laneSize))

	var points : PackedVector2Array = [
		topBound * (startDist + (laneMargins/2.0) +  + (hit.laneIndex * laneSize)) , 
		topBound * (startDist + (laneMargins/-2.0)+ (laneSize) + (hit.laneIndex * laneSize)), 
		bottomBound * (startDist + (laneMargins/-2.0) + (laneSize) + (hit.laneIndex * laneSize)), 
		bottomBound *(startDist + (laneMargins/2.0) + (hit.laneIndex * laneSize)) 
	]
	
	poly.color = markerColors[hit.laneIndex]
	poly.set_polygon(points)
	%Markers.add_child(poly)
	
	markers.append(poly)
	markerHitMap[hit] = poly
	


func _on_metronome_tick(timeSeconds, timeBeats) -> void:
	%Markers.rotation =  origin.angle() + ((timeBeats * PI)/(beatsPerRotation/2.0))
	
	
func ClearAllMarkers():
	super.ClearAllMarkers()
	markerHitMap.clear()
	
#===DEBUG===

func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()


func _on_record_state_spawn_marker(hit:Hit) -> void:
	SpawnMarker(hit)


func _on_verify_state_destroy_hit(hit) -> void:
	markers.erase(markerHitMap[hit])
	markerHitMap[hit].queue_free()
	
