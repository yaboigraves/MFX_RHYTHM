class_name Hit
extends RefCounted

var laneIndex : int 
var time : float

func _init(laneIndex,time) -> void:
	self.laneIndex = laneIndex
	self.time = time 
	
