class_name GameStateSnapshot
extends RefCounted

var lengthInBeats: int
var recordedHits = [
	[],
	[],
	[],
	[]
]

func _init(lengthInBeats:int, recordHits: Array):
	self.lengthInBeats = lengthInBeats
	self.recordedHits = recordHits
