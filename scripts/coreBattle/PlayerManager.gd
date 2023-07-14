
#i actually dont think we neeed a player manager
#like, can the versus mode just store this?

extends Node

var currentOffensePlayer : Player



func _ready() -> void:
	currentOffensePlayer = $Player1 as Player

func GetPlayer(playerIndex : int) -> Player:
	return get_child(playerIndex) as Player

func GetCurrentOffensePlayer():
	return currentOffensePlayer
