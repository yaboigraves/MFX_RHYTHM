class_name GameModeManager
extends Node

enum GameModeType{ LAB_MODE, TRAINING_MODE , VERSUS_MODE}

var gameModeDictionary:Dictionary = {
	GameModeType.LAB_MODE : "res://scenes/gameModes/lab_mode.tscn",
	GameModeType.VERSUS_MODE : "res://scenes/gameModes/versus_mode.tscn"
}

@export var currentGameModeType : GameModeType
@export var metronome : Metronome
var currentGameMode : GameMode



func StartGame():
	LoadGameMode()
	currentGameMode.Start()
	set_process(true)


func LoadGameMode():
	currentGameMode = load(gameModeDictionary[currentGameModeType]).instantiate()
	add_child(currentGameMode)



	
