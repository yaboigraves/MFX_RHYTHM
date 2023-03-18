extends Node

@export var display : RhythmDisplay

signal RecordedHit

signal SpawnHit(index,timeInBeats)


#be really dumb here just to prototype


#so lets start by just assuming we want to spawn a 
func _on_player_input_handler_hit(index) -> void:
#	display.SpawnMarker(index,$Metronome.timeInBeats)
	#look at the metronome time for the hit
	emit_signal("SpawnHit",index,$Metronome.timeInBeats)
	
