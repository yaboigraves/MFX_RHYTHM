class_name ListenRhythmState
extends RhythmState


func enter(args = {}):
	super.enter()

	for player in PlayerManager.Instance.GetAllPlayers():
		player.GoIdle()


	
	
