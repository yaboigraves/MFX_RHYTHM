class_name Round
extends RefCounted

#lets store the recorded sequence in here too we can extract it from the player that recorded

var recordingPlayer: Player
var defendingPlayer: Player

var roundPatternRecorded: bool
var roundPatternVerified: bool
var verificationFailed : bool

var defendingPlayerVerified:bool

var recordedPattern:Array = [[],[],[],[]]

func _init(recordingPlayer: Player, defendingPlayer :Player):
	self.recordingPlayer = recordingPlayer
	self.defendingPlayer = defendingPlayer
	


func UpdateRoundState(endingState):
	if endingState is RecordRhythmState:
		recordedPattern = endingState.GetRecordedPattern()
		roundPatternRecorded = true
	
	
	if endingState is VerifyRhythmState:
		#so first which player are we looking at
		#if we havent verified, we're looking at the recording player
		if !roundPatternVerified:
			var results = recordingPlayer.EvaluateVerification()
			if results:
				roundPatternVerified = true
			else:
				verificationFailed = true
