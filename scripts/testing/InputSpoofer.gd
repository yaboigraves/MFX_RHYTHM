class_name InputSpoofer
extends Node

#so the input spoofer exposes a public set of values we can just fuck with and inject

#we probably want to map these to phases

@export var inputSpoofProfiles: Array[InputSpoofProfile]

@export var spoofInput = false

signal SpoofHit(lane: int, time: float)


var roundHits = {}

func _ready() -> void:
	set_process(false)



func _process(delta: float) -> void:
	var time = fposmod(%Metronome.timeInBeats,4.0)

	for i in range(4):
		var hitSpoofs = roundHits[i]
		if hitSpoofs.size() > 0 and hitSpoofs[0] <= time:
			print("spoofing input to lane", i + 1)
			emit_signal("SpoofHit",i+ 1,hitSpoofs[0])
			hitSpoofs.pop_front()
		




func _on_verify_state_on_exit() -> void:
	set_process(false)


func FindProfileByStateName(stateName:  String):
	for profile in inputSpoofProfiles:
		if profile.stateName == stateName:
			return profile

func _on_player_state_machine_transitioned(state) -> void:

	if spoofInput == false: 
		return
	
	var profile = FindProfileByStateName(state.name)
	
	if profile:
		roundHits = [[] + profile.lane1Inputs, [] + profile.lane2Inputs, [] + profile.lane3Inputs, [] + profile.lane4Inputs]
		set_process(true)
	else:
		set_process(false)
