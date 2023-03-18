class_name RhythmDisplay
extends Node


#okie doke so lets just convert all this shit into a fresh new node
#this new radial display node can be re-used for a bunch of different ideas
#the idea is we have x number of lanes, markers placed at times etc

#we need to be able to store and access some form of basic board state
#thats more or less it
#there needs to be some form of predictive state support as well
#probably seperate those and do the predictive state later
#so the high level component can handle any and all requests
#sub units can handle markers and whatnot
#ok lets do dis

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
