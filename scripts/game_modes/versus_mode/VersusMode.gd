class_name VersusMode
extends GameMode

#yeah so honestly, i want more high level phasing
#I wanna be able to create like sequences
#each sequence can have its own section


var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis
@export var player1 : Player
@export var player2 : Player

var current_round: Round


func Start():
	current_round = Round.new($GameModeStateMachine, player1,player2,debugStream)
	current_round.Start()
	


func _process(delta: float) -> void:
	current_round._process(delta)

func Quit():
	print("this is where we would quit")
	



