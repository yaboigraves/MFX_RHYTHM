class_name VersusMode
extends GameMode

#so versus mode is a bit more complicated

var gameStateHistory : Array[GameState]

var currentGameState : GameState

var stateMachine : StateMachine

#ok so basically when we start a battle we wanna do a sample lead in
#present both players with what theyll be drumming to
#countdown will annoy me though just add it later
#so the flow is 

#we start off by showing both players the sample they're playing
#this is the "listen phase"

#players should basically just be able to make their little dudes fuck around

#I think we ought to like, bake durations into these phases maybe
#it would be really nice to just be able to plug in a duration
#then the state just ties in...

#audio should maybe like start and stop too?
#lets try and fuck around with that here
#I dont really want to refactor this too much
#keeping a core clock is probably a bad idea too
#so, can we do seamlesss audio playback like that?

#


func Start():
	stateMachine = $VersusModeStateMachine as StateMachine
	stateMachine.StartMachine()

func Quit():
	print("this is where we would quit")
	



