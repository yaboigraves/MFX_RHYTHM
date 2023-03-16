class_name RhythmDisplay
extends Node

@export var marker: PackedScene

@export var offset : float = 80
var record = false


var hitRegistry = [[],[],[],[]]


func SpawnMarker(index: int, beat: float):
	
	if record:
	
		
		var markerInst = marker.instantiate()
		#so the position should first be offset from the center by an amount
	#	$RecordIcon/CenterAnchor/Markers.add_child(markerInst)
		$RecordIcon/CenterAnchor/Markers.add_child(markerInst)
		#so the beat should get remaindered first
		#so we map the beat on 8 beats to 2pi
		var beatPos = fposmod(beat,8.0)/8.0
		beatPos *= 2 *PI

		var pos :Vector2 = $RecordIcon/CenterAnchor.position + Vector2.LEFT.rotated(-beatPos)* offset * (3 -index + 1)
		markerInst.rotation = -$RecordIcon/CenterAnchor.rotation

		markerInst.position = pos
		
		hitRegistry[index].append(beat + 8.0)
	else:
		if(hitRegistry[index].size() > 0):
			print(hitRegistry[index][0])
			if( abs( beat -hitRegistry[index][0]) < 0.5 ):
				print("good")
				hitRegistry[index].pop_front()
				

	#test


func _on_metronome_phase_switch() -> void:
	if not record: 
		for lane in hitRegistry:
			lane.clear()
	
	record = not record
	print(record)
