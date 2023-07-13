extends Node

#@export var display : RhythmDisplay

#signal RecordedHit
#signal SpawnHit(index,timeInBeats)

func _ready() -> void:
	$GameModeManager.StartGame()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
		
