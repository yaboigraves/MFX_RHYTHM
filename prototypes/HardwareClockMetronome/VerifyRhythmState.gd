class_name VerifyRhythmState
extends RhythmState

func enter(args = {}):
	super.enter(args)
	Blackboard.Instance.offensePlayer.StartVerifying(Blackboard.Instance.recordedPattern)


func ResolveNextState():
	var results = Blackboard.Instance.offensePlayer.EvaluateVerification()
	
	if results:
		state_machine.transition_to("Defense", {"duration": 8.16})
		
	else:
		print("you fucked up, reset the bout go into verify yada yada")
	
