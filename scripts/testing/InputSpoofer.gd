class_name InputSpoofer
extends Node

#this is literally broken
#so it might be good to add this to lab mode as a ui you can queue up
#thats maybe like "training mode actually"

@export var inputSpoofProfiles: Array[InputSpoofProfile]

@export var spoofInput = false

signal SpoofHit(lane: int, time: float)

var currentState : PlayerInputState
var roundHits = {}

func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	for i in range(4):
		var hitSpoofs = roundHits[i]
		if hitSpoofs.size() > 0 and hitSpoofs[0] <= %Metronome.timeInBeats:
			emit_signal("SpoofHit",i+ 1,hitSpoofs[0])
			print("spootinf a hit at ", hitSpoofs[0])
			hitSpoofs.pop_front()


func _on_verify_state_on_exit() -> void:
	set_process(false)


func FindProfileByStateName(stateName:  String):
	for profile in inputSpoofProfiles:
		if profile.stateName == stateName:
			return profile

#this is broken
func _on_player_state_machine_transitioned(state) -> void:

	if spoofInput == false: 
		return
		
		
	
	var profile = FindProfileByStateName(state.name)
	
	if profile:
		roundHits = [[] + profile.lane1Inputs, [] + profile.lane2Inputs, [] + profile.lane3Inputs, [] + profile.lane4Inputs]
		currentState = state
		
		for setOfRoundHits in roundHits:
			for i in range (setOfRoundHits.size()):
				setOfRoundHits[i] += currentState.startTime
				
		set_process(true)
	else:
		set_process(false)
