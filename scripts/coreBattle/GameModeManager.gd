class_name GameModeManager
extends Node

enum GameModeType{ LAB_MODE, TRAINING_MODE }

var gameModeDictionary:Dictionary = {
	GameModeType.LAB_MODE : "res://scenes/gameModes/lab_mode.tscn"
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


func _process(delta):
	metronome.calculateTime()
