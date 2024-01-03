extends Control

signal VersusModeSelected
signal OptionsSelected

func _ready() -> void:
	if get_tree().root.has_node(NodePath(name)):
		visible = true
	else:
		visible = false
		
	$VersusButton.pressed.connect(func():
		VersusModeSelected.emit()
	)
	
	$OptionsButton.pressed.connect(func():
		print("options!")
		
	)
