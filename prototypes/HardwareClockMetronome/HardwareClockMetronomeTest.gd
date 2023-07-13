extends Node
#ok so this is basically ready afaik for implementation
#the idea is refactor quite a bit of the core battle logic to be steered by this

#we'll see how spicy that ends up being, but yeah lets go for it

#remember model view controller blah blah blah
#input state machines can transition based on these now!


@export var stream:AudioStreamOggVorbis
@export var nextStream:AudioStreamOggVorbis
func _ready() -> void:
	
	$HardwareClockMetronome.PlayStream(stream)
	$RhythmStateMachine.StartMachine()

	#what do we do when a track is done?
	$HardwareClockMetronome.CurrentTrackDone.connect(func():
		print("starting new sequence of thingy")
		$HardwareClockMetronome.PlayStream(nextStream)
		$RhythmStateMachine.transition_to("Listen")
		)
