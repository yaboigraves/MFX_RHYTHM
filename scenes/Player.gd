class_name Player
extends Node

@export var gameRules:GameModeRules
#cool so the player can act as the central hub for all player based stuff
#game state stuff can be handled a layer above, seems good

#so players can internally control their phase timings
#not game modes
signal BeatPhaseCallback(durationInBeats:float,callback:Callable)

var stateMachine : StateMachine

#so the state machine shouldn't get talked to by the metronome
#or should it hmm
#we might want a more formal process for that I think
#the player should maybe count that stuff out or something idk
#for now its not worth refactoring but we want sequences of input to be "Started" at a discrete point
#this is likely spawned by the game rules 
#so the game rules will basically say hey player 1: do an input sequence
#we can then start or end the sequence which then gets sent to the rules to handle what happens next
#lets just like use my foresight properly here and set up proper sequencing
#game rules I think ought to be a node that can effect game state
#each game rules can kinda create a different player structure

#so its a layer above the player below the game manager

func _ready():
	stateMachine = %PlayerStateMachine as StateMachine
	
func StartInputSequence():
	print("starting ", name, " input sequence")
	stateMachine.transition_to("RecordState")
	emit_signal("BeatPhaseCallback",stateMachine.state.duration,MoveToNextPhase)
	
#so honestly I think we want to just cut this short by the input window
#its small as fuck normally

func MoveToNextPhase():
	stateMachine.iterate_to_next_state()
	emit_signal("BeatPhaseCallback",stateMachine.state.duration,MoveToNextPhase)

func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,%Metronome.timeInBeats)
	stateMachine.state.HandleHit(hit)
	
