extends TextureRect


func _on_metronome_tick(timeSeconds, timeBeats) -> void:
	$CenterAnchor.rotation = (timeBeats * PI)/4.0
