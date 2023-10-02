class_name VersusMode
extends GameMode

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis
@export var player1 : Player
@export var player2 : Player

var current_round: Round


func Start():
	#stateMachine = $GameModeStateMachine as RhythmStateMachine
#	StartBout(player1,player2)
	
	#TODO: create a round, tell the round to start
	current_round = Round.new($GameModeStateMachine, player1,player2,debugStream)
	current_round.Start()
	
	
#
#func StartBout(offensePlayer,defensePlayer):
#	blackboard.offensePlayer = offensePlayer
#	blackboard.defensePlayer = defensePlayer
#	HardwareClockMetronome.instance.PlayStream(debugStream)
#
#	stateMachine.transition_to("Record", {"duration": 15.84})

func _process(delta: float) -> void:
	current_round._process(delta)

func Quit():
	print("this is where we would quit")
	



