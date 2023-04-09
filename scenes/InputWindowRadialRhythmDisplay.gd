class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

#couple of fixes required here
#mainly, we need to actually be able to change where stuff spawns from
#gotta flip the order of the lanes here, im very confident left to right is the way to go
#so the OUTER lane is actually index 0

#ok goals for today
#control over what control indexes map to what lane, ideally via a dictionary and not indexes
#buffer areas for input, so that you can do earlyish hits
#better UI feedback for hits

#lets fuckin GOOOOO

#something worth experimenting with is a testing profile object too
#so I can just plug in a drumset and a sample

#lets do those 3 things today

#k to start


@export var rules: GameModeRules

@export var windowSize : float = 0.015625

@export var markerColors: Array[Color]

@export var radialMetronomeDot : PackedScene

var metronomeDots = []

var markerHitMap: Dictionary

var stateTextMap = {
	"IdleState": "WAIT",
	"RecordState":"REC",
	"VerifyState":"PLAY"
}

#ok fist things first
#we gotta change how spawning markers works

func _ready():
	windowSize = rules.windowSize
	beatsPerRotation = rules.loopBeatSize
	super._ready()
	DrawInputWindows()
	DrawMetronomeDots()
	
	

func DrawMetronomeDots():
	for i in range(beatsPerRotation):
		var metronomeDot = radialMetronomeDot.instantiate()
		metronomeDot.position = origin.rotated((i *2*PI)/beatsPerRotation) * 100
		metronomeDot.position -= metronomeDot.size/2.0
		$Metronome.add_child(metronomeDot)
		metronomeDots.append(metronomeDot)
		
		
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
	poly.outlineWidth = 8
	#so lets just make a reversed bool
	
	#for now lets just do the math
	
	var indexPos = (numLanes - 1) - hit.laneIndex
	
	#so we want
	#0 -> 3
	#1 -> 2
	
	
	
	print(indexPos)
	

	var beatPos = fposmod(hit.time,beatsPerRotation)/beatsPerRotation
	beatPos *= 2 * PI

	var windowSizeRadians = 2 * PI *( (beatsPerRotation * windowSize) / beatsPerRotation)


	var topBound = origin.rotated( origin.angle() + rotation - beatPos-windowSizeRadians)
	var bottomBound = origin.rotated(origin.angle()  +rotation - beatPos+windowSizeRadians)

	var pivot = origin.rotated(origin.angle()  +rotation - beatPos) * (startDist + (laneSize/2.0) + ( ((numLanes - 1)- hit.laneIndex) * laneSize))

	var points : PackedVector2Array = [
		topBound * (startDist + (laneMargins/2.0) +  + (indexPos* laneSize)) , 
		topBound * (startDist + (laneMargins/-2.0)+ (laneSize) + (indexPos * laneSize)), 
		bottomBound * (startDist + (laneMargins/-2.0) + (laneSize) + (indexPos * laneSize)), 
		bottomBound *(startDist + (laneMargins/2.0) + (indexPos* laneSize)) 
	]
	
	poly.color = markerColors[indexPos]
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



	

func _on_verify_state_missed_hit(hit) -> void:
	
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1) -hit.laneIndex) * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"miss")

	markerHitMap[hit].modulate = Color(1,1,1,0.25)


var currentState
var phaseStart
func _on_player_state_machine_transitioned(state) -> void:
	currentState = state
	$HUD/PhaseText.text = stateTextMap[state.name]
	
#ehhh this is like a state thing....
func _on_metronome_beat_update(timeInBeats) -> void:
	UpdateMetronome(timeInBeats)
	
#this needs a little work
#doesnt work with the variant idle phase length

func UpdateMetronome(timeInBeats):
	
#	var metronomeIndex = fposmod(int(timeInBeats),currentStateDuration)/currentStateDuration

	var metronomeIndex = currentState.progress/currentState.duration
#	print(rules.loopBeatSize * metronomeIndex)
	
	for dot in metronomeDots:
		dot.modulate = Color(1,1,1,0.2)

	for i in range((rules.loopBeatSize * metronomeIndex)):
		metronomeDots[i].modulate = Color(1,1,1,1)



func _on_verify_state_bad_hit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + ((numLanes - 1) -hit.laneIndex * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"oops")


func _on_verify_state_good_hit(hit) -> void:

	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"nice")

	markers.erase(markerHitMap[hit])
	markerHitMap[hit].queue_free()
