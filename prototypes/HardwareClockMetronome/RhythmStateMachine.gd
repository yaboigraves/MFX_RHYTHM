class_name RhythmStateMachine
extends StateMachine



func GetStates():
	return get_children() as Array[RhythmState]


func AddStateResolutionListener(callback):
	for state in GetStates():
		state.TimeFinished.connect(callback)
