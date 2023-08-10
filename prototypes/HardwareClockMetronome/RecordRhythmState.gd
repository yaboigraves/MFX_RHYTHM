class_name RecordRhythmState
extends RhythmState


func enter(args = {}):
	super.enter()
	#TODO: get player refs from the player manager?
	Blackboard.Instance.offensePlayer.StartRecording()
	

func ResolveNextState():
	var test = Blackboard.Instance.offensePlayer
	
	#we do get the pattern from the offense player actually
	
	Blackboard.Instance.recordedPattern = Blackboard.Instance.recordedPattern.duplicate(false)
	Blackboard.Instance.roundPatternRecorded = true
	Blackboard.Instance.defensePlayer.PreloadRecordedRhythm()

	state_machine.transition_to("Verify")
