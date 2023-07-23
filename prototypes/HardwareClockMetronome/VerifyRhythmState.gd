class_name VerifyRhythmState
extends RhythmState

#ok cool so at this point, it definlty seems like we got something working
#at the end of a record round, we need to spawn all the markers for the other player too


var player : Player
var round : Round

func enter(args = {}):
	super.enter()
	
	round = args.round
	
	
	FigureOutIfOffenseOrDefense()
	


func FigureOutIfOffenseOrDefense():
	if !round.roundPatternVerified:
		round.recordingPlayer.StartVerifying(round.recordedPattern)
	
	elif round.roundPatternVerified:
		round.defendingPlayer.StartVerifying(round.recordedPattern)
		round.recordingPlayer.GoIdle()

func exit():
	super.exit()

	
