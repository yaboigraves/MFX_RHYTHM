class_name Hit
extends RefCounted

var laneIndex : int 
var time : float
var roundStartTime : float

var roundTime:float:
	get:
		return time - roundStartTime

func _init(laneIndex,time, roundStartTime) -> void:
	self.laneIndex = laneIndex
	self.time = time 
	self.roundStartTime = roundStartTime

