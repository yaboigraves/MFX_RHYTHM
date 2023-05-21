class_name Player
extends RhythmGameStateNode



#this needs ALOT of stuff removed

@export var gameRules:GameModeRules
#cool so the player can act as the central hub for all player based stuff
#game state stuff can be handled a layer above, seems good

#so players can internally control their phase timings
#not game modes
signal BeatPhaseCallback(durationInBeats:float,callback:Callable)
signal SpawnMarker(hit:Hit)
signal TurnDone



var stateMachine : StateMachine


func _ready():
	super._ready()
	stateMachine = %PlayerStateMachine as StateMachine
	


#so states need to end now..
#lets get a basic loop going 
#once the record state ends we want to be notified
func StartTurn():
	stateMachine.transition_to("RecordState")
	
	#i guess rhythm game nodes ought to be able to access the ui too?
	#yeah lift the state up for stuff like calling markers
	


#func StartInputSequence():
#	print("starting ", name, " input sequence")
#	stateMachine.transition_to("IdleState")
#	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)
#

#func MoveToNextPhase():
#	stateMachine.iterate_to_next_state()
#	emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)

#once again metronome caching issues
#lets just cache these all with metronome refs, or build it into a rhythm game base node component
#probably just bake it in as a base node function
#for game state info

#this is good still

#ok we have a game loop again
#good start
#it needs to be easier to actually script from lab mode
#but its pretty decent so far
#i think record state just going into verify makes sense
#good for now
#i guess I can come back to this later!
#overall next steps are cleaning up, tying the ui in more succintly
#then pause

#we really do need liek a game state version of the players round
#if we can just pass that to the UI at the start of every round and bind to it
#thats probably way smarter
#that way states can still control it and UI and whoever else can just listen

func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,metronome.timeInBeats,stateMachine.state.startTime)
	#print("hit has index", hit.laneIndex)
	stateMachine.state.HandleHit(hit)
	
