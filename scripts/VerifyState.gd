extends PlayerInputState

signal DestroyHit(hit:Hit)



var targetHits

func initialize():
	super.initialize()
	duration = rules.loopBeatSize

func enter(_msg := {}) -> void:
	super.enter()
	targetHits = _msg["hits"]


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
	
	
	
