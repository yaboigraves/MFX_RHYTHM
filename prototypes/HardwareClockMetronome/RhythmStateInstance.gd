class_name RhythmStateInstance
extends RefCounted

signal StateEnded

var startTime : float 
var duration : float 
var endTime : float 

var state : RhythmState

#so these can basically queue themselves to end with the metronome?
#we can hold hits in here too
#so the metronome basically needs to be passed this to stamp and say yep this starts here, im goin to start cooking it now

func _init(duration:float, state: RhythmState) -> void:
	self.duration = duration
	self.state = state

func SetTimeData(startTime : float):
	self.startTime = startTime
	self.endTime = startTime + duration

func CheckIfDone(currentTimeBeats : float) -> bool:
	if currentTimeBeats >= self.endTime:
		StateEnded.emit()
		return true
	return false
	
