class_name RadialRhythmDisplay
extends Control

#so this is a base protoype that can be extended to whatever is needed
#lets make another one for a rhythm demo specifically now


@export var origin : Vector2 = Vector2.RIGHT

@export var marker : PackedScene
@export var numLanes : int = 3

@export_range(0,1) var centerOffset: float = 0.1
@export_range(0,1) var outerOffset: float = 0.8

@export var rhythmArmVisible: bool = true

@export var laneMargins = 20
@export var beatDivisonColors: Color = Color.ANTIQUE_WHITE
@export var beatsPerRotation:int = 8

@export var laneLineResolution = 45

@export var laneColors: Array[Color]
@export var backgroundColor : Color

var totalLanesSize:float
var laneSize : float 
var markers = []

var startDist : float 
var endDist : float

func _ready() -> void:
	%Arm.visible = rhythmArmVisible

	var radius = size.x/2.0
	startDist = radius * centerOffset
	endDist = radius * outerOffset
	
	totalLanesSize = endDist - startDist
	laneSize = totalLanesSize/numLanes
	
	CreateLaneLinesBackground()
	CreateLaneLines()
	CreateBeatGridLines()


func _on_metronome_tick(timeSeconds, timeBeats) -> void:
	%Arm.rotation =  origin.angle() + ((timeBeats * PI)/(beatsPerRotation/2.0))


func CreateBeatGridLines():
	for i in range(beatsPerRotation):
		var line = Line2D.new()
		line.width = 2
		line.add_point(Vector2())
		line.add_point( Vector2(size.x/2.0,0).rotated( i * (PI/(beatsPerRotation/2.0))))
		line.default_color = Color.BLACK
		%LineRenderers.add_child(line)
		
		
func CreateLaneLinesBackground():
	var laneLine = Line2D.new()
	laneLine.width = totalLanesSize
	laneLine.begin_cap_mode = Line2D.LINE_CAP_ROUND
	laneLine.end_cap_mode = Line2D.LINE_CAP_ROUND
	laneLine.default_color = backgroundColor
	
	for i in range(laneLineResolution):
		laneLine.add_point( Vector2(startDist + (totalLanesSize/2.0),0).rotated(i * ((2 * PI)/ laneLineResolution)))
	
	laneLine.add_point( Vector2(startDist + (totalLanesSize/2.0),0).rotated(0 * ((2 * PI)/ laneLineResolution)))
	%LineRenderers.add_child(laneLine)


func CreateLaneLines():
	for j in range(0,numLanes):
		var laneLine = Line2D.new()
		laneLine.width = laneSize - laneMargins
	
		laneLine.default_color = laneColors[j]
		
		for i in range(laneLineResolution):
			laneLine.add_point(Vector2(startDist + (laneSize/2.0) + (j * laneSize),0).rotated(i * (2*PI)/ laneLineResolution))
		laneLine.add_point(Vector2(startDist + (laneSize/2.0) + (j * laneSize),0).rotated(0 * (2*PI)/ laneLineResolution))
		
		%LineRenderers.add_child(laneLine)


func SpawnMarker(hit:Hit):
		var markerInst = marker.instantiate()
		%CenterPivot/Markers.add_child(markerInst)
		var beatPos = fposmod(hit.beatPosition,beatsPerRotation)/beatsPerRotation
		beatPos *= 2 * PI
		markerInst.position = (origin * (startDist + (laneSize/2.0) + (hit.laneIndex * laneSize))).rotated(beatPos)
		markers.append(markerInst)
		return markerInst

func ClearMarker(markerInst):
	var marker = markers.find(markerInst)
	if marker:
		marker.queue_free()
		markers.erase(marker)

func ClearAllMarkers():
	for marker in markers:
		marker.queue_free()
	markers.clear()
	


func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()
