extends PlayerInputState


#if it is in the buffer zone, we add it to the buffer for when the record mode starts
#it can be passed as an arg into the state
func CheckIfHitInBufferZone(hit):
	
	print(progress/duration)


func HandleHit(hit):
	CheckIfHitInBufferZone(hit)
