class_name BattleRoundState
extends State

#so at the start of a round we're going to begin the playback of the core audio for timing
#we can then schedule all of the transitions and events from here
#state transitions can then be leveraged for other UI stuff scripting etc
#keep all the UI as a global child of this round state i think

#so re-audio
#we need a placeholder easy to access like round data thing
#this can have any outside data in it
#later we will have multiple songs probably or something more complex we read from

@export var roundData : RoundData


func enter(_msg := {}) -> void:
	
	HardwareClockMetronome.instance.AddCallback(func():
		$StateMachine.transition_to("Listen")
		,0)
	
	HardwareClockMetronome.instance.PlayStream(roundData.stream)
	
