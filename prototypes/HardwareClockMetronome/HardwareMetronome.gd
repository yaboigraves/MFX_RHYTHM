extends Node

var lastTime :float = 0.0
var timeInBeats
var bps 
var currentBeat: int


var stream

var beats = 4
var duration

func _ready():
	stream = $BackgroundTrack.stream as AudioStreamOggVorbis
	bps = stream.bpm/60.0
	duration = beats * bps
	$BackgroundTrack.play()
	print(duration)
	stream.loop = false



func _process(delta):
	if not $BackgroundTrack.playing:
		$BackgroundTrack.play()
		currentBeat = 0
	
	var time = $BackgroundTrack.get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.

	time -= AudioServer.get_output_latency()
	

	
	if(time < lastTime): return
	
	#print(time)
	
	timeInBeats = time * bps
	if floorf(timeInBeats + AudioServer.get_output_latency()) > currentBeat:
		currentBeat = timeInBeats
		#print(currentBeat)
		$tick2.play()
	

	
