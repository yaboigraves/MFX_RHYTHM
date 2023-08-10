class_name RecordRhythmState
extends RhythmState


func enter(args = {}):
	super.enter()
	Blackboard.Instance.offensePlayer.StartRecording()
	

func ResolveNextState():
	Blackboard.Instance.recordedPattern = Blackboard.Instance.recordedPattern.duplicate(false)
	Blackboard.Instance.roundPatternRecorded = true
	Blackboard.Instance.defensePlayer.PreloadRecordedRhythm()

	state_machine.transition_to("Verify")
