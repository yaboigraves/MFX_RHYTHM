extends Control

@export var firstSelected: Node

signal LoadLabMode

#ok cool so there's a good amount to do here obviously
#first things first is we want to get basic functionality
#primarily what this looks like is first getting lab mode working
#can we launch into game mode from here
#this script here can handle those requests
#actually
#probably better if bootstrap handles it
#that way I can test UI functionaltiy better
#so make some signals in here that we emit

#lets do a little bit of cleanup and create some folder setup for this
#I really dont wanna repeat my mistakes from homebody
#we're targetting just support for pc for right now


#lets add some like general back button shit too I guess

#so we do have some modicum of like Ui state here
#handle it later I suppose?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#firstSelected.grab_focus()
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action("Cancel"):
		get_tree().quit()
	if event.is_action("Back"):
		print("back press do something later")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func OnLabModePress() -> void:
	emit_signal("LoadLabMode")
