class_name Metronome
extends Resource

signal Tick(timeSeconds, timeBeats)
signal SyncUpdate(timeInBeats,delta)
signal BeatUpdate(timeInBeats)

signal PhaseSwitch

@export var stream : AudioStreamOggVorbis
@export var syncUpdateRate = 1.0
@export var phaseSwitchRate = 8.0
@export var rules : GameModeRules

#cool so now we can calculate this as part of the callbacks?
@export var currentPhaseProgressVar: FloatVariable

var time_begin
var time_delay

var bpm
var bps
var spb
var nextSyncUpdate = 0.0
var nextBeatUpdate = 0.0
var nextPhaseUpdate = 7.0
var time = 0
var timeInBeats = 0.0001

#integer experiments

#TODO: this only supports one callback per beat, must be an array
var callbacks = {}
var updateCallbacks = {}


#func _ready() -> void:
#	set_process(false)

var enabled = false

func Start():
#	#something else should manage this, probably like an audio player object
#	#cause we want other audio too
#	$AudipPlayer.stream = stream
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	nextSyncUpdate = 0.0
	nextBeatUpdate = 0.0
	nextPhaseUpdate = 7.0
	bpm = stream.bpm
	bps = bpm/60.0
	spb = 60.0/bpm
	timeInBeats = 0
	enabled = true
	
#	$AudipPlayer.play()
#	set_process(true)

func Stop():
#	$AudipPlayer.stop()
#	set_process(false)
	callbacks.clear()
	updateCallbacks.clear()
	enabled = false
	
func update(delta):
	if not enabled: return
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


	if timeInBeats >= nextSyncUpdate:
		nextSyncUpdate = snapped(timeInBeats,syncUpdateRate) + syncUpdateRate
		emit_signal("SyncUpdate",snapped(timeInBeats,syncUpdateRate),syncUpdateRate)
#		print(timeInBeats)
		ProcessCallbacks()
	
	#currentPhaseProgressVar.Value = time
	ProcessUpdateCallbacks()
	ProcessGameState()
	
func ProcessGameState():
	if currentGameState == null : return
	currentGameState._process(timeInBeats)
	
	
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
		

#so this is actually specifically for phases
#so we can actually create state for this properly in update I think


#the metronome can drive one gamestate at a time
var currentGameState : GameState

func _on_player_beat_phase_callback(currentGameState:GameState, callback, anchorToNearestBeat = false) -> void:
	var callbackTime = snapped(timeInBeats,syncUpdateRate) + currentGameState.lengthInBeats - (rules.windowSize * 2.0)
	
	self.currentGameState = currentGameState
	self.currentGameState.StartCurrentState(timeInBeats)
	
	updateCallbacks[callbackTime] = callback
	
