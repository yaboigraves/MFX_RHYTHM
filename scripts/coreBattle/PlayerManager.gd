extends Node

#so this just like loads player profiles and helps us dispatch players i guess
#might be unneccsary but whatever

func GetPlayer(playerIndex : int) -> Player:
	return get_child(playerIndex) as Player
