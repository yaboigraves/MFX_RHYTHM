class_name InputSpoofer
extends Node

#so the input spoofer exposes a public set of values we can just fuck with and inject

#we probably want to map these to phases

@export var inputSpoofProfiles: Array[InputSpoofProfile]

@export var spoofInput = false
@export var lane1Hits : Array[float]
@export var lane2Hits : Array[float]
@export var lane3Hits : Array[float]
@export var lane4Hits : Array[float]

signal SpoofHit(lane: int, time: float)


var roundHits = {}

func _ready() -> void:
	set_process(false)
#so basically on the record phase, we want to get activated
#so now we can kinda just like, look at absolute time
#lets make a metronome func that can check if a time has been reached in a phase?
#i mean this should just be hard coded for the game rules actually lets be dumb

func _process(delta: float) -> void:
	var time = fposmod(%Metronome.timeInBeats,4.0)

#	if lane1Hits.size() > 0 and lane1Hits[0] <= time:
#		emit_signal("SpoofHit",1,lane1Hits[0])
#		lane1Hits.pop_front()
#	if lane2Hits.size() > 0 and lane2Hits[0] <= time:
#		emit_signal("SpoofHit",2,lane2Hits[0])
#		lane2Hits.pop_front()
#
#	if lane3Hits.size() > 0 and lane3Hits[0] <= time:
#		emit_signal("SpoofHit",3,lane3Hits[0])
#		lane3Hits.pop_front()
#	if lane4Hits.size() > 0 and lane4Hits[0] <= time:
#		emit_signal("SpoofHit",4,lane4Hits[0])
#		lane4Hits.pop_front()

	for i in range(3):
		var hitSpoofs = roundHits[i]
		if hitSpoofs.size() > 0 and hitSpoofs[0] <= time:
			emit_signal("SpoofHit",i+ 1,hitSpoofs[0])
			hitSpoofs.pop_front()
		
func _on_record_state_on_enter() -> void:
	if spoofInput:
		set_process(true)
		roundHits = [[] + lane1Hits,[] + lane2Hits,[] + lane3Hits,[] + lane4Hits]


func _on_record_state_on_exit() -> void:
	set_process(false)


func _on_verify_state_on_enter() -> void:
	if spoofInput:
		set_process(true)
		roundHits = [[] + lane1Hits,[] + lane2Hits,[] + lane3Hits,[] + lane4Hits]


func _on_verify_state_on_exit() -> void:
	set_process(false)


func FindProfileByStateName(stateName:  String):
	for profile in inputSpoofProfiles:
		if profile.stateName == stateName:
			return profile

func _on_player_state_machine_transitioned(state) -> void:
	var profile = FindProfileByStateName(state.name)
	
	if profile:
		roundHits = [[] + profile.lane1Inputs, [] + profile.lane2Inputs, [] + profile.lane3Inputs, [] + profile.lane4Inputs]
		set_process(true)
	else:
		set_process(false)
