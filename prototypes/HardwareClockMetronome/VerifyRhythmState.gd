class_name VerifyRhythmState
extends RhythmState

var player : Player

func enter(args = {}):
	super.enter()
	player = args.player
	
	print(player.GetRecordedPattern())
