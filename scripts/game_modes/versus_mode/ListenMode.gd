class_name ListenMode
extends GameModeState

@onready var player : Player = %PlayerManager.GetPlayer(0) as Player


#so this has illuminated a flaw in the metronome
#it relies currently on the background track being completly persistent
#this is not ideal if we want to start and stop audio
#I kind of need a "best of" system
#like I need an internal clock
#audio needs to mostly sync to it



func enter(_msg := {}) -> void:
	super.enter()
			
	battleAudio.PlayBackgroundTrack()
	PlayTrackLoop()

func PlayTrackLoop():

	#player.StartRecording(currentGameState)
	
	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, PlayTrackLoop, true)
	print("Etnered state")


