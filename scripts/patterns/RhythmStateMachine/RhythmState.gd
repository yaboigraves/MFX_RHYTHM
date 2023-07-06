class_name RhythmState
extends State

@export var durationInBeats : float = 4.0
@export var stream : AudioStreamOggVorbis
var current : RhythmStateInstance



#this later becomes part of specific states


func enter(_msg := {}) -> void:
	super.enter()
	current = RhythmStateInstance.new(durationInBeats, self)
	#register this in the metronome so we know when to stop
	
	#set the audio and start it playing
	StartListenMode()
	await AsyncTest()
	

#wow this is really cool, so when the state is over we basically can in here decide what we transition to next
#thats fucking powerful as fuck



func AsyncTest():
	await current.StateEnded
	print("we donezo")
	

func StartListenMode():
	HardwareClockMetronome.instance.PlayStream(stream)
	HardwareClockMetronome.instance.SetCurrentStateInstance(current)
	
