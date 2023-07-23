class_name AudioPlaybackTimeline
extends AudioStreamPlayer

signal DurationMet

var timingHead : float = 0.0
var bufferTime : float
var totalTime : float = 0.0
var totalTimeBeats : float = 0.0


var lastTime :float = 0.0
var timeInBeats: float
var bps :float
var spb: float
var duration:float

var currentBeat: int


func _init(stream : AudioStreamOggVorbis, duration = -1):
	super._init()
	set_process(false)
	
	self.stream = stream
	self.bps = stream.bpm/60.0
	self.spb = 60.0/stream.bpm
	self.duration = duration

func Start():
	set_process(true)
	play()

func _process(delta: float) -> void:
	bufferTime = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

	
	if(lastTime - bufferTime > 2.0):
		lastTime = bufferTime
		timingHead += stream.beat_count * spb
		
	if(bufferTime < lastTime or bufferTime > stream.get_length()): return

	lastTime = bufferTime
	timeInBeats = bufferTime * bps


	totalTime = timingHead + bufferTime

	totalTimeBeats = totalTime * bps

	if duration > 0 and totalTimeBeats >= duration:
		DurationMet.emit()
