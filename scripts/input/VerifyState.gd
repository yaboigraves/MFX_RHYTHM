class_name VerifyState
extends PlayerInputState

signal ComboUpdate(combo)

var targetHits
var recordedHits = [[],[],[],[]]

#so this state needs the most work
#lets dooo it

var combo = 0 :
	set(value):
		combo = value
		emit_signal("ComboUpdate",combo)
	
func initialize():
	super.initialize()

func enter(_msg := {}) -> void:
	super.enter()
	
	targetHits = Blackboard.Instance.recordedPattern.duplicate(true)

	recordedHits = [[],[],[],[]]
	combo = 0
	

func EvaluateNextState():
	player.emit_signal("TurnDone")

func exit():
	super.exit()
	await get_tree().create_timer(1).timeout
	combo = 0
	
func update(_delta: float):
	super.update(_delta)
	CheckForMissedHits()


func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats, 0, HitType.VERIFY,self)

	#I don't think this is actually needed
	recordedHits[index].append(hit)
	
	var hitResult = CheckHit(hit)
	
	print(hitResult)
	
	match hitResult:
		HitResult.GOOD:
			combo += 1
			targetHits[hit.laneIndex].pop_front()
			player.emit_signal("HitProcessed", hit, hitResult)			
			emit_signal("Goodhit",hit)
		HitResult.MISS:
			combo = 0
			player.emit_signal("HitProcessed",hit, hitResult)		
			emit_signal("Missedhit",hit)	
		HitResult.DESTROY_MISS:
			combo = 0
			player.emit_signal("HitProcessed", targetHits[hit.laneIndex].pop_front(), hitResult)			
			emit_signal("BadHit",hit)


#so yeah the question of handling timings arises now
func CheckHit(hit:Hit):
	
	if(targetHits[hit.laneIndex].size() < 1):
		return HitResult.MISS
	
	var hitDifference = abs(hit.time - (targetHits[hit.laneIndex][0].time + 8))
	
	if hitDifference <= rules.windowSize :
		return HitResult.GOOD
	
	elif hitDifference < rules.windowSize + rules.badZoneSize:
		return HitResult.DESTROY_MISS
	else:
		return HitResult.MISS
	


func CheckForMissedHits():
	var missedHits = []
	for i in range(4):
		for hit in targetHits[i]:
			if(hit.time + (rules.windowSize ) <= HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats() - startTime):
				missedHits.append(hit)
				emit_signal("Missedhit",hit)
				
				player.emit_signal("HitProcessed",hit, HitResult.DESTROY_MISS)
				combo = 0
				
	for hit in missedHits:
		targetHits[hit.laneIndex].erase(hit)



func EvaluateVerification():
	for hit in recordedHits:
		pass

	return true
