class_name RecordRhythmState
extends RhythmState


func enter(args = {}):
	super.enter()
	Blackboard.Instance.offensePlayer.StartRecording()
	
##TODO: remove, this should be from blackboard
#func GetRecordedPattern():
#	return player.GetRecordedPattern()

func exit():
	super.exit()
	Blackboard.Instance.defensePlayer.PreloadRecordedRhythm()
	
