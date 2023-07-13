class_name RhythmState
extends State

#so states have durations, and next states
#ok now lets address the offset issue with changing samples
#basically, since we technically start the next phase early sometimes
#so technically the duration is actually 4 for record into verify
#the first one is just kinda shorter

#ok so it seems to basically work
#so now, we can basically port the current behaviour over to this I think
#lets actually test like "ending" a sequence

#so lets say in a game mode we want to have one runthrough of one sample, then another runthrough of another
#a certain time in the playback timeline can be marked i think
#if we reach that, then we terminate the current state machine flow, and restart the sequence

#we can then also do like, did you win or lose process state stuff
#I want to give feedback like, moreso about accuracy after the fact so you can actually see it
#togeehter


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

	
