class_name InputSpoofer
extends Node

@export var playerStateMachine : StateMachine

@export var recordingSpoofProfile: InputSpoofProfile
@export var verifySpoofProfile : InputSpoofProfile

@export var spoofInput = false

signal SpoofHit(lane: int, time: float)

var currentState : PlayerInputState
var roundHits = {}

func _ready() -> void:
	playerStateMachine.transitioned.connect(HandleStateMachineTransition)
	set_process(false)


func _process(delta: float) -> void:
	for i in range(4):
		var hitSpoofs = roundHits[i]
		if hitSpoofs.size() > 0 and hitSpoofs[0] <= HardwareClockMetronome.instance.GetCurrentBufferPlaybackPositionBeats():
			SpoofHit.emit(i,hitSpoofs.pop_front())



func FindProfileByStateName(stateName:  String):
	match stateName:
		"RecordState":
			return recordingSpoofProfile
		"VerifyState":
			return verifySpoofProfile

func HandleStateMachineTransition(state) -> void:
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
