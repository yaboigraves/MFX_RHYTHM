class_name Round
extends RefCounted

#lets store the recorded sequence in here too we can extract it from the player that recorded


var offensePlayer: Player
var defensePlayer: Player

var offensePlayerWent: bool
var defensePlayerWent: bool

var recordedPattern:Array = [[],[],[],[]]

func _init(offensePlayer: Player, defensePlayer :Player):
	self.offensePlayer = offensePlayer
	self.defensePlayer = defensePlayer
	


func UpdateRoundState(endingState):
	if endingState is RecordRhythmState:
		recordedPattern = endingState.GetRecordedPattern()
		offensePlayerWent = true
