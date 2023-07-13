class_name RhythmState
extends State


@export var durationBeats : float = 4.0
@export var nextState : State

var startingTimeBeats : float
var endingTimeBeats : float


func enter(args := {}) -> void:
	super.enter()
	
	durationBeats = HardwareClockMetronome.instance.GetCurrentTrackLoopDuration()
	
	if args.has("startingTimeBeats"):
	
		startingTimeBeats = args.startingTimeBeats

	else:
		startingTimeBeats = 0
	
	endingTimeBeats = startingTimeBeats + durationBeats
	
	
	

	
	



func update(delta):
	super.update(delta)
	
	if HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() >= endingTimeBeats:


		state_machine.transition_to(nextState.name,{"startingTimeBeats": endingTimeBeats})
	


	

#so playing a stream should schedule at the next beat later too
#lets see if it desyncs, I think it probably will...


#func StartListenMode():
#	HardwareClockMetronome.instance.PlayStream(stream)

	
