extends Node

#this is our always loaded root object
#basically just does level loading

var labModeScene = preload("res://scenes/main.tscn")

#super dumb simple version of level loading
#we REALLY need to clean this all up a bunch
#so obviously come back and do so

func _on_main_menu_load_lab_mode() -> void:
	$MainMenu.queue_free()
	await $MainMenu.tree_exited
	var labMode = labModeScene.instantiate()
	add_child(labMode)
	
