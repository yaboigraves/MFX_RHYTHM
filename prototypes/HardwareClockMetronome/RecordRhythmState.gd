class_name RecordRhythmState
extends State

@export var rules: GameModeRules


func enter(args = {}):
	super.enter(args)
	
	for player in PlayerManager.Instance.GetAllPlayers():
		player.GoIdle()

	
func update(delta):
	super.update(delta)
	

func ResolveNextState():
	Blackboard.Instance.recordedPattern = Blackboard.Instance.recordedPattern.duplicate(false)
	Blackboard.Instance.roundPatternRecorded = true
	Blackboard.Instance.defensePlayer.PreloadRecordedRhythm()
	
	state_machine.transition_to("Verify",{"duration" : 8})
