class_name Hit
extends RefCounted

#TODO: figure out how to handle these actually for real for real
#I think they ought to just snapshot an actual hit
#they ought to be stamped with some context info I think too


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

#In progress
func SetTargetHit(targetHit: Hit):
	if not state is VerifyState:
		printerr("CANT SET TARGET TO HIT OF STATE ", state)
		return
	
	self.targetHit = targetHit
