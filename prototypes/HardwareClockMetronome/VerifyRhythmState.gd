class_name VerifyRhythmState
extends RhythmState

var player : Player

func enter(args = {}):
	player = args.player
	
	print(player.GetRecordedPattern())
	player.StartVerifying(player.Get)
