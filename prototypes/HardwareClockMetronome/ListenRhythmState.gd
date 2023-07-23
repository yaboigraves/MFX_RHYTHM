class_name ListenRhythmState
extends RhythmState
var round : Round

func enter(args = {}):
	super.enter()
	
	round = args.round
	round.recordingPlayer.GoIdle()
	round.defendingPlayer.GoIdle()
