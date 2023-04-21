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

	#lets look at the actual math here
	#so the time of the beat - target time 
	#so the difference must be less than 10 * the window size
	#which is dumb
	#so lets just fix some of this input code I think
	
	#SO
	#the good way to think about the window is just raw size, then divide by 2 when neccessary
	#so the raw size is what we move forawrd with now
	#lets assume the raw size is 0.5 beats
	#ok first things first lets draw this right
	
	if abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize)) <= (rules.windowSize) :
		var goodHit = targetHits[hit.laneIndex]

		return true

#aha! so this is indeed fucked up

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
