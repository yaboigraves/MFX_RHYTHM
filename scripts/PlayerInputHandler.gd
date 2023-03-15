
extends Node
signal Hit(index:int)


func _process(delta: float) -> void:
	for i in range(1,5):
		if Input.is_action_just_pressed("Drum" + str(i)):
			get_child(i-1).play()
			HandleHit(i-1)

func HandleHit(index : int):
	emit_signal("Hit",index)
	
