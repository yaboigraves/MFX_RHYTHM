class_name Blackboard
extends RefCounted

static var Instance : Blackboard

var currentRhythmState : RhythmState

var offensePlayer : Player
var defensePlayer : Player

var roundPatternRecorded: bool = false
var roundPatternVerified: bool = false
var verificationFailed : bool = false
var defendingPlayerVerified:bool = false

var recordedPattern:Array = [[],[],[],[]]

func _init() -> void:
	Instance = self
	
func SwapOffensePlayer():
	var temp = offensePlayer
	
	offensePlayer = defensePlayer
	defensePlayer = temp
	
	
func Reset():
	roundPatternRecorded = false
	roundPatternVerified = false 
	verificationFailed = false 
	defendingPlayerVerified = false
	recordedPattern = [[],[],[],[]]
