class_name Round
extends RefCounted

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


func _init(recordingPlayer: Player, defendingPlayer :Player, stream : AudioStreamOggVorbis):
	self.game_mode_state_machine = game_mode_state_machine
	self.recordingPlayer = recordingPlayer
	self.defendingPlayer = defendingPlayer
	self.stream = stream

var schedule_test: float

func Start():
	#todo: maybe elevate this, we just need it for now
	HardwareClockMetronome.instance.PlayStream(stream)
	
	
	#0.125 is testing value for the window difference for the leadup
	#we might want to just create a buffer or something but thats annoying and cringe
	#HardwareClockMetronome.instance.AddCallback(HandleListenEnd, stream.beat_count)
	#HardwareClockMetronome.instance.AddCallback(HandleRecordEnd, stream.beat_count * 2 )
	#HardwareClockMetronome.instance.AddCallback(HandleVerifyEnd, stream.beat_count * 3 )
	RoundStarted.emit()
	
#
#func ScheduleEvents():
	#HardwareClockMetronome.instance.AddCallback(HandleListenStart,0)
	#HardwareClockMetronome.instance.AddCallback(HandleRecordStart, stream.beat_count)
	#HardwareClockMetronome.instance.AddCallback(HandleVerifyStart, stream.beat_count * 2)
	#HardwareClockMetronome.instance.AddCallback(HandleEvaluateOffense, stream.beat_count * 3)
	#
#func HandleListenStart():
	#pass
	#
#func HandleRecordStart():
	#print("Listening has ended")
	#ListenEnded.emit()
#
	#
#func HandleVerifyEnd():
	#print("recording ended")
	#recordingPlayer.StartVerifying()
#
#func HandleEvaluateOffense():
	##if the player fucked up, round is over
	#print("Verifying Ended")
	#
	#if recordingPlayer.EvaluateVerification():
		##if the player successfully verified, go into defense mode right away
		#HardwareClockMetronome.instance.AddCallback(HandleRecordEnd, stream.beat_count)
		#recordingPlayer.GoIdle()
		#defendingPlayer.StartDefending()
	#else:
		#RoundEnded.emit()
#
#
#func HandleDefenseEnd():
	#print("defense has ended!")
	#RoundEnded.emit()
