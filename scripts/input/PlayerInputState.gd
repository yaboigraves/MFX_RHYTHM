class_name PlayerInputState
extends State

signal HitPerformed(hit:Hit)
signal Goodhit(hit:Hit)
signal BadHit(hit:Hit)
signal Missedhit(hit:Hit)

@export var rules : GameModeRules
@export var player : Node
#@export var metronome: Metronome



func initialize():
	super.initialize()



func enter(args ={}):
	super.enter()





	#so when a state gets entered, quue it to end?
	player.radialUI.HandleStateStart(self)
#	if not metronome.is_connected("Tick",onMetronomeTick):
#		metronome.Tick.connect(onMetronomeTick)

func exit():
	super.exit()
#	metronome.Tick.disconnect(onMetronomeTick)



#
#func HandleHit(hit: Hit):
#	pass
#
func HandleHit(index, time):
	pass


	
