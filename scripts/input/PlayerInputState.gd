class_name PlayerInputState
extends State

#so this might actually handle some scheduling?
#we ought to be able to schedule them to auto exit?

#so this can get replaced with requests for audio
#signal HitProcessed(hit: Hit, hitResult : HitResult)

signal Goodhit(hit:Hit)
signal BadHit(hit:Hit)
signal Missedhit(hit:Hit)

@export var rules : GameModeRules
@export var duration: float = 4.0
@export var player : Node
@export var metronome: Metronome

var progress : float
var startTime: float

func initialize():
	super.initialize()


func enter(args ={}):
	super.enter()
	progress = 0.0
	#do it with getnode i suppose?
	#maybe the gamestate ought to just like, store state or something
	#that makes more sense actually
	#we get a state update in the gamemode and a tick in the game mode..
	#that probably makes more sense...
	#startTime = get_tree().root.gameState.timeInBeats
	startTime = metronome.timeInBeats
	
	#so when a state gets entered, quue it to end?
	
	
	
func HandleHit(hit: Hit):
	pass
	


	
func CheckIfInBufferZone(hitTime):
	if startTime + duration - hitTime < rules.windowSize * 10:
		return true
