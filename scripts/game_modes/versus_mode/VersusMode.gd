class_name VersusMode
extends GameMode

#ok lets refactor the big kahuna now

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis

#game mode doesnt care about this, get it from player manager
@export var player1 : Player
@export var player2 : Player

#var currentRound: Round

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
	



