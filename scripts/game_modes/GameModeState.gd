class_name GameModeState
extends State

@export var metronome: Metronome
@export var rules:GameModeRules
@export var battleAudio: BattleAudioManager

var currentGameState : GameState

func enter(_msg := {}) -> void:
	currentGameState = GameState.new(rules.loopBeatSize)
	super.enter()
	

func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("FreeMode")

func _on_tracks_track_selected(track) -> void:
	print(track.resource_path)
	metronome.stream = track

