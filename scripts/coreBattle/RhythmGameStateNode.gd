class_name RhythmGameStateNode
extends Node

#this node ties in a node to the gamestate for access to the global metronome
#if a metronome isn't found then something has gone horribly wrong

var metronome: Metronome

func _ready() -> void:
	CacheMetronomeRef()

func CacheMetronomeRef():
	metronome = get_node("/root/GameManager/Metronome") as Metronome

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
