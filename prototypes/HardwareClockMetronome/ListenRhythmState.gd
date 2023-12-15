class_name ListenRhythmState
extends RhythmState


func enter(args = {}):
	super.enter(args)
	#ui stuff primarily
	#there's kind of like a "state" for all the UI that mirrors these
	#so let these just steer ui
	
	#UI doesnt dynamically spawn/despawn too much
	#just connect in the UI to the signals to these states
	#dont do it with code just drag a ref in or something
	
	
	#for player in PlayerManager.Instance.GetAllPlayers():
		#player.GoIdle()


func update(delta):
	super.update(delta)

	#if HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() >= endingTimeBeats - rules.windowSize/2.0:
		#print("open dat buffer")

