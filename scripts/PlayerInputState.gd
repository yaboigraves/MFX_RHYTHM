class_name PlayerInputState
extends State

@export var rules : GameModeRules

var progress : float
var startTime: float
@export var duration: float = 4.0



func enter(args ={}):

	super.enter()
	progress = 0.0
	startTime = %Metronome.timeInBeats
	
	
func HandleHit(hit: Hit):
	print("Hit ", hit)


	
func CheckIfInBufferZone(hitTime):
	if startTime + duration - hitTime < rules.windowSize * 10:
		return true
