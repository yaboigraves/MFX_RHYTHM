class_name VersusMode
extends GameMode

#so versus mode is a bit more complicated

var gameStateHistory : Array[GameState]

var currentGameState : GameState

@export var debugStream : AudioStreamOggVorbis

#so lets start by starting the metronome I suppose yeah
#we kinda just need a script that resolves next state
#this kinda ought to be the like rules thing
#but eh its whatever
#lets just get one basic input phase working

#we gotta rework the UI a bit after this too
#its code is so stinky

func Start():
	#start the stream
	HardwareClockMetronome.instance.PlayStream(debugStream)
	#start the state machine and go into listen mode
	$RhythmStateMachine.StartMachine()



func Quit():
	print("this is where we would quit")
	



