class_name LabMode
extends GameMode


var stateMachine : StateMachine

func Start():
	stateMachine = $LabModeStateMachine as StateMachine
	stateMachine.StartMachine()

func Quit():
	print("this is where we would quit")
	



