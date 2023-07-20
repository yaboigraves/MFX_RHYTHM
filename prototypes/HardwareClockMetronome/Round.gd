class_name Round
extends RefCounted

#lets store the recorded sequence in here too we can extract it from the player that recorded

var recordingPlayer: Player
var defendingPlayer: Player

var roundPatternRecorded: bool = false
var roundPatternVerified: bool = false
var verificationFailed : bool = false

var defendingPlayerVerified:bool = false

var recordedPattern:Array = [[],[],[],[]]

func _init(recordingPlayer: Player, defendingPlayer :Player):
	self.recordingPlayer = recordingPlayer
	self.defendingPlayer = defendingPlayer



#wait can we maybe just do this in the exit of states????
#lets see....

func UpdateRoundState(endingState):
	if endingState is RecordRhythmState:
		recordedPattern = endingState.GetRecordedPattern().duplicate(false)
		roundPatternRecorded = true
		
	
	elif endingState is VerifyRhythmState:
		if !roundPatternVerified:
			print(recordedPattern)
			var results = recordingPlayer.EvaluateVerification()
			if results:
				roundPatternVerified = true
			else:
				verificationFailed = true
		
		elif roundPatternVerified:
			defendingPlayerVerified = true
