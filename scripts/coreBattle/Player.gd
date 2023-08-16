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
	var result = (stateMachine.state as VerifyState).EvaluateVerification()
	return result

func StartVerifying(pattern):
	stateMachine.transition_to("VerifyState", {"pattern" : pattern})

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

#so we ought to use the time that the current state started as the offset
#so lets think about the implications of a 7.9 hit really quick
#i dont think there ought to be a problem with using state time?

#so we want the time relative to the current game mode state

func _on_player_input_handler_hit(index) -> void:
	var time = HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() - stateMachine.state.startTime
	stateMachine.state.HandleHit(index,time) 

