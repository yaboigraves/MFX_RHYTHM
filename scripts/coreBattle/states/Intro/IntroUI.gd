extends CanvasLayer


func DoIntroSequence(callback):
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(func():
		visible = false)
	tween.tween_callback(callback)
