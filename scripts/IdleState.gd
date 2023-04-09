extends PlayerInputState


#if it is in the buffer zone, we add it to the buffer for when the record mode starts
#it can be passed as an arg into the state

#ok cool lets handle th buffer now
#so basically, we want to see if we're riiiight before the next mode starts
#if so, we actually cache the hit and then spawn it when we move to the next state
#to do this, we need the actual time, and we need to know the time of the next state
#little tricky
#I think we ought to active the possibility of the buffer from the metronome maybe?

#so every input state ought to know objective time when it starts ends as well I suppose
#so lets do that

var buffer : Array[Hit]

func enter(args ={}):
	super.enter(args)
	buffer = []

	

func CheckIfHitInBufferZone(hit:Hit):
	print(startTime + duration)
	#so if the hit time is less than the window 
	
	if CheckIfInBufferZone(hit.time):
		buffer.append(hit)
	

func HandleHit(hit):
	CheckIfHitInBufferZone(hit)
