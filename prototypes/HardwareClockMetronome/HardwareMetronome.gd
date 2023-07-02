extends Node

var lastTime :float = 0.0
var timeInBeats
var bps 
var currentBeat: int
var stream
var beats = 4
var duration

#so lets get an overall clock working now
var overallClock: float 
var rounds = 0

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
		rounds+=1		

	
	var time = $BackgroundTrack.get_playback_position() + AudioServer.get_time_since_last_mix()
	
	time -= AudioServer.get_output_latency()
	
	if(time < lastTime): return
	
	timeInBeats = time * bps

	overallClock = time + (rounds * duration)
	
	if floorf(timeInBeats + AudioServer.get_output_latency()) > currentBeat:
		currentBeat = timeInBeats
		$tick.play()
	


#so we want to make sure that all the tracks we're going to play are loaded
#but generally, this function emits a signal when a phase ends
#and then a new phase can be started

#lets start by making like a dumby state machine
