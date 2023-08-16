class_name RhythmStateMachine
extends StateMachine

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	super.transition_to(target_state_name,msg)
	
	Blackboard.Instance.currentRhythmState = state

func GetStates():
	return get_children() as Array[RhythmState]

func AddStateResolutionListener(callback):
	for state in GetStates():
		state.TimeFinished.connect(callback)
