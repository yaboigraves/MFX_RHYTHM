class_name VerifyState
extends PlayerInputState


signal ComboUpdate(combo)

var targetHits
var recordedHits = [[],[],[],[]]

var targetHitQueue

#so i want to add in a record of all the hits made in this state too
#so we can compare
#we also want to store a solid copy of the target hits



var combo = 0 :
	set(value):
		combo = value
		emit_signal("ComboUpdate",combo)
	
func initialize():
	super.initialize()


func enter(_msg := {}) -> void:
	super.enter()
	
	targetHits = _msg["pattern"].duplicate(true)
	targetHitQueue = targetHits.duplicate(true)
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
	
	#disabled temporarily
	CheckForMissedHits()
	
	#player.VerifyStateProgressUpdate.emit(progress)
	#player.UpdateVerifyStateProgress(progress)

func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats, 0, HitType.VERIFY,self)

	recordedHits[index].append(hit)
	
	
	var hitResult = CheckHit(hit)
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


func CheckHit(hit:Hit):
	if(targetHits[hit.laneIndex].size() < 1):
		return HitResult.MISS

	#sooo
	#hmm this might literally work the same
	#var hitDifference = abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize))
	var hitDifference = abs(hit.time - (targetHits[hit.laneIndex][0].time))

	if hitDifference <= rules.windowSize :
		return HitResult.GOOD
	
	elif hitDifference < rules.windowSize + rules.badZoneSize:
		return HitResult.DESTROY_MISS
	

func CheckForMissedHits():
	var missedHits = []
	for i in range(4):
		for hit in targetHits[i]:
			if(hit.time + (rules.windowSize ) <= HardwareClockMetronome.instance.GetCurrentBufferPlaybackPositionBeats()):
				missedHits.append(hit)
				emit_signal("Missedhit",hit)
				
				player.emit_signal("HitProcessed",hit, HitResult.DESTROY_MISS)
				combo = 0
				
	for hit in missedHits:
		#ahah so we have discovered the culprit
		#we were permutating state like a dumby
		#uhh this is kinda the problem with like, using a globally accessible array i guess
		#we shouldnt be erasing from it like this
		targetHits[hit.laneIndex].erase(hit)


#this is probably best tracked per each hit...
func EvaluateVerification():
	for hit in recordedHits:
		pass
	

	
	return true
