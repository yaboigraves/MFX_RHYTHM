class_name RecordState
extends PlayerInputState

var buffer : Array[Hit]

#so record ought to when entered queue itself to end
#so record state is just going to stamp 
var gameState:GameState 


func initialize():
	super.initialize()

func enter(_msg = {}):
	super.enter()
	gameState = _msg["gameState"] as GameState

func HasAnyHits():
	for hitLane in gameState.recordedHits:
		if hitLane.size() > 0:
			return true
	return false

func update(_delta):
	super.update(_delta)
	#player.UpdateRecordStateProgress(progress)
	player.RecordStateProgressUpdate.emit(progress)

func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats,startTime,HitType.RECORD)
	gameState.recordedHits[hit.laneIndex].append(hit)
	
	player.emit_signal("SpawnMarker",hit)
	emit_signal("Goodhit",hit)

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	HandleHit(lane,time)
