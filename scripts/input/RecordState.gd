extends PlayerInputState

var buffer : Array[Hit]

#so record ought to when entered queue itself to end


var hits = [
	[],
	[],
	[],
	[]
]

func initialize():
	super.initialize()
	duration = rules.loopBeatSize
	

func enter(_msg = {}):
	super.enter()
	hits = [
		[],
		[],
		[],
		[]
	]
	
	metronome._on_player_beat_phase_callback(8, EvaluateNextState, true)

func HasAnyHits():
	for hitLane in hits:
		if hitLane.size() > 0:
			return true
	return false


#so yeah right now the states are storing their well...state
#this is good but it should be encapsulated into an object

#honestly these should just ref the singleton of the UI ngl
#doing this with signals now is alot of rigging
#or should I just not be lazy....

func EvaluateNextState():
	pass
	print("record state has ended what do we do next?")
	#well we go into verify pretty much always?
	#that depends on the game mode actually
	#well no actually we always go into verify state
	#ok cool so for now we end our turn
	#this may change per game mode i guess but not for now
	state_machine.transition_to("VerifyState", {"hits" : hits})
	

func HandleHit(hit: Hit):
	hits[hit.laneIndex].append(hit)
	player.emit_signal("SpawnMarker",hit)
	emit_signal("HitProcessed",hit,HitResult.GOOD)
	

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	var spoofHit = Hit.new(lane,time, startTime)
	HandleHit(spoofHit)
