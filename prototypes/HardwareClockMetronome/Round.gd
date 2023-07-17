class_name Round
extends RefCounted

var offensePlayer: Player
var defensePlayer: Player

var offensePlayerWent: bool
var defensePlayerWent: bool

func _init(offensePlayer: Player, defensePlayer :Player):
	self.offensePlayer = offensePlayer
	self.defensePlayer = defensePlayer
	
	
