class_name PlayerInputState
extends State

signal HitProcessed(hit: Hit, hitResult : HitResult)

@export var rules : GameModeRules
@export var duration: float = 4.0


var progress : float
var startTime: float



func enter(args ={}):

	super.enter()
	progress = 0.0
	startTime = %Metronome.timeInBeats
	
	
func HandleHit(hit: Hit):
	pass
	


	
func CheckIfInBufferZone(hitTime):
	if startTime + duration - hitTime < rules.windowSize * 10:
		return true
