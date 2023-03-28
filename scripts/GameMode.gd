class_name GameMode
extends Node


#so game mode should become an abstract class
#for now this will be for sketching and i can abstract it later
#all game modes need to start

#all game modes need to have win or end conditions

#all game modes are gonna have phases
#yada yada

#so start is going to initially create a looping player sequence

#so the question is how we use the metronome I guess

#the metronome needs to be stopped and started BY the game mode
#so yeah I guess we can emit from the game mode?
#the game mode can request a certain length of beats and then receive a callback

#basically we can say tell me something in 8 beats via a call back
#we can pass a closure pretty easily to say hey, switch the game mode after 8 beats



#so after x beats we do blank
@export var player: Player
@export var rules : GameModeRules


func Start():

	player.StartInputSequence()


func MoveToNextPhase():

	player.MoveToNextPhase()
	
func End():
	pass
	

#win/lose condition, could be as simple as a key being pressed
func CheckEndCondition():
	pass

#look at the report generated by the player and figure out what to do next
func HandlePlayerPhaseEnd():
	pass


func _on_metronome_beat_update(timeInBeats) -> void:
	pass # Replace with function body.
