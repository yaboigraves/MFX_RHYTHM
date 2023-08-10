class_name RhythmState
extends State

signal TimeFinished

@export var durationBeats : float = 4.0
@export var nextState : State

var startingTimeBeats : float
var endingTimeBeats : float


func enter(args := {}) -> void:
	super.enter()
	
	durationBeats = HardwareClockMetronome.instance.GetCurrentTrackLoopDuration()
	
	if(state_machine.lastState):
		startingTimeBeats = state_machine.lastState.endingTimeBeats
	else:
		startingTimeBeats = 0
	
	endingTimeBeats = startingTimeBeats + durationBeats
	

func update(delta):
	super.update(delta)
	
	if HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() >= endingTimeBeats:
		OnTimeFinished()

func ResolveNextState():
	pass

#when the states time is finished, resolve the next state
func OnTimeFinished():
	TimeFinished.emit()
	
	ResolveNextState()
	
	if nextState:
		state_machine.transition_to(nextState.name)
		
		

	
