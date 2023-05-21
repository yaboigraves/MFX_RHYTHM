class_name GameModeState
extends State

@export var lengthInBeats : int = 8
var currentGameState : GameState

func enter(_msg := {}) -> void:
	currentGameState = GameState.new(lengthInBeats)
	super.enter()

func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("FreeMode")
