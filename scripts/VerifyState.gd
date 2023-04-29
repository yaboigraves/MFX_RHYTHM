extends PlayerInputState

signal DestroyHit(hit:Hit)
signal MissedHit(hit:Hit)
signal GoodHit(hit:Hit)
signal BadHit(hit:Hit)
signal ComboUpdate(combo)

signal HitProcessed(hit: Hit, hitResult : HitResult)


var targetHits

var combo = 0 :
	set(value):
		combo = value
		emit_signal("ComboUpdate",combo)
	
func initialize():
	super.initialize()
	duration = rules.loopBeatSize

func enter(_msg := {}) -> void:
	super.enter()
	targetHits = _msg["hits"]
	combo = 0
	
func exit():
	super.exit()
	await get_tree().create_timer(1).timeout
	combo = 0
	
func update(_delta: float):
	CheckForMissedHits()


#so lets just emit the same signal for literally all of these and just package the result enum
func HandleHit(hit:Hit):
	var hitResult = CheckHit(hit)
	match hitResult:
		HitResult.GOOD:
			combo += 1
			emit_signal("HitProcessed", targetHits[hit.laneIndex].pop_front(), hitResult)			
#			emit_signal("GoodHit",targetHits[hit.laneIndex].pop_front())
		HitResult.MISS:
			combo = 0
			emit_signal("HitProcessed",hit, hitResult)			
		HitResult.DESTROY_MISS:
			combo = 0
			emit_signal("HitProcessed", targetHits[hit.laneIndex].pop_front(), hitResult)			
#	
	
	
	


func CheckHit(hit:Hit):
	if(targetHits[hit.laneIndex].size() < 1):
		return HitResult.MISS

	var hitDifference = abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize))
	if hitDifference <= rules.windowSize :
		return HitResult.GOOD
	
	elif hitDifference < rules.windowSize + rules.badZoneSize:
		return HitResult.DESTROY_MISS
	


func CheckForMissedHits():
	var missedHits = []
	for i in range(4):
		for hit in targetHits[i]:
			
			if(hit.time + rules.loopBeatSize + (rules.windowSize ) <= %Metronome.timeInBeats):
				missedHits.append(hit)
				emit_signal("MissedHit",hit)
				combo = 0
			
	for hit in missedHits:
		targetHits[hit.laneIndex].erase(hit)
