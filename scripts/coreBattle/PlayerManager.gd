class_name PlayerManager
extends Node
static var Instance 
var currentOffensePlayer : Player


func _init() -> void:
	Instance = self

func _ready() -> void:
	currentOffensePlayer = $Player1 as Player

func GetAllPlayers() -> Array:
	return get_children() as Array[Player]

func GetPlayer(playerIndex : int) -> Player:
	return get_child(playerIndex) as Player

func GetCurrentOffensePlayer():
	return currentOffensePlayer
