class_name Player
extends RhythmGameStateNode

@export var gameRules:GameModeRules

signal BeatPhaseCallback(durationInBeats:float,callback:Callable)
signal SpawnMarker(hit:Hit)
signal HitProcessed(hit: Hit, hitResult : HitResult)

var stateMachine : StateMachine

func _ready():
	super._ready()
	stateMachine = %PlayerStateMachine as StateMachine
	stateMachine.StartMachine()


func StartRecording(gameState: GameState):
	stateMachine.transition_to("RecordState", {"gameState" : gameState})

func StartVerifying(gameState: GameState):
	stateMachine.transition_to("VerifyState", {"gameState" : gameState})

func GoIdle():
	stateMachine.transition_to("IdleState")

func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,metronome.timeInBeats,stateMachine.state.startTime)
	#print("hit has index", hit.laneIndex)
	stateMachine.state.HandleHit(hit)
	
