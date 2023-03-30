
extends Node
signal Hit(index:int)
signal Escape

#TODO: cache a ref to the metronome, as timing info is super important to all input events

func _process(delta: float) -> void:
	for i in range(1,5):
		if Input.is_action_just_pressed("Drum" + str(i)):
			get_child(i-1).play()
			HandleHit(i-1)
	
#	if Input.is_action_just_pressed("Cancel"):
#		emit_signal("Escape")
#
func HandleHit(index : int):
	emit_signal("Hit",index)
	
