class_name VerifyRhythmState
extends RhythmState

var player : Player
var round : Round

func enter(args = {}):
	super.enter()
	
	round = args.round
	
	#so basically here, we do need some outside info
	#who is actually verifying? are they offense or defense?
	#I suppose there and kind of two types of verify states
	#offense verify and defense verify
	
	#so if the offense player hasnt verified yet, this is an offense verify
	#just use round state
	FigureOutIfOffenseOrDefense()
	
	
func FigureOutIfOffenseOrDefense():
	if !round.offensePlayerWent:
		print("this is an offense verify")
		
		#in which case, we need to get the recorded sequence
		
		#so we're verifying agains this pattern one time
		print(round.recordedPattern)
		
		
		
	else:
		print("This is a defense verify")
		print(round.recordedPattern)
	
	
