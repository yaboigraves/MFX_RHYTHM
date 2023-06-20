class_name Player
extends Node

@export var radialUI : Node
@export var characterHUD : Node

@export var gameRules:GameModeRules
@export var metronome : Metronome


#so the states can signal stuff needs to happen
#and then we can call it here directly

#what needs to happen
#spawn markers
#clean markers up
#do stuff with the character hud
#fill stuff
#yeah makes sense to me
#just signal up

signal BeatPhaseCallback(durationInBeats:float,callback:Callable)
signal SpawnMarker(hit:Hit)
signal HitProcessed(hit: Hit, hitResult : HitResult)

var stateMachine : StateMachine

func _ready():
	stateMachine = %PlayerStateMachine as StateMachine
	stateMachine.StartMachine()


func StartRecording(gameState: GameState):
	stateMachine.transition_to("RecordState", {"gameState" : gameState})

func StartVerifying(gameState: GameState):
	stateMachine.transition_to("VerifyState", {"gameState" : gameState})

func GoIdle():
	stateMachine.transition_to("IdleState")



#so certain states update the green thing

func UpdateRecordStateProgress(progress):
	radialUI.SetRecordStateProgressRadial(progress)

func UpdateVerifyStateProgress(progress):
	radialUI.SetVerifyStateProgressRadial(progress)

#maybe we can get like a return enum for what to do with it from here
#that way logic is still in the plyer?
func _on_player_input_handler_hit(index) -> void:
	print(AudioServer.get_output_latency() * 1000)
	#so the issue is the time we just hit is actually inaccurate
	stateMachine.state.HandleHit(index,metronome.timeInBeats + ((AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()) * metronome.bps)) 
