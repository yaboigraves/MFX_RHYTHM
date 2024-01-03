class_name CharacterSelect
extends Control

func _ready():
	if get_tree().root.has_node(NodePath(name)):
		visible = true
	else:
		visible = false
