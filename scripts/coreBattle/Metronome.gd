class_name Metronome
extends Resource

#make this a resource, yada yada

signal StreamStarting

signal Tick(timeSeconds, timeBeats)
signal SyncUpdate(timeInBeats,delta)
signal BeatUpdate(timeInBeats)
signal PhaseSwitch

@export var stream : AudioStreamOggVorbis
@export var syncUpdateRate = 1.0
@export var phaseSwitchRate = 8.0
@export var rules : GameModeRules

@export var currentPhaseProgressVar: FloatVariable


var time_begin
var time_delay
var audioPlayer : AudioStreamPlayer

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

#so the next big feature is indeed a metronome refactor
#I should branch this so I can rollback
#but

#basically, the core way we handle timing needs to be around these samples we're playing/unplaying
#we dont need a total "length" per say because each timing event is a vaccum
#this should alleviate alot of the like weird sync issues
#We can hypothetically let stuff loop too if needed
#but mostly, it seems like we can start and stop stuff at the right(ish times)
#so yeah!




func Start():
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	nextSyncUpdate = 0.0
	nextBeatUpdate = 0.0
	nextPhaseUpdate = 7.0
	bpm = stream.bpm
	bps = bpm/60.0
	spb = 60.0/bpm
	timeInBeats = 0
	
	
		

func Stop():
#	$AudipPlayer.stop()
#	set_process(false)
	callbacks.clear()
	updateCallbacks.clear()
	
	


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


	if timeInBeats >= nextSyncUpdate:
		nextSyncUpdate = snapped(timeInBeats,syncUpdateRate) + syncUpdateRate
		emit_signal("SyncUpdate",snapped(timeInBeats,syncUpdateRate),syncUpdateRate)
#		print(timeInBeats)
		ProcessCallbacks()
	
	currentPhaseProgressVar.Value = time
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
		

func _on_player_beat_phase_callback(durationInBeats, callback, anchorToNearestBeat = false) -> void:
	print("time is going to be " , timeInBeats)
	var callbackTime = snapped(timeInBeats,syncUpdateRate) + durationInBeats - (rules.windowSize * 2.0)
	
	#print(callbackTime)
	
	updateCallbacks[callbackTime] = callback

