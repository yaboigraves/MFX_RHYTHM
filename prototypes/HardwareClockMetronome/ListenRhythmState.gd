class_name ListenRhythmState
extends RhythmState


func enter(args = {}):
	super.enter()

	for player in PlayerManager.Instance.GetAllPlayers():
		player.GoIdle()

func ResolveNextState():
	if not Blackboard.Instance.roundPatternRecorded:
		state_machine.transition_to("Record")


	
	
