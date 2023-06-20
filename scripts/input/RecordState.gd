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
	player.UpdateRecordStateProgress(progress)
	
#so i guess hits are technically like, recorded or verify
#that state info in a hit might be nice to have ngl

#so i suppose we can lift the logic for this up to player state?
#or is that super roundabout?
#honestly yeah lets just steer from here
#its kinda bad but the state machine is really in control here
#so yeah main thing here is we actually want to do a proper call here


func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats,startTime,HitType.RECORD)
	gameState.recordedHits[hit.laneIndex].append(hit)
	player.emit_signal("SpawnMarker",hit)
	emit_signal("Goodhit",hit)


	

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	#var spoofHit = Hit.new(lane,time, startTime)
	HandleHit(lane,time)
