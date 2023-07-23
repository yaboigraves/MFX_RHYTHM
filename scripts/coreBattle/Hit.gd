class_name Hit
extends RefCounted

var laneIndex : int 
var time : float
var roundStartTime : float
var hitType
var state : State
var targetHit : Hit



var roundTime:float:
	get:
		return time - roundStartTime

func _init(laneIndex,time, roundStartTime, hitType, state) -> void:
	self.laneIndex = laneIndex
	self.time = time 
	self.roundStartTime = roundStartTime
	self.hitType = hitType
	self.state = state

#LEFT OFF HERE
func SetTargetHit(targetHit: Hit):
	if not state is VerifyState:
		printerr("CANT SET TARGET TO HIT OF STATE ", state)
		return
	
	self.targetHit = targetHit
