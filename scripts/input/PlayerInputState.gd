class_name PlayerInputState
extends State

signal HitPerformed(hit:Hit)
signal Goodhit(hit:Hit)
signal BadHit(hit:Hit)
signal Missedhit(hit:Hit)

@export var rules : GameModeRules
@export var player : Node


func initialize():
	super.initialize()

func enter(args ={}):
	super.enter()
	player.radialUI.HandleStateStart(self)

func HandleHit(index, time):
	pass

