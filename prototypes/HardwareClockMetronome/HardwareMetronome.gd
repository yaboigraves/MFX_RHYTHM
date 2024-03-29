class_name HardwareClockMetronome
extends Node

signal CurrentTrackDone

static var instance:HardwareClockMetronome

var currentStateInstance : RhythmStateInstance


#this is for audio timing
var timingHead : float = 0.0

var totalTime : float = 0.0
var totalTimeBeats : float = 0.0

#old stuff I really want to refactor out a different way
var lastTime :float = 0.0

var bps :float
var duration:float


var currentBeat: int
var beats:int = 4

var audioPlayback : AudioPlaybackTimeline



#callback scheduling stuff
#so basically we use a pair of timings with functions
#callback

var callbacks_queue : Array[CallbackTimeMarker]




func _init() -> void:
	instance = self
	
func _ready():
	set_process(false)

func _process(delta):
	
	var called_callbacks: Array[CallbackTimeMarker]
	
	for callback in callbacks_queue:
		if callback.time <= GetCurrentPlaybackPositionBeats() + 1.0/60.0:
			callback.callback.call()
			called_callbacks.append(callback)
			
	for callback in called_callbacks:
		callbacks_queue.erase(callback)
		
	
func AddCallback(callable:Callable, time: float):
	callbacks_queue.append(CallbackTimeMarker.new(callable,time))

	

func PlayStream(stream:AudioStreamOggVorbis):
	if audioPlayback:
		remove_child(audioPlayback)
	
	audioPlayback = AudioPlaybackTimeline.new(stream)
	audioPlayback.DurationMet.connect(HandleCurrentPlaybackDurationMet)
	
	add_child(audioPlayback)
	audioPlayback.Start()
	set_process(true)
	print("STARTED A TRACK")
	

func HandleCurrentPlaybackDurationMet():
	audioPlayback.stop()
	CurrentTrackDone.emit()

func GetCurrentBufferPlaybackPositionBeats():
	return audioPlayback.timeInBeats

func GetCurrentPlaybackPositionBeats():
	return audioPlayback.totalTimeBeats

func GetCurrentTrackLoopDuration():
	return audioPlayback.stream.beat_count


