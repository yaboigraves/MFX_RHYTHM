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
	

#so yeah this logic needs to be hoisted up a level
# I think we need to just like abstract out this timing shit to the game mode to start
#logic is really hyper specific there
#I think we ought to run a func in the manager to basically start the mode
#all modes have a start func
#lets go from there

#players ought to maybe own their uis too or something
func StartInputSequence():
	print("starting ", name, " input sequence")
	stateMachine.transition_to("IdleState")
	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)


func MoveToNextPhase():
	stateMachine.iterate_to_next_state()
	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)


func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,%Metronome.timeInBeats,stateMachine.state.startTime)
	print("hit has index", hit.laneIndex)
	stateMachine.state.HandleHit(hit)
	
