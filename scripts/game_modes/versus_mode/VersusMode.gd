class_name VersusMode
extends GameMode


var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis

@export var player1 : Player
@export var player2 : Player

var currentRound: Round

func Start():

	stateMachine = $RhythmStateMachine as RhythmStateMachine
	currentRound = Round.new(player1,player2)
	
	#set the offense player, all other players are defense
	#we really want to like, have starting a new bout be a function I think though
	#just do it here for now
	
	StartBout(player1,player2)
	
	
	stateMachine.AddStateResolutionListener(ResolveNextState)


func StartBout(offensePlayer,defensePlayer):
	blackboard.offensePlayer = offensePlayer
	blackboard.defensePlayer = defensePlayer
	HardwareClockMetronome.instance.PlayStream(debugStream)
	stateMachine.transition_to("Listen")


func ResolveNextState():
	var endingState = stateMachine.state as RhythmState

	currentRound.UpdateRoundState(endingState)
	
	if endingState is ListenRhythmState:
		ListenResolveNextState()
	elif endingState is RecordRhythmState:
		RecordResolveNextState()
	elif endingState is VerifyRhythmState:
		VerifyResolveNextState()


func ListenResolveNextState():
	if not currentRound.roundPatternRecorded:
		stateMachine.transition_to("Record", {"round": currentRound})
	


func RecordResolveNextState():
	stateMachine.transition_to("Verify", {"round": currentRound})

func VerifyResolveNextState():
	#so we're for sure going into listen
	if !currentRound.defendingPlayerVerified and currentRound.roundPatternVerified:
		#go into a double verify for the defending player
		stateMachine.transition_to("Verify", {"round" : currentRound})

	elif currentRound.defendingPlayerVerified or (currentRound.roundPatternRecorded and currentRound.verificationFailed):
		currentRound.defendingPlayer.ResetUI()
		currentRound.recordingPlayer.ResetUI()
		#we're resetting and going back to listen with the defending player being the offense player now
		currentRound = Round.new(currentRound.defendingPlayer, currentRound.recordingPlayer)
		
		stateMachine.transition_to("Listen", {"round": currentRound})
		
	
func Quit():
	print("this is where we would quit")
	



