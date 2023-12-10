class_name VersusMode
extends GameMode

#ok so we got basic functionality
#lets rewrite player handling so i can actually just play against myself
#windows will be harsh thats fine, maybe just add a buffer
#honestly I just wanna add that buffer yea

signal CurrentRoundStarted(current_round:Round)

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis
@export var player1 : Player
@export var player2 : Player

var current_round: Round


func Start():
	current_round = Round.new($GameModeStateMachine, player1,player2,debugStream)
	current_round.Start()
	CurrentRoundStarted.emit(current_round)
	
	await current_round.RoundEnded
	
	Start()
	
	

func Quit():
	print("this is where we would quit")
	



