class_name PhaseView
extends Node


func SetPhase(state):
	if state is RecordState:
		$VBoxContainer/Icons/RecordIcon.modulate = Color.BLUE
		$VBoxContainer/Icons/PlayIcon.modulate = Color(0,255,255,0.2)
		$VBoxContainer/PhaseLabel.text = "[center]RECORD!"
	elif state is VerifyState:
		$VBoxContainer/Icons/RecordIcon.modulate = Color(0,255,255,0.2)
		$VBoxContainer/Icons/PlayIcon.modulate = Color.BLUE
		$VBoxContainer/PhaseLabel.text = "[center]PLAY!"
