class_name RecordState
extends PlayerInputState

#yeah so this is doing wayyy too many things

#like honestly, it seems like the player really just does like one thing
#and we had all this extra logic
#ya know what
#actually its kinda good that this is stored in player state ngl
#lets just like, actually store it here and not in this gamestate
#lets cook up gamestate at the end of the state
#it


var buffer : Array[Hit]

#so record ought to when entered queue itself to end
#so record state is just going to stamp 
var gameState:GameState 

#so gamestate is really literally like "the state" 
#we dont want to be coupled to that though really?

var recordedHits = []

func initialize():
	super.initialize()

func enter(_msg = {}):
	super.enter()
	recordedHits = [[],[],[],[]]


func HasAnyHits():
	for hitLane in recordedHits:
		if hitLane.size() > 0:
			return true
	return false

func update(_delta):
	super.update(_delta)



func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats,0,HitType.RECORD,self)
	recordedHits[hit.laneIndex].append(hit)
	
	
	player.HitRecorded.emit(hit)
	Goodhit.emit(hit)


func _on_input_spoofer_spoof_hit(lane, time) -> void:
	HandleHit(lane,time)
