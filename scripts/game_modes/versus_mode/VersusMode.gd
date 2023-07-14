class_name VersusMode
extends GameMode


var gameStateHistory : Array[GameState]

var currentGameState : GameState

var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis

@export var player1 : Player
@export var player2 : Player

var currentOffensePlayer


func Start():

	stateMachine = $RhythmStateMachine as RhythmStateMachine
	
	currentOffensePlayer = player1
	
	HardwareClockMetronome.instance.PlayStream(debugStream)
	
	stateMachine.transition_to("Listen")
	stateMachine.AddStateResolutionListener(ResolveNextState)
	

#ok before I do this we do need to cover all situation
#lets be thoughtful

#so
#we have one more kind of bool
#which players offense state we're in
#so actually, this is state in the player....
#if a player is on offense, we do one thing
#otherwise we do another

#yea and we ought to be able to access the other player from a player maybe..!!
#super assuming 2 players fuck more than that right now
#we can do like crew battles with multiple controllers later

#maybe we always play your hit but give an effect if its wrong like high pass it
#or maybe we just let you go off and like stamp on then compare at the end
#i kind of prefer that ngl
#yeah maybe we give active feedback but just let you do yer thing
#and then we can reward like swing and stuff better
#that makes more sense

#ok so some stuff to think about
#1.maybe we prioritize feedback on your performance (with like horizontal faders for visual flare)
#as a thing that happens after your whole turn, and we never fully fully play an error noise or change like fail state

#2.perhaps player input state ought to know if its in offense or defense state
#so when record states time is up, if the current player is in offense they go to verify
#if verify happens and the current player is offense we go into a listen state for sure
#we may or may not set the offense player to a different player though
#after the listen, we somehow tell the next player whether they go into verify with the data from the last state
#or  they go into record and start the sequence over
#yeah so we really want to do this up here
#and just listen for when states end

#yeah theres some if statement hell to think about here with states
#but thats it ya know
#so yeah in concluision no, states really just tell the player what to do and maintain timings
#we also can trigger UI events later from here that are global
#player can emit their specific UI events

#I really dont want to nest another thing
#yeah versus mode just contains this all
#makes sense

#cool so note 1 do, 
#next todo is to code this thing to resolve the next state


#TODO: actually implement!!
func ResolveNextState():
	var endingState = stateMachine.state as RhythmState
	
	if endingState is ListenRhythmState:
		stateMachine.transition_to("Record", {"player" : currentOffensePlayer})
	elif endingState is RecordRhythmState:
		pass
	elif endingState is VerifyRhythmState:
		pass
	
	

func Quit():
	print("this is where we would quit")
	



