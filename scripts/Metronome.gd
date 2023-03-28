class_name Metronome
extends Node

#ok we're going to make room for a discrete timed update
#this will be used to queue shit irregardless of frame stuff?
#basically we can schedule functions to run now
#this will actually be etremly useful for the queue
#the queue can handle actually dispatching these buffers
#the metronome just says when to process

#this should clean up alot of awkwardness with the queue


signal Tick(timeSeconds, timeBeats)
signal SyncUpdate(timeInBeats,delta)
signal BeatUpdate(timeInBeats)

signal PhaseSwitch

@export var stream : AudioStreamOggVorbis
@export var syncUpdateRate = 1.0
@export var phaseSwitchRate = 8.0


var time_begin
var time_delay

var bpm
var bps
var nextSyncUpdate = 0.0
var nextBeatUpdate = 0.0
var nextPhaseUpdate = 7.0
var time
var timeInBeats = 0

#TODO: this only supports one callback per beat, must be an array
var callbacks = {}


func _ready() -> void:
	set_process(false)
	$AudipPlayer.stream = stream
	Start()
	
func Start():
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	bpm = stream.bpm
	bps = bpm/60
	$AudipPlayer.play()
	set_process(true)

	
func _process(delta):
	calculateTime()

func calculateTime():
	# Obtain from ticks.
	time = (Time.get_ticks_usec() - time_begin) / 1000000.0
	# Compensate for latency.
	time -= time_delay
	# May be below 0 (did not begin yet).
	time = max(0, time)
	timeInBeats = time * bps
	#so what we really want is this time converted into beats
	emit_signal("Tick",time,timeInBeats)
	
	if timeInBeats >= nextBeatUpdate:
		nextBeatUpdate = snapped(timeInBeats + 1, syncUpdateRate)
#		emit_signal("BeatUpdate",timeInBeats)
		call_deferred("emit_signal","BeatUpdate",timeInBeats)

	#sync update part
	if timeInBeats >= nextSyncUpdate:
		nextSyncUpdate = snapped(timeInBeats,syncUpdateRate) + syncUpdateRate
		emit_signal("SyncUpdate",snapped(timeInBeats,syncUpdateRate),syncUpdateRate)
#		print(timeInBeats)
		ProcessCallbacks()
		

		#this is probably legacy
#		if is_zero_approx( fposmod(snapped(timeInBeats,syncUpdateRate),8)):
#			emit_signal("PhaseSwitch")


func ProcessCallbacks():
	if callbacks.has(snapped(timeInBeats,syncUpdateRate)):
		callbacks[snapped(timeInBeats,syncUpdateRate)].call()
		callbacks.erase(snapped(timeInBeats,syncUpdateRate))


func GetTimeInBeatsWithLatency():
	pass


func _on_player_beat_phase_callback(durationInBeats, callback) -> void:
	var callbackTime = snapped(timeInBeats,syncUpdateRate) + durationInBeats
	callbacks[callbackTime] = callback
	
	
