extends PlayerInputState

var buffer : Array[Hit]

#idle doesnt auto end or start

func enter(args ={}):
	super.enter(args)
	buffer = []

func HandleHit(hit):
	pass

