extends Node


#game ideas 
#1. free loop mode, just make and edit loops 
#2. one at a time (or X at a time mode)
	#players go back and forth adding x beats to the loop
	#whoever cant do it after adding a beat loses
#3. skate/horse mode (self explanitory original idea)

#cool so overall we just need to tie in from some gameplay rules
#lets make a resource for that that we can just load and plug into
#we can get stuff like input window size, num beats, etc
#gamemoderules


@export var display : RhythmDisplay

signal RecordedHit

signal SpawnHit(index,timeInBeats)


func _ready() -> void:
	%GameMode.Start()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
		
#so lets start by just assuming we want to spawn a 
func _on_player_input_handler_hit(index) -> void:
#	display.SpawnMarker(index,$Metronome.timeInBeats)
	#look at the metronome time for the hit
	
	#TODO: we need to factor in the audio latency here
	#add the latency to the time the beat is detected, we need to wait till it actually plays
	emit_signal("SpawnHit",index,$Metronome.timeInBeats)
	
