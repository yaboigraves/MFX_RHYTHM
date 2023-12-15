class_name VersusMode
extends GameMode

signal CurrentRoundStarted(current_round:Round)

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis
@export var player1 : Player
@export var player2 : Player

#ok lets just build this like literally from the actual phases I want to happen
#so we probably DO want a state machine for this shit
#first thing we're going to do is launch in with a loading screen actually
#I should be able to skip this easily but lets just like, actually do it to start
#so this is assuming you've already set all your data and hit the button
#a screen wipe will happen, so we will start with a black screen
#lets start by having a period where that screen is active (x seconds)
#we DO want a state machine for this






func Start(offensePlayer = player1, defensePlayer = player2):

	print("start dat thing")


	$GameModeStateMachine.transition_to("Intro")
	

	

	





