class_name ListenRhythmState
extends RhythmState

@export var rules:GameModeRules

func enter(args = {}):
	super.enter(args)

	for player in PlayerManager.Instance.GetAllPlayers():
		player.GoIdle()


func update(delta):
	super.update(delta)

	if HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() >= endingTimeBeats - rules.windowSize/2.0:
		print("open dat buffer")


func ResolveNextState():
	if not Blackboard.Instance.roundPatternRecorded:
		state_machine.transition_to("Record")


	
	
