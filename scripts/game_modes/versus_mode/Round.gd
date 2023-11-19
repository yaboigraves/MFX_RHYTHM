class_name Round
extends RefCounted

var game_mode_state_machine : StateMachine
var recordingPlayer: Player
var defendingPlayer: Player
var stream : AudioStreamOggVorbis


func _init(game_mode_state_machine: StateMachine,recordingPlayer: Player, defendingPlayer :Player, stream : AudioStreamOggVorbis):
	self.game_mode_state_machine = game_mode_state_machine
	self.recordingPlayer = recordingPlayer
	self.defendingPlayer = defendingPlayer
	self.stream = stream

var schedule_test: float

func Start():
	HardwareClockMetronome.instance.PlayStream(stream)
	HardwareClockMetronome.instance.AddCallback(HandleListenEnd, stream.beat_count - (0.125) )
	

func HandleListenEnd():
	print(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())
	recordingPlayer.StartRecording()
	

func _process(delta):
	pass
