class_name RecordRhythmState
extends State

@export var rules: GameModeRules
#so now we can just kinda like, assign players or grab from blackboard

#var inputOpened

func enter(args = {}):
	super.enter(args)
	
	for player in PlayerManager.Instance.GetAllPlayers():
		player.GoIdle()

#	inputOpened = false
	
func update(delta):
	super.update(delta)
	
#	if not inputOpened and HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() >= (startingTimeBeats + 7.84):
#		inputOpened = true
#		Blackboard.Instance.offensePlayer.StartRecording()


func ResolveNextState():
	Blackboard.Instance.recordedPattern = Blackboard.Instance.recordedPattern.duplicate(false)
	Blackboard.Instance.roundPatternRecorded = true
	Blackboard.Instance.defensePlayer.PreloadRecordedRhythm()
	
	#so the verify state is going to be slightly longer now?
	#no actually
	#so record is slightly shorter to make room for verify
	#verify goes for 8
	#defense immedieately goes
	state_machine.transition_to("Verify",{"duration" : 8})
