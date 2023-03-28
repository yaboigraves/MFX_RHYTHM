class_name PlayerInputState
extends State

@export var rules : GameModeRules

var progress : float
@export var duration: float = 4.0

func enter(args ={}):
	progress = 0.0
	
func HandleHit(hit: Hit):
	print("Hit ", hit)
