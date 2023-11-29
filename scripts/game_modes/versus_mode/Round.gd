class_name Round
extends RefCounted

#so as far as verification goes, we can let the round handle that imo
#we always let the player finish the round then decide what happens
#it should be possible for a player to mess up so bad it just falls apart though
#so actually by the end of verification we know how good they did


signal RoundStarted
signal ListenEnded
signal RecordingStarted
signal VerificationStarted
signal RecordingPlayerTurnDone
signal DefendingPlayerTurnDone
signal RoundEnded

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
	#0.125 is testing value for the window difference for the leadup
	#we might want to just create a buffer or something but thats annoying and cringe
	HardwareClockMetronome.instance.AddCallback(HandleListenEnd, stream.beat_count)
	HardwareClockMetronome.instance.AddCallback(HandleRecordEnd, stream.beat_count * 2 )
	HardwareClockMetronome.instance.AddCallback(HandleVerifyEnd, stream.beat_count * 3 )
	RoundStarted.emit()



func HandleListenEnd():
	print(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())
	
	RecordingStarted.emit()
	#rounds can probably manage this it's ok I guess
	
	#let the players run their own uis
	recordingPlayer.StartRecording()
	
func HandleRecordEnd():
	print("recording ended")
	recordingPlayer.StartVerifying([])

func HandleVerifyEnd():
	#if the player fucked up, round is over
	
	if recordingPlayer.EvaluateVerification():
		#if the player successfully verified, go into defense mode right away
		HardwareClockMetronome.instance.AddCallback(HandleRecordEnd, stream.beat_count)
		recordingPlayer.GoIdle()
		defendingPlayer.StartDefending()
	else:
		RoundEnded.emit()


func HandleDefenseEnd():
	RoundEnded.emit()


func _process(delta):
	pass
