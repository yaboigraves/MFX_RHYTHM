extends Node

#i will allow myself terriblle note taking comments here as its a test bed
#so the first thing we ought to do is be able to even ref this hardware clock
#i really want to try an async thing here, so maybe we make an object for a state instance that can spawn
#RhythmStateInstance class that represents the actual data we're going to stamp, probably smarter


func _ready() -> void:
	print(HardwareClockMetronome.instance)
	
	#so we want to be able to the state machine to start
	#to start the state machine, we go first into the listen state
	#each state has a duration baked in, and the start time is really based on the "headTime" of the metronome
	#so lets just have it read from the static var for that
	#when an instance registers itself as the current state in the metronome, it moves the head forward
	
	$RhythmStateMachine.StartMachine()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
