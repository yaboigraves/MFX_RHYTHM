class_name RadialRhythmDisplay
extends Control

#TODO: line render to create lanes dynamically
#TODO: better control for marker placement 
#TODO: specify valid arc area better than current setup


@export var marker : PackedScene
@export var numLanes : int = 3
@export_range(0,0.5) var centerOffset: float = 0
@export var rhythmArmVisible: bool = true
@export var backgroundSpins: bool = false
@export var laneSpacing = 20

@export var beatsPerRotation:int = 8

@onready var laneSize : float = (size.x/2.0 - (size.x *centerOffset))/numLanes

@export var startingPosition : Vector2 = Vector2.LEFT

var markers = []

func _ready() -> void:
	%Arm.visible = rhythmArmVisible
	CreateBeatGridLines()
	
func _on_metronome_tick(timeSeconds, timeBeats) -> void:
	%Arm.rotation =  ((timeBeats * PI)/(beatsPerRotation/2.0))

func CreateBeatGridLines():
	for i in range(beatsPerRotation):
		var line = Line2D.new()
		line.width = 2
		line.add_point(Vector2())
		line.add_point( Vector2(size.x/2.0,0).rotated( i * (PI/(beatsPerRotation/2.0))))
		%LineRenderers.add_child(line)

	
#TODO: move to a seperate marker spawner thing, or not idk
func SpawnMarker(index,beatPosition: float):
		var markerInst = marker.instantiate()
		%CenterPivot/Markers.add_child(markerInst)
		var beatPos = fposmod(beatPosition,beatsPerRotation)/beatsPerRotation
		beatPos *= 2 * PI
		markerInst.position = startingPosition.rotated(beatPos) * ((size.x *centerOffset) + (laneSize * (index))) 
#		markerInst.rotation = %Arm.rotation
#		markerInst.get_node("Marker").size = Vector2(80 ,80)
	
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
	
func _on_main_spawn_hit(index, timeInBeats) -> void:
	SpawnMarker(index,timeInBeats)


func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()
