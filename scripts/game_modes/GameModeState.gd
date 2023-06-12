class_name GameModeState
extends State



@export var rules:GameModeRules
@export var currentGameState : GameState
#test

func enter(_msg := {}) -> void:
	super.enter()

func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("FreeMode")

func _on_tracks_track_selected(track) -> void:
	metronome.stream = track

