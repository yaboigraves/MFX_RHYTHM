class_name FreeMode
extends GameModeState

@onready var player : Player = %PlayerManager.GetPlayer(0) as Player


func enter(_msg := {}) -> void:
	#so whenever we get entered i guess we override that
	print(state_machine)
	super.enter()
	print("free mode starting")
	
	metronome.Start()
	#metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, EvaluateNextState, true)
	
	#honestly its not bad if the player states handle callbacks...
	#just know we probably need to encapsulate a players "turn"
	#i think thats what is missing
	#yeah lets handle player turns that way better
	
	#yeah so players can store their turns
	#and let us know when they done
	player.StartTurn()
	
	
	
#okkkkk lets go so we just constantly put the player into record
func EvaluateNextState():
	#metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, EvaluateNextState, true)
	print("this is where we would do game mode logic")

#player one has done their turn, what do we do now

func _on_player_1_turn_done() -> void:
	player.StartTurn()
