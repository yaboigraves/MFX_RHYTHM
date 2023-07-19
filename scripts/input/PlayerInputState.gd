class_name PlayerInputState
extends State


#TODO: refactor all of this out, because all of the timing info is contained in the greater states now


signal HitPerformed(hit:Hit)
signal Goodhit(hit:Hit)
signal BadHit(hit:Hit)
signal Missedhit(hit:Hit)

@export var rules : GameModeRules
@export var duration: float = 4.0
@export var player : Node
#@export var metronome: Metronome

var progress : float
var startTime: float
var endTime: float

func initialize():
	super.initialize()



func enter(args ={}):
	super.enter()
	progress = 0.0

#	startTime = metronome.timeInBeats
	duration = rules.loopBeatSize
	endTime = startTime + duration

	#so when a state gets entered, quue it to end?
	player.radialUI.HandleStateStart(self)
#	if not metronome.is_connected("Tick",onMetronomeTick):
#		metronome.Tick.connect(onMetronomeTick)

func exit():
	super.exit()
#	metronome.Tick.disconnect(onMetronomeTick)

func onMetronomeTick(timeSeconds,timeBeats):
	progress = (timeBeats - startTime)/duration


#
#func HandleHit(hit: Hit):
#	pass
#
func HandleHit(index, time):
	pass


	
func CheckIfInBufferZone(hitTime):
	if startTime + duration - hitTime < rules.windowSize * 10:
		return true
