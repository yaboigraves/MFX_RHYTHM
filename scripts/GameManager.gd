extends Node

@export var display : RhythmDisplay

signal RecordedHit


#so lets start by just assuming we want to spawn a 
func _on_player_input_handler_hit(index) -> void:
	display.SpawnMarker(index,$Metronome.timeInBeats)
	#look at the metronome time for the hit
	
	
