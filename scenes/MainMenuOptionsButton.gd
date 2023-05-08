extends Button

#so the idea is this should kind of be a toggle
#if we press another menu then close this and re-enable



func _on_pressed() -> void:
	#disabled = true
	#$SubMenu.set_visible(true)
	#$SubMenu/VBoxContainer/Button.grab_focus()
	pass

func _on_toggled(button_pressed: bool) -> void:

	$SubMenu/AnimationPlayer.play("grow")
	$SubMenu.set_visible(button_pressed)
	disabled = button_pressed
