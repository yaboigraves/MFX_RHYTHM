class_name RotationalLayoutGroup
extends Control

#goes top to bottom!
@export var min_rotation : float = -22
@export var max_rotation : float = 0

func _ready() -> void:
	print("test")
	
	

	for i in range(get_child_count()):

		get_child(i).rotation = deg_to_rad(min_rotation + (i * (max_rotation - min_rotation)))
		get_child(i).position = Vector2(600,0).rotated(get_child(i).rotation)
	#get_child(0).rotation = deg_to_rad(min_rotation)
	
