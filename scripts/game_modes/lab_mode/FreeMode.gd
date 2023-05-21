class_name FreeMode
extends GameModeState

@onready var player : Player = %PlayerManager.GetPlayer(0) as Player


func enter(_msg := {}) -> void:
	super.enter()
	metronome.Start()
	player.StartRecording(currentGameState)
	metronome._on_player_beat_phase_callback(8, HandleRecordStateEnd, true)

func exit():
	metronome.Stop()

	#turn off the player state machines
	player.GoIdle()
	
	%InputWindowRadialRhythmDisplay.ClearAllMarkers()
	#cleat the ui

#i guess we can actually just allow you to like stop the current loop
#then pick a new song
#that makes more sense...
#in battle you should be able to just like no contest by holding or pressing it
#theres literally no reason to do pause
#yeah fuck that

func update(delta):
	if Input.is_action_just_pressed("Pause"):
		state_machine.transition_to("Pause")

func HandleRecordStateEnd():
	#get the hits from the player?
	player.StartVerifying(currentGameState)
	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, HandleVerifyStateEnd, true)
	

func HandleVerifyStateEnd():
	var nextGameState : GameState = GameState.new(8)
	currentGameState = nextGameState
	player.StartRecording(currentGameState)
	metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, HandleRecordStateEnd, true)



