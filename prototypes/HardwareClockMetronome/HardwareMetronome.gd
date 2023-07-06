class_name HardwareClockMetronome
extends Node

#lets clean this up a bit and prepare it for actual use
#so the tricky bit here is maintaining a consistent internal clock
#for this game, every game is on a consistent internal clock

static var instance:HardwareClockMetronome

var currentStateInstance : RhythmStateInstance

#new state based variables that are core

#this is when the next state ought to start after this one
#STATE
var nextStateTime : float = 0.0

#this is for audio timing
var timingHead : float = 0.0

var totalTime : float = 0.0
var totalTimeBeats : float = 0.0

#old stuff I really want to refactor out a different way
var lastTime :float = 0.0
var timeInBeats: float
var bps :float
var duration:float


var currentBeat: int
var beats:int = 4

var stream:AudioStreamOggVorbis



func _init() -> void:
	instance = self
	
	



func _ready():
	stream = $BackgroundTrack.stream as AudioStreamOggVorbis
	bps = stream.bpm/60.0
	duration = beats * bps
	set_process(false)


func PlayStream(stream:AudioStreamOggVorbis):
	if $BackgroundTrack.playing:
		$BackgroundTrack.stop()
	
	$BackgroundTrack.stream = stream
	$BackgroundTrack.play()
	
	set_process(true)
	
	


func SetCurrentStateInstance(stateInstance : RhythmStateInstance):
	currentStateInstance = stateInstance
	currentStateInstance.SetTimeData(timingHead)

	
	#soooo now that the instance is loaded, we now want to basically wait till its time is up based on the core timer
	#lets start the actual core timer now I suppose
	#so background audio isn't connected to actual gameplay states keep in mind, but it should always be ticking
	
	#lets create a debug dispaly for time really quick
	
	
	#so some states may actually contain an audio thing we start, like listen states.... but that can happen later I think
	#ok so the state instance is set, we're basically good to start playing audio assuming we have a duration for the state
	#we dont right now though so lets add that
	







#ok so now how do we handle stopping early, 
#well, we use the head

func _process(delta):
	var bufferTime = $BackgroundTrack.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

	#loop
	if( lastTime - bufferTime > 1.0):
		lastTime = bufferTime
		timingHead += $BackgroundTrack.stream.get_length()
	
	#check for inaccuracy and discard
	if(bufferTime < lastTime): return
	
	
	lastTime = bufferTime
	timeInBeats = bufferTime * bps
	
	$Debug/TimeDebug/Time.text = str(bufferTime)
	$Debug/TimeDebug/Beats.text = str(timeInBeats)

	totalTime = timingHead + bufferTime
	totalTimeBeats = totalTime * bps
	
	$Debug/TimeDebug/TotalTime.text = str(totalTime)
	$Debug/TimeDebug/TotalBeats.text = str(totalTimeBeats)
	

	#check if we're done with the current state
	
	if currentStateInstance.CheckIfDone(totalTimeBeats):
		$BackgroundTrack.stop()
		set_process(false)
		






