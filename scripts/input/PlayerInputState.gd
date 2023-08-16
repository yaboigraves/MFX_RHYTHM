class_name PlayerInputState
extends State

signal HitPerformed(hit:Hit)
signal Goodhit(hit:Hit)
signal BadHit(hit:Hit)
signal Missedhit(hit:Hit)

@export var rules : GameModeRules
@export var player : Node

var startTime

func initialize():
	super.initialize()

func enter(args ={}):
	super.enter()
	player.radialUI.HandleStateStart(self)
	startTime = HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats()

	
func HandleHit(index, time):
	pass

