class_name VersusMode
extends GameMode

#yeah so honestly, i want more high level phasing
#I wanna be able to create like sequences
#each sequence can have its own section
#so I think the first thing to do is rewrite the phasing logic a bit?
#yeah like I kinda wanna just rewrite this more or less from scratch
#the code is just kinda overcomplex, I want a better standardized manager
#lets be super explicit and start from scratch more or less
#so the first thing we're gonna do in versus mode is start a round
#rounds are gameplay wrappers for audio playback


#ok so to bring this all back
#what does mvp look like
#auto printing for phasing
#random verification pass/fail

#for now assume 2 players
#have rounds trigger audi

#kinda need a debug panel
#we should listen to signals from the round here to dispatch stuff

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
	

#	HardwareClockMetronome.instance.PlayStream(debugStream)
#
#	#audio has started, player 1 is on offense
#	#wait 4 beats then do something
#
#	#let the player1 start recording
#	HardwareClockMetronome.instance.AddCallback(func(): print("p1 records here"+ str(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())), 8 )
#	HardwareClockMetronome.instance.AddCallback(func(): print("p1 verifies here" + str(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())), 16 )
#	HardwareClockMetronome.instance.AddCallback(func(): print("p2 defends/steals here" + str(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())), 24 )
#	HardwareClockMetronome.instance.AddCallback(func(): print("Round is over" + str(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())), 32 )
#
	
func _process(delta: float) -> void:
	pass
	current_round._process(delta)

func Quit():
	print("this is where we would quit")
	



