class_name PlayerInputState
extends State

@export var rules : GameModeRules
@export var duration: float = 4.0

	



func HandleHit(hit: Hit):
	print("Hit ", hit)
