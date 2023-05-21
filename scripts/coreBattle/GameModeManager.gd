class_name GameModeManager
extends Node

enum GameModeType{ LAB_MODE, TRAINING_MODE }

var gameModeDictionary:Dictionary = {
	GameModeType.LAB_MODE : "res://scenes/gameModes/lab_mode.tscn"
}


@export var currentGameModeType : GameModeType


var currentGameMode : GameMode



func StartGame():
	LoadGameMode()
	currentGameMode.Start()


func LoadGameMode():
	currentGameMode = load(gameModeDictionary[currentGameModeType]).instantiate()
	add_child(currentGameMode)

