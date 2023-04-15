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

#so the main main todos here are to handle the weirdness that can handle by doing slightly early inputs
#i think technically, we ought to allow input in the idle state right near the end as a beggining of an input
#same with the end of the record state, if you do an input and its like super close to a target hit, we should just kind of switch the mode pre-emptively
#so technically there's like a buffer area thats the size of the window input BEFORE the phase starts technically

#we dont want to trigger anything neccessarily, just buffer I guess
#we could also technically start the mode early, but that seems bad to me
#better to just open the window ON hit being received rather than doing it in state
#the window might be small or not needed

#so to start lets make it so that hits at the very end of the idle state can be buffered, or at least can count towards a record state

#ok so some rough ideas are sketched out but I REALLY need a way to inject test code in
#so lets do this, lets be smart and make an input spoofer that will just spawn hits

#4/9
#there appears to be a good deal of refuse accumulated in this codebase 
#phases look decent
#I think what really ought to be done today is proper testing of input windows
#so lets do that
#create a test case that has a miss in it first

#ok overall this buffer system fuckin sucks
#honestly, input starts at the 0, but ends when the new input window starts
#you're never going to want to do a fresh input at the start of a record phase
#it's just not a thing you do in this game
#so lets just switch phases earlier, and deal with the fallout
#completly cut this bs buffer system out


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
	
