class_name LabMode
extends GameMode


var gameStateHistory : Array[GameState]

var currentGameState : GameState


var stateMachine : StateMachine


func Start():
	stateMachine = $LabModeStateMachine as StateMachine
	stateMachine.StartMachine()

