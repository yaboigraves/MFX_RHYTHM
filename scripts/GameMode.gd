class_name GameMode
extends Node


#so game mode should become an abstract class
#for now this will be for sketching and i can abstract it later
#all game modes need to start

#all game modes need to have win or end conditions

#all game modes are gonna have phases
#yada yada



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
