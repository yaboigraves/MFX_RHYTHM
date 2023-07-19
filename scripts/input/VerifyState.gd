class_name VerifyState
extends PlayerInputState

#ahh we're doing this now lol
#ok
#this probably deserves a proper sit down

signal ComboUpdate(combo)

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
	
	
	
	targetHits = _msg["gameState"].recordedHits
	combo = 0
	
	#so we get the target hits from the gamestate object rn
	#this isnt that good, we can get this from the round now
	#so when we enter an input state, we can get context from the round
	
	

func EvaluateNextState():
	player.emit_signal("TurnDone")

func exit():
	super.exit()
	await get_tree().create_timer(1).timeout
	combo = 0
	
func update(_delta: float):
	super.update(_delta)
	CheckForMissedHits()
	player.VerifyStateProgressUpdate.emit(progress)
	#player.UpdateVerifyStateProgress(progress)

func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats, startTime, HitType.VERIFY)
	var hitResult = CheckHit(hit)
	match hitResult:
		HitResult.GOOD:
			combo += 1
			player.emit_signal("HitProcessed", targetHits[hit.laneIndex].pop_front(), hitResult)			
			emit_signal("Goodhit",hit)
		HitResult.MISS:
			combo = 0
			player.emit_signal("HitProcessed",hit, hitResult)		
			emit_signal("Missedhit",hit)	
		HitResult.DESTROY_MISS:
			combo = 0
			player.emit_signal("HitProcessed", targetHits[hit.laneIndex].pop_front(), hitResult)			
			emit_signal("BadHit",hit)


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
			if(hit.time + rules.loopBeatSize + (rules.windowSize ) <= HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats()):
				missedHits.append(hit)
				emit_signal("Missedhit",hit)
				
				player.emit_signal("HitProcessed",hit, HitResult.DESTROY_MISS)
				combo = 0
				
	for hit in missedHits:
		targetHits[hit.laneIndex].erase(hit)
