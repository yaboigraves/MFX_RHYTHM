extends Button

#so the idea is this should kind of be a toggle
#if we press another menu then close this and re-enable



func _on_pressed() -> void:
	#disabled = true
	#$SubMenu.set_visible(true)
	#$SubMenu/VBoxContainer/Button.grab_focus()
	pass

func _on_toggled(button_pressed: bool) -> void:
	
	print(button_pressed)
	if button_pressed:
		if not $SubMenu.visible:
			$SubMenu/AnimationPlayer.play("grow")
			$SubMenu.set_visible(true)
		else:
			$SubMenu.set_visible(false)
	else:
		$SubMenu.set_visible(false)
