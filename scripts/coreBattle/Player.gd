class_name Player
extends Node

@export var radialUI : Node
@export var characterHUD : Node

@export var gameRules:GameModeRules


signal SpawnMarker(hit:Hit)
signal HitProcessed(hit: Hit, hitResult : HitResult)
signal RecordStateProgressUpdate(progress:float)
signal VerifyStateProgressUpdate(progress:float)

var stateMachine : StateMachine

func _ready():
	stateMachine = %PlayerStateMachine as StateMachine


func StartRecording():
	stateMachine.transition_to("RecordState")
	
	#tell their radial ui to start rotating
	radialUI.ToggleRotation(true)
	

func GetRecordedPattern():
	return (stateMachine.state as RecordState).recordedHits

func EvaluateVerification():
	var result = (stateMachine.state as VerifyState).EvaluateVerification()
	return result

func StartVerifying(pattern):
	stateMachine.transition_to("VerifyState", {"pattern" : pattern})




func GoIdle():
	stateMachine.transition_to("IdleState")


func _on_player_input_handler_hit(index) -> void:
	#so the issue is the time we just hit is actually inaccurate
	stateMachine.state.HandleHit(index,HardwareClockMetronome.instance.GetCurrentBufferPlaybackPositionBeats()) 

