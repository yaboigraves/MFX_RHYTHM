class_name VersusMode
extends GameMode

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis

@export var player1 : Player
@export var player2 : Player


func Start():
	stateMachine = $RhythmStateMachine as RhythmStateMachine
	StartBout(player1,player2)
	
func StartBout(offensePlayer,defensePlayer):
	blackboard.offensePlayer = offensePlayer
	blackboard.defensePlayer = defensePlayer
	HardwareClockMetronome.instance.PlayStream(debugStream)
	stateMachine.transition_to("Listen")
	
func Quit():
	print("this is where we would quit")
	



