class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay


@export var rules: GameModeRules

@export var markerColors: Array[Color]

@export var radialMetronomeDot : PackedScene


@onready var metronome:Metronome = get_node("/root/GameManager/Metronome") as Metronome

var metronomeDots = []

var markerHitMap: Dictionary

var stateTextMap = {
	"IdleState": "WAIT",
	"RecordState":"REC",
	"VerifyState":"PLAY"
}

#cool so this can now be used to create arc sections
#it needs to be obviously a little more kitted but yea i like it
#lets add a color field?
func CreateArcSection(index = 1, color = Color.DARK_GOLDENROD):
	var poly = OutlinedPolygon2D.new()
	poly.outlineWidth = 10
	poly.color = color
	poly.color.a = 0.5
	var windowSizeRadians = 2 * (PI) * (rules.windowSize/beatsPerRotation)

	var topBound = origin.rotated(-windowSizeRadians/2.0)
	var bottomBound = origin.rotated(windowSizeRadians/2.0)
	
	var closeMult =  (startDist + (laneMargins/2.0) +  + (index * laneSize))
	var farMult = (startDist + (laneMargins/-2.0)+ (laneSize) + (index * laneSize))

	var arcRadius = 22
	#so rotate by 5 multiples of that dif from 0 the actual max
	var arcSizeDelta = windowSizeRadians/(2.0 * arcRadius)
	
	var rotationMax = windowSizeRadians/2.0
	
	var arcPoints = []

	for i in range(arcRadius):
		arcPoints.append((origin.rotated(rotationMax - (i * arcSizeDelta))   ) * closeMult)
	arcPoints.append(origin * closeMult)
	for i in range(arcRadius + 1):
		arcPoints.append((origin.rotated( -(i * arcSizeDelta))   ) * closeMult)
	
	for i in range(arcRadius + 1, 0, -1):
			arcPoints.append((origin.rotated( -(i * arcSizeDelta))   ) * farMult)
	arcPoints.append(origin * farMult)
	for i in range(0,arcRadius + 1):
		arcPoints.append((origin.rotated( (i * arcSizeDelta))   ) * farMult)


	var points: PackedVector2Array = arcPoints	

	poly.set_polygon(points)
	
	return poly

func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()	
	DrawInputWindows()
	#DrawBadZone()
	DrawMetronomeDots()
	metronome.Tick.connect(_on_metronome_tick)
	#connect this shit dynamically
	
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
		var shape = CreateArcSection(index, markerColors[index])
		%InputWindows.add_child(shape)



func SpawnMarker(hit:Hit):
	var indexPos = (numLanes - 1) - hit.laneIndex
	var shape = CreateArcSection(indexPos, markerColors[indexPos])
	%Markers.add_child(shape)
	
	markers.append(shape)
	markerHitMap[hit] = shape

	
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

#
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
