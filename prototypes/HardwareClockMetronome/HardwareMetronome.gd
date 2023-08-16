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

func _init() -> void:
	instance = self
	
func _ready():
	set_process(false)

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


