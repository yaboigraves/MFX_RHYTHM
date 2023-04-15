class_name Player
extends Node

@export var gameRules:GameModeRules
#cool so the player can act as the central hub for all player based stuff
#game state stuff can be handled a layer above, seems good

#so players can internally control their phase timings
#not game modes
signal BeatPhaseCallback(durationInBeats:float,callback:Callable)

var stateMachine : StateMachine


func _ready():
	stateMachine = %PlayerStateMachine as StateMachine


func StartInputSequence():
	print("starting ", name, " input sequence")
	stateMachine.transition_to("RecordState")
	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)


func MoveToNextPhase():
	stateMachine.iterate_to_next_state()
	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)


func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,%Metronome.timeInBeats,stateMachine.state.startTime)
	print("hit has index", hit.laneIndex)
	stateMachine.state.HandleHit(hit)
	
