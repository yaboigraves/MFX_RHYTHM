class_name Metronome
extends Node

#ok we're going to make room for a discrete timed update
#this will be used to queue shit irregardless of frame stuff?
#basically we can schedule functions to run now
#this will actually be etremly useful for the queue
#the queue can handle actually dispatching these buffers
#the metronome just says when to process

#this should clean up alot of awkwardness with the queue

#TODO: rewrite the callbacks system to suport an update based approach
#sync update is great but doesnt work for the fact that technically states change not on beat
#we just want to fake that they open and close like that
#so basically, input states change literally the second you can possibly make a valid input
#buffer stuff is cringe, unneccessary
#should be alot cleaner after this too, we ought to do a big cleanup after this
#once phases are good and we get some thorough testing in, I feel good about moving to some UI polish
#after the basic UI polish is done, we can go to adding vs mode
#at that point I feel comfortable releasing this as a little private demo and then hard pivoting to the other project


#ahhh
#ok
#so technically
#even though we start the thing early
#the rhythm seems to desync now
#duh
#well
#hm


signal Tick(timeSeconds, timeBeats)
signal SyncUpdate(timeInBeats,delta)
signal BeatUpdate(timeInBeats)

signal PhaseSwitch

@export var stream : AudioStreamOggVorbis
@export var syncUpdateRate = 1.0
@export var phaseSwitchRate = 8.0
@export var rules : GameModeRules


var time_begin
var time_delay

var bpm
var bps
var spb
var nextSyncUpdate = 0.0
var nextBeatUpdate = 0.0
var nextPhaseUpdate = 7.0
var time
var timeInBeats = 0.0001

#integer experiments

#how does this work
#it can be used to do calculations for future time
#root time we grab is still a float
#but we just never wanna do math with that
#so this is a non floating point value that just truncates a certain level of detail

#TODO: this only supports one callback per beat, must be an array
var callbacks = {}
var updateCallbacks = {}


func _ready() -> void:
	set_process(false)
	$AudipPlayer.stream = stream
	#Start()
	
func Start():
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	bpm = stream.bpm
	bps = bpm/60.0
	spb = 60.0/bpm
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
	

	ProcessUpdateCallbacks()
	
#update callbacks are added in as objects?

#ok lets jump into this
#so update callbacks need the ability to anchor to the closest beat 
func ProcessUpdateCallbacks():
	for callbackTime in updateCallbacks.keys():

		if timeInBeats >= callbackTime:
			
			updateCallbacks[callbackTime].call()
			updateCallbacks.erase(callbackTime)
			print("swithing phase at ", callbackTime)

func ProcessCallbacks():
	if callbacks.has(snapped(timeInBeats,syncUpdateRate)):
		callbacks[snapped(timeInBeats,syncUpdateRate)].call()
		callbacks.erase(snapped(timeInBeats,syncUpdateRate))
		

#so this is apparently not working, state is actually not changing early enough
#the issue is we actually need to do the full rules windodw size I think
func _on_player_beat_phase_callback(durationInBeats, callback, anchorToNearestBeat = false) -> void:
	var callbackTime = snapped(timeInBeats,syncUpdateRate) + durationInBeats - (rules.windowSize * 2.0)
	updateCallbacks[callbackTime] = callback

