extends Node



func _on_metronome_beat_update(timeInBeats) -> void:
	var tween =create_tween()
	tween.tween_property($Control/VBoxContainer/Pivot/CharacterIcon, "scale", Vector2.ONE * 0.8, %Metronome.spb)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(func() : $Control/VBoxContainer/Pivot/CharacterIcon.scale = Vector2.ONE)
