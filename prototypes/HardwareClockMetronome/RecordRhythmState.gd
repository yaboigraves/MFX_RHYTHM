class_name RecordRhythmState
extends RhythmState
var round: Round
var player : Player



func enter(args = {}):
	super.enter()
	round = args.round
	player = round.offensePlayer
	player.StartRecording()


func GetRecordedPattern():
	return player.GetRecordedPattern()


