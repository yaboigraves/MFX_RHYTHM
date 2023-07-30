class_name GameModeState
extends State

#THIS WILL BE SUPERCEEDED BY THE RHYTHM STATE

#OBSELETE

@export var metronome: Metronome
@export var rules:GameModeRules




func enter(_msg := {}) -> void:

	super.enter()
	

func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("FreeMode")


func _on_tracks_track_selected(track) -> void:
	print(track.resource_path)
	metronome.stream = track

