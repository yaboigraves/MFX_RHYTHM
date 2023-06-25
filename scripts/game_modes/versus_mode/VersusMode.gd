class_name VersusMode
extends GameMode

var gameStateHistory : Array[GameState]

var currentGameState : GameState

var stateMachine : StateMachine

func Start():
	stateMachine = $VersusModeStateMachine as StateMachine
	stateMachine.StartMachine()

func Quit():
	print("this is where we would quit")
	



