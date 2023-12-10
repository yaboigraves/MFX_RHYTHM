class_name DefenseState
extends State

func enter(args ={}):
	super.enter(args)
	
	Blackboard.Instance.defensePlayer.StartVerifying()
	
	Blackboard.Instance.offensePlayer.GoIdle()


func ResolveNextState():

	Blackboard.Instance.defendingPlayerVerified = true
#
	Blackboard.Instance.defensePlayer.ResetUI()
	Blackboard.Instance.offensePlayer.ResetUI()

	Blackboard.Instance.SwapOffensePlayer()
	Blackboard.Instance.Reset()

	state_machine.transition_to("Record", {"duration": 15.84})
