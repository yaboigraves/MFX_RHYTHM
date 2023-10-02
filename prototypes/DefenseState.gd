class_name DefenseState
extends State

func enter(args ={}):
	super.enter(args)
	
	Blackboard.Instance.defensePlayer.StartVerifying(Blackboard.Instance.recordedPattern)
	
	Blackboard.Instance.offensePlayer.GoIdle()

	

func ResolveNextState():
	
	#TODO: so we gotta turn off both players input
	
	#we should know when this bout is over
	#given that we can tell when we start the next one
	#we should be able to wait to do the next bout as long as we want too
	#defense doesnt loop it?
	
	#cause it would be nice to be able to like pause and do resolution n stuff
	#defense literally always goes into yada yada
	#i guess we can enter a like "pending state"
	#which just waits till the bout is over over?

	
	Blackboard.Instance.defendingPlayerVerified = true
#
	Blackboard.Instance.defensePlayer.ResetUI()
	Blackboard.Instance.offensePlayer.ResetUI()

	Blackboard.Instance.SwapOffensePlayer()
	Blackboard.Instance.Reset()

	state_machine.transition_to("Record", {"duration": 15.84})
