class_name RhythmDisplay
extends Node

@export var marker: PackedScene

@export var offset : float = 100

func SpawnMarker(index: int, beat: float):
	var markerInst = marker.instantiate()
	#so the position should first be offset from the center by an amount
	$RecordIcon/Markers.add_child(markerInst)
	#so the beat should get remaindered first
	#so we map the beat on 8 beats to 2pi
	var beatPos = fposmod(beat,8.0)/8.0
	beatPos *= 2 *PI

	var pos :Vector2 = $RecordIcon/CenterAnchor.position + Vector2.LEFT.rotated(beatPos) * offset * (index + 1)
	markerInst.rotation = $RecordIcon/CenterAnchor.rotation

	markerInst.position = pos
	

	#test
