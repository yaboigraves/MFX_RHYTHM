
#obselete I think

extends Node

var currentOffensePlayer : Player



func _ready() -> void:
	currentOffensePlayer = $Player1 as Player

func GetPlayer(playerIndex : int) -> Player:
	return get_child(playerIndex) as Player

func GetCurrentOffensePlayer():
	return currentOffensePlayer
