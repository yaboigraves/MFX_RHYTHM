class_name HardwareClockMetronome
extends Node

signal CurrentTrackDone

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


var audioPlayback : AudioPlaybackTimeline

func _init() -> void:
	instance = self
	
func _ready():
	set_process(false)

func PlayStream(stream:AudioStreamOggVorbis):
	if audioPlayback:
		remove_child(audioPlayback)
	

	
	audioPlayback = AudioPlaybackTimeline.new(stream,stream.beat_count * 3)
	audioPlayback.DurationMet.connect(HandleCurrentPlaybackDurationMet)
	
	add_child(audioPlayback)
	audioPlayback.Start()
	set_process(true)
	


	
	
func _process(delta: float) -> void:
	$Debug/TimeDebug/Time.text = str(audioPlayback.bufferTime)
	$Debug/TimeDebug/Beats.text = str(audioPlayback.timeInBeats)
	
	$Debug/TimeDebug/TotalTime.text = str(audioPlayback.totalTime)
	$Debug/TimeDebug/TotalBeats.text = str(audioPlayback.totalTimeBeats)


func HandleCurrentPlaybackDurationMet():
	audioPlayback.stop()
	CurrentTrackDone.emit()


func GetCurrentPlaybackPositionBeats():
	return audioPlayback.totalTimeBeats

func GetCurrentTrackLoopDuration():
	return audioPlayback.stream.beat_count
