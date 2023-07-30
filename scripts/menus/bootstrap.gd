extends Node

var labModeScene = preload("res://scenes/main.tscn")

func _on_main_menu_load_lab_mode() -> void:
	$MainMenu.queue_free()
	await $MainMenu.tree_exited
	var labMode = labModeScene.instantiate()
	add_child(labMode)
	
