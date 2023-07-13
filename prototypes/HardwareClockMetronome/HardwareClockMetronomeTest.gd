extends Node


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
