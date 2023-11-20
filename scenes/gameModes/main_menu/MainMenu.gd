extends GameMode

func _process(delta: float) -> void:
	$Record.rotation = Time.get_ticks_msec()/1000.0
