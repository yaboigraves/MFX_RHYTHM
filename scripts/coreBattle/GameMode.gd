class_name GameMode
extends RhythmGameStateNode

@export var player: Player
@export var rules : GameModeRules

#so all this is used for is to load in the actual game mode object, this is a chasis
#idk actually stew on this

func Start():
	pass


func MoveToNextPhase():
	pass
	
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