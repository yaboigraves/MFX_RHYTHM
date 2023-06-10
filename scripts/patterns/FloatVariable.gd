class_name FloatVariable
extends Variable

@export var Value: float:
	set(value):
		Value = value
		emit_signal("OnValueChanged")
	
	
