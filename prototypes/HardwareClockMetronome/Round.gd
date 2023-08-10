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



#TODO: this is all handled in blackboard now!!



func UpdateRoundState(endingState):
	pass
#	if endingState is RecordRhythmState:
#		recordedPattern = endingState.GetRecordedPattern().duplicate(false)
#		roundPatternRecorded = true
		
	
	#there's really a totally different state type for defense, that's very similar to verify
	#but does something different with the results
	#but I guess for player inputs sake we dont care about that
	#its more like, the versus mode actually needs one more state
	
#	if endingState is VerifyRhythmState:
#		if !roundPatternVerified:
#			print(recordedPattern)
#			var results = recordingPlayer.EvaluateVerification()
#			if results:
#				roundPatternVerified = true
#			else:
#				verificationFailed = true
#
#		elif roundPatternVerified:
#			defendingPlayerVerified = true
