extends PlayerInputState

#so the record state can hold input for a round
#the verify state can then be passed that data in the transition
#record state doesnt need to store anything

#so yeah we need a class for hits

signal SpawnMarker(hit:Hit)

var buffer : Array[Hit]

var hits = [
	[],
	[],
	[],
	[]
]

func initialize():
	super.initialize()
	duration = rules.loopBeatSize
	

func enter(_msg = {}):
	super.enter()
	hits = [
		[],
		[],
		[],
		[]
	]
	buffer = []
	print(_msg)
	if _msg.has("hitBuffer"):
		var hitBuffer = _msg.hitBuffer
		for hit in hitBuffer:
			HandleHit(hit)

func HasAnyHits():
	for hitLane in hits:
		if hitLane.size() > 0:
			return true
	return false

func HandleHit(hit: Hit):
	
	var keepGoing = true
	#so we actually wanna check if we're in the buffa zone
	if CheckIfInBufferZone(hit.time):
		print("we are in da buffa zone during a record state")
		#so basically we have the state to actually handle this here
		#we wanna basically borrow the check hit function from the verify state
		#if we verify a hit, we actually are going to lock normal input, and only accept pseudo verify hits
		#we want to add to a buffer once again though,
		#specifically just check the start of the arrays
		

		for i in range(3):
			if(hits[i].size() > 0):
				print("there are some hits here")
				if abs(hits[i][0].time + 4 - hit.time) < 0.1:
					print("to the buffer you go")				
					buffer.append(hit)
					keepGoing = false
				else:
					hits[hit.laneIndex].append(hit)
					emit_signal("SpawnMarker",hit)
					return
	
	if keepGoing:
		hits[hit.laneIndex].append(hit)
		emit_signal("SpawnMarker",hit)
	
	
	
	


func _on_input_spoofer_spoof_hit(lane, time) -> void:
	var spoofHit = Hit.new(lane,time)
	HandleHit(spoofHit)
