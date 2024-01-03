extends Control

signal LogoDropDone

func _ready() -> void:
	visible = false
	
func DoFade():
	visible = true
	$RichTextLabel.modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	tween.tween_property($RichTextLabel, "modulate", Color.WHITE, 3)

	await tween.finished

	await get_tree().create_timer(3).timeout

	tween = create_tween()
	tween.tween_property($RichTextLabel, "modulate", Color.TRANSPARENT, 3)
	await tween.finished

	
	LogoDropDone.emit()
