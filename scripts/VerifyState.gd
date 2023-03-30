extends PlayerInputState

signal DestroyHit(hit:Hit)
signal MissedHit(hit:Hit)
signal GoodHit(hit:Hit)
signal BadHit(hit:Hit)


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
		#ok so here we want to emit signals that will effect player state
		#combos and whatnot, health, etc
		#basically we want a tug of war for each round
		#staying above a certain threshold is how you win
		#display this with like a custom component or something
		#honestly just a slider will work to start
		#we need feedback text too for hits, experiment with placement
		#for now lets just do good/bad hits existing and getting handled at all
		#a bad is an oops, a miss is a miss
		#spawn the rect for now
		emit_signal("GoodHit",targetHits[hit.laneIndex].pop_front())
		
	else:
		print("Bad!!!@")
		emit_signal("BadHit",hit)
	
func CheckHit(hit:Hit):
	if(targetHits[hit.laneIndex].size() < 1):
		return false

	if abs(hit.time - (targetHits[hit.laneIndex][0].time + rules.loopBeatSize)) <= 0.25:
		var goodHit = targetHits[hit.laneIndex]

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
	
	
	
