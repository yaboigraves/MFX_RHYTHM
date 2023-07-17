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


#so the targets get weird here
#but actually the timing has fundamentally changed
#so verify works different but I wanted it dumb simple

func StartVerifying():
	stateMachine.transition_to("VerifyState")

func GoIdle():
	stateMachine.transition_to("IdleState")


func _on_player_input_handler_hit(index) -> void:
	#so the issue is the time we just hit is actually inaccurate
	stateMachine.state.HandleHit(index,HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats()) 

