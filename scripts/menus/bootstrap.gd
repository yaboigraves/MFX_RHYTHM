extends Node

#ok so lets think about how we want to do input
#i've learned "mode" modules for input are really good ideas
#so reify the logic for input to a main menu input manager
#and just re-use actions
#ez


#this is our always loaded root object
#basically just does level loading

var labModeScene = preload("res://scenes/main.tscn")

#super dumb simple version of level loading
#we REALLY need to clean this all up a bunch
#so obviously come back and do so

#lets make a dict that maps to shit to load?
#or make them serialized, probably better to serialize them

func _on_main_menu_load_lab_mode() -> void:
	$MainMenu.queue_free()
	await $MainMenu.tree_exited
	var labMode = labModeScene.instantiate()
	add_child(labMode)
	
