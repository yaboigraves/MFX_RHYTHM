extends PlayerInputState

#so the record state can hold input for a round
#the verify state can then be passed that data in the transition
#record state doesnt need to store anything

#so yeah we need a class for hits

signal SpawnMarker(hit:Hit)

var hits = [
	[],
	[],
	[],
	[]
]

func initialize():
	super.initialize()
	duration = rules.loopBeatSize
	print(duration)

func enter(_msg = {}):
	super.enter()
	hits = [
		[],
		[],
		[],
		[]
	]


func HandleHit(hit: Hit):
	print("record state handling hit")
	hits[hit.laneIndex].append(hit)
	emit_signal("SpawnMarker",hit)
	
	
	
	
