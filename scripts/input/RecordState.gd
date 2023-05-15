extends PlayerInputState

signal SpawnMarker(hit:Hit)

var buffer : Array[Hit]

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

func HasAnyHits():
	for hitLane in hits:
		if hitLane.size() > 0:
			return true
	return false

func HandleHit(hit: Hit):
	hits[hit.laneIndex].append(hit)
	emit_signal("SpawnMarker",hit)
	emit_signal("HitProcessed",hit,HitResult.GOOD)
	

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	var spoofHit = Hit.new(lane,time, startTime)
	HandleHit(spoofHit)
