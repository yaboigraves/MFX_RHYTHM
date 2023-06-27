class_name BattleAudioManager
extends Node

@export var metronome : Metronome

#so we want to basically when the game starts get notified by the metronome
func _ready() -> void:
	set_process(false)
	print(metronome)
	$AudioStreamPlayer.stream = metronome.stream


func PlayBackgroundTrack():
	metronome.Start()
	set_process(true)
	$AudioStreamPlayer.play()


func _process(delta: float) -> void:
	metronome.calculateTime()

