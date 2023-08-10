class_name VerifyRhythmState
extends RhythmState

#ok cool so at this point, it definlty seems like we got something working
#at the end of a record round, we need to spawn all the markers for the other player too


func enter(args = {}):
	super.enter()
	FigureOutIfOffenseOrDefense()


func FigureOutIfOffenseOrDefense():
	if Blackboard.Instance.roundPatternRecorded and !Blackboard.Instance.roundPatternVerified:
		Blackboard.Instance.offensePlayer.StartVerifying(Blackboard.Instance.recordedPattern)
	
	elif Blackboard.Instance.roundPatternVerified:
		Blackboard.Instance.defensePlayer.StartVerifying(Blackboard.Instance.recordedPattern)
		Blackboard.Instance.offensePlayer.GoIdle()


func ResolveNextState():
	if !Blackboard.Instance.roundPatternVerified:
		var results = Blackboard.Instance.offensePlayer.EvaluateVerification()
		if results:
			Blackboard.Instance.roundPatternVerified = true
			state_machine.transition_to("Verify")
		else:
			Blackboard.Instance.verificationFailed = true
			#TODO: RESET 
			
	elif Blackboard.Instance.roundPatternVerified:
		Blackboard.Instance.defendingPlayerVerified = true
		
		Blackboard.Instance.defensePlayer.ResetUI()
		Blackboard.Instance.offensePlayer.ResetUI()
		#we're resetting and going back to listen with the defending player being the offense player now
		
		#currentRound = Round.new(currentRound.defendingPlayer, currentRound.recordingPlayer)
		
		Blackboard.Instance.SwapOffensePlayer()
		Blackboard.Instance.Reset()
		
		
		state_machine.transition_to("Listen")

		
		
	

		
