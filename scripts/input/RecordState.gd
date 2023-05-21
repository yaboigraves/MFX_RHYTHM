extends PlayerInputState

var buffer : Array[Hit]

#so record ought to when entered queue itself to end
#so record state is just going to stamp 
var gameState:GameState 

#
#var hits = [
#	[],
#	[],
#	[],
#	[]
#]

func initialize():
	super.initialize()
	duration = rules.loopBeatSize
	

func enter(_msg = {}):
	super.enter()
	
	gameState = _msg["gameState"] as GameState
	
#	hits = [
#		[],
#		[],
#		[],
#		[]
#	]
	


func HasAnyHits():
	for hitLane in gameState.recordedHits:
		if hitLane.size() > 0:
			return true
	return false



func HandleHit(hit: Hit):
	gameState.recordedHits[hit.laneIndex].append(hit)
	player.emit_signal("SpawnMarker",hit)
	#emit_signal("HitProcessed",hit,HitResult.GOOD)
	emit_signal("Goodhit",hit)
	

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	var spoofHit = Hit.new(lane,time, startTime)
	HandleHit(spoofHit)
