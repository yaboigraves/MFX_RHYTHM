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

@export var markerColors: Array[Color]

@export var radialMetronomeDot : PackedScene



var metronomeDots = []

var markerHitMap: Dictionary

var stateTextMap = {
	"IdleState": "WAIT",
	"RecordState":"REC",
	"VerifyState":"PLAY"
}


func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()
	
	DrawInputWindows()
	#DrawBadZone()
	DrawMetronomeDots()
	
func DrawMetronomeDots():
	for i in range(beatsPerRotation):
		var metronomeDot = radialMetronomeDot.instantiate()
		metronomeDot.position = origin.rotated((i *2*PI)/beatsPerRotation) * 100
		metronomeDot.position -= metronomeDot.size/2.0
		$Metronome.add_child(metronomeDot)
		metronomeDots.append(metronomeDot)
		

func DrawBadZone():
	var windowSizeRadians = 2 * (PI) * (rules.badZoneSize/beatsPerRotation)
	var line = Line2D.new()
	var edge = Vector2(-500,0)
	edge = edge.rotated(-windowSizeRadians)
	line.points = [Vector2(0,0), edge]	
	%CenterPivot/LineRenderers.add_child(line)

func DrawInputWindows():
	var windowSizeRadians = 2 * (PI) * (rules.windowSize/beatsPerRotation)
	for index in range(numLanes):
		var poly = OutlinedPolygon2D.new()
		poly.outlineWidth = 10
		poly.color =  markerColors[index]
		poly.color.a = 0.5
		
		var topBound = origin.rotated(-windowSizeRadians/2.0)
		var bottomBound = origin.rotated(windowSizeRadians/2.0)
		

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

	var indexPos = (numLanes - 1) - hit.laneIndex

	var beatPos = fposmod(hit.time,beatsPerRotation)/beatsPerRotation
	beatPos = PI
#	beatPos *= 2 * PI

	#var windowSizeRadians = 2 * PI *( (beatsPerRotation * rules.windowSize) / beatsPerRotation)
	var windowSizeRadians = (2 * (PI) * (rules.windowSize/beatsPerRotation)) / 2.0

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
#	%Markers.rotation =  origin.angle() + ((timeBeats * PI)/(beatsPerRotation/2.0))
	for hit in markerHitMap.keys():
		markerHitMap[hit].rotation = ((timeBeats - hit.time )/ beatsPerRotation) * 2 * PI

		
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
	markerHitMap[hit].queue_free()
	markerHitMap[hit].modulate = Color(1,1,1,0.25)
	markerHitMap.erase(hit)


var currentState
var phaseStart
func _on_player_state_machine_transitioned(state) -> void:
	currentState = state
	$HUD/PhaseText.text = stateTextMap[state.name]
	
#ehhh this is like a state thing....
func _on_metronome_beat_update(timeInBeats) -> void:
	UpdateMetronome(timeInBeats)
	

func UpdateMetronome(timeInBeats):
	var metronomeIndex = currentState.progress/currentState.duration
	
	for dot in metronomeDots:
		dot.modulate = Color(1,1,1,0.2)

	for i in range((rules.loopBeatSize * metronomeIndex)):
		metronomeDots[i].modulate = Color(1,1,1,1)



func onBadHit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"oops")
	

func onGoodHit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"nice")
	markerHitMap[hit].queue_free()
	markers.erase(markerHitMap[hit])
	markerHitMap.erase(hit)

func onDestroyMiss(hit):
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"miss")
	markerHitMap[hit].queue_free()
	markers.erase(markerHitMap[hit])
	markerHitMap.erase(hit)


func _on_verify_state_hit_processed(hit, hitResult) -> void:
	match hitResult:
		HitResult.GOOD:
			onGoodHit(hit)
		HitResult.MISS:		
			onBadHit(hit)
		HitResult.DESTROY_MISS:
			onDestroyMiss(hit)
