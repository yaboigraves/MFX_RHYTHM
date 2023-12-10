class_name Player
extends Node

@export var radialUI : Node
@export var characterHUD : Node

@export var gameRules:GameModeRules

signal HitRecorded(hit:Hit)
signal HitProcessed(hit: Hit, hitResult : HitResult)
signal RecordStateProgressUpdate(progress:float)
signal VerifyStateProgressUpdate(progress:float)

var stateMachine : StateMachine

func _ready():
	stateMachine = %PlayerStateMachine as StateMachine


func StartRecording():
	stateMachine.transition_to("RecordState")
	radialUI.ToggleRotation(true)


func EvaluateVerification():
	print("REMEMBER EVAULATE VERIFICATION ALWAYS IS FALSE RIGHT NOW")
	return false
	var result = (stateMachine.state as VerifyState).EvaluateVerification()
	return result

#TODO: let the player just hold the pattern that they're verifying

func StartDefending():
	pass

func StartVerifying():
	stateMachine.transition_to("VerifyState")

func GoIdle():
	stateMachine.transition_to("IdleState")

func PreloadRecordedRhythm():
	var pattern = Blackboard.Instance.recordedPattern
	for lane in pattern:
		for hit in lane:
			radialUI.SpawnMarker(hit)
	radialUI.ToggleRotation(true)

func ResetUI():
	radialUI.ClearAllMarkers()


func _on_player_input_handler_hit(index) -> void:
	var time = HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() 
	if stateMachine.state:
		stateMachine.state.HandleHit(index,time) 

