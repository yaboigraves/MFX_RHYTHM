extends PlayerInputState

signal DestroyHit(hit:Hit)
signal MissedHit(hit:Hit)


var targetHits

func initialize():
	super.initialize()
	duration = rules.loopBeatSize

func enter(_msg := {}) -> void:
	super.enter()
	targetHits = _msg["hits"]
	
func update(_delta: float):
	CheckForMissedHits()


func HandleHit(hit:Hit):
	if CheckHit(hit):
		print("good!!!")
	else:
		print("Bad!!!@")

	
func CheckHit(hit:Hit):
	if(targetHits[hit.laneIndex].size() < 1):
		return false

	if abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize)) <= 0.25:
		var goodHit = targetHits[hit.laneIndex].pop_front()
		emit_signal("DestroyHit",goodHit)
		return true
		

func CheckForMissedHits():
	
	var missedHits = []
	
	for i in range(4):
		for hit in targetHits[i]:
			if(hit.time + rules.loopBeatSize + 0.25 <= %Metronome.timeInBeats):
				print("miss!")
				missedHits.append(hit)
				emit_signal("MissedHit",hit)
			
	for hit in missedHits:
		targetHits[hit.laneIndex].erase(hit)
	
	
	
