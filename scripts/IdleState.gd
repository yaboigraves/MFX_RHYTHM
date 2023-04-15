extends PlayerInputState

var buffer : Array[Hit]


#so idle state still seems to consume hits incorrectly :/ 
#I think a buffer in the idle state might actually be a good idea
#perhaps allowing you to immedieatly switch to the record state would be good?
#so maybe this is an issue of feedback honestly
#I might just be bad at the game lol

func enter(args ={}):
	super.enter(args)
	buffer = []


#TODO: this zone should spawn empotes on your character head
func HandleHit(hit):
	pass
