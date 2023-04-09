extends PlayerInputState

signal DestroyHit(hit:Hit)
signal MissedHit(hit:Hit)
signal GoodHit(hit:Hit)
signal BadHit(hit:Hit)
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
	targetHits = _msg["hits"]
	combo = 0
	
	if _msg.has("hitBuffer"):
		print('we got a buffer, process it')
		var hitBuffer = _msg.hitBuffer
		
		for hit in hitBuffer:
			emit_signal("GoodHit",targetHits[hit.laneIndex].pop_front())
	
func exit():
	super.exit()
	await get_tree().create_timer(1).timeout
	combo = 0
	
func update(_delta: float):
	CheckForMissedHits()


func HandleHit(hit:Hit):
	if CheckHit(hit):
		combo += 1
		emit_signal("GoodHit",targetHits[hit.laneIndex].pop_front())
		
	else:
		combo = 0
		emit_signal("BadHit",hit)
	
func CheckHit(hit:Hit):
	if(targetHits[hit.laneIndex].size() < 1):
		return false
	
	#TODO: so this 0.25 is obviously incorrect and needs to be tied in to actual size
	#i dont think this is correct either
	#really take a good look at this math
	if abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize)) <= (rules.windowSize * 2 * 10) :
		var goodHit = targetHits[hit.laneIndex]

		return true
		

func CheckForMissedHits():
	var missedHits = []
	for i in range(4):
		for hit in targetHits[i]:
			
			if(hit.time + rules.loopBeatSize + (rules.windowSize * 2 * 10) <= %Metronome.timeInBeats):
				missedHits.append(hit)
				emit_signal("MissedHit",hit)
				combo = 0
			
	for hit in missedHits:
		targetHits[hit.laneIndex].erase(hit)
	
	
	
