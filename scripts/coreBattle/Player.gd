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

#yeah wait I thought I refactored this
#the player can just have a ref to steer the uis
#we dont really need to do this with signals at all
#lets replace all signal areas with direct function calls

signal SpawnMarker(hit:Hit)
signal HitProcessed(hit: Hit, hitResult : HitResult)
signal RecordStateProgressUpdate(progress:float)
signal VerifyStateProgressUpdate(progress:float)

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


func _on_player_input_handler_hit(index) -> void:
	#so the issue is the time we just hit is actually inaccurate
	stateMachine.state.HandleHit(index,metronome.timeInBeats) 
