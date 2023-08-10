class_name VerifyRhythmState
extends RhythmState

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
			
			
	elif Blackboard.Instance.roundPatternVerified:
		Blackboard.Instance.defendingPlayerVerified = true
		
		Blackboard.Instance.defensePlayer.ResetUI()
		Blackboard.Instance.offensePlayer.ResetUI()

		Blackboard.Instance.SwapOffensePlayer()
		Blackboard.Instance.Reset()
		
		state_machine.transition_to("Listen")
