class_name GameManager
extends Node

@export var launchDebugBattle = true

func _ready() -> void:
	if launchDebugBattle:
		$GameModeManager.StartGame()
	else:
		$MfxLogo.DoFade()
		await $MfxLogo.LogoDropDone
		$MainMenu.visible = true
		
	
	$MainMenu.VersusModeSelected.connect(func():
		$MainMenu.visible = false
		$CharacterSelect.visible = true
	)
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
		
