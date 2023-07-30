class_name FreeMode
extends GameModeState

@onready var player : Player = %PlayerManager.GetPlayer(0) as Player

func enter(_msg := {}) -> void:
	super.enter()
	
#	battleAudio.PlayBackgroundTrack()
	player.StartRecording()
	
#	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, HandleRecordStateEnd, true)


func HandleRecordStateEnd():
	#player.StartVerifying()
#	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, HandleVerifyStateEnd, true)
	pass

func HandleVerifyStateEnd():
	pass
#	var nextGameState : GameState = GameState.new(currentGameState.lengthInBeats)
#	currentGameState = nextGameState
#	player.StartRecording()
#	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, HandleRecordStateEnd, true)
#

func exit():
	metronome.Stop()
	player.GoIdle()
	%InputWindowRadialRhythmDisplay.ClearAllMarkers()


func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("Pause")
