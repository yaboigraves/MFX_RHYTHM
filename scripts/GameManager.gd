extends Node


#so lets build the main gameplay loop
#we need a game manager state machine!

#each player can have a state machine
# record - verify - idle

#we sust switch each stat

#game ideas 
#1. free loop mode, just make and edit loops 
#2. one at a time (or X at a time mode)
	#players go back and forth adding x beats to the loop
	#whoever cant do it after adding a beat loses
#3. skate/horse mode (self explanitory original idea)

#hits should be abstract enough to handle all of these
#as should the phase system



@export var display : RhythmDisplay

signal RecordedHit

signal SpawnHit(index,timeInBeats)


#be really dumb here just to prototype


#so lets start by just assuming we want to spawn a 
func _on_player_input_handler_hit(index) -> void:
#	display.SpawnMarker(index,$Metronome.timeInBeats)
	#look at the metronome time for the hit
	
	#TODO: we need to factor in the audio latency here
	#add the latency to the time the beat is detected, we need to wait till it actually plays
	emit_signal("SpawnHit",index,$Metronome.timeInBeats)
	
