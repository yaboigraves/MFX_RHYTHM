class_name Blackboard
extends RefCounted

#static class that contains gamestate data
#each gamemode probably has its own type of blackboard, blackboard can be used to decide next state and stuff
#so this can do the actual decision making for next states too

#so lets start off by moving some of the round stuff into here

static var Instance

var offensePlayer : Player
var defensePlayer : Player

#specific to versus mode, we ought to subclass this out later
var roundPatternRecorded: bool = false
var roundPatternVerified: bool = false
var verificationFailed : bool = false
var defendingPlayerVerified:bool = false

var recordedPattern:Array = [[],[],[],[]]

func _init() -> void:
	Instance = self
