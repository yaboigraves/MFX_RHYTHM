extends Node

#TODO: possibly obselete, if not completly

@export var defaultCharIcon : Texture
@export var goodCharIcon :Texture
@export var missCharIcon : Texture 
@export var badCharIcon : Texture


func _on_metronome_beat_update(timeInBeats) -> void:
	var tween =create_tween()
	tween.tween_property($Control/VBoxContainer/Pivot/CharacterIcon, "scale", Vector2.ONE * 0.8, %Metronome.spb)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(func() : $Control/VBoxContainer/Pivot/CharacterIcon.scale = Vector2.ONE)


func TogglePauseUI(toggle:bool):
	$Control/PauseUI.visible = toggle
	

func onBadHit() -> void:
	$Control/PlayerContainer/Pivot/CharacterIcon.texture = badCharIcon
	$Control/CharResetTimer.start()

func onGoodHit() -> void:
	$Control/PlayerContainer/Pivot/CharacterIcon.texture = goodCharIcon
	$Control/CharResetTimer.start()
	
func onMissHit() -> void:
	$Control/PlayerContainer/Pivot/CharacterIcon.texture = missCharIcon
	$Control/CharResetTimer.start()

func _on_char_reset_timer_timeout() -> void:
	$Control/PlayerContainer/Pivot/CharacterIcon.texture = defaultCharIcon


func _on_verify_state_combo_update(combo) -> void:
	if(combo > 0):
		$Control/ComboText.visible = true
		$Control/ComboText.text = '\n' + str(combo)
	else:
		$Control/ComboText.visible = false


func _on_verify_state_hit_processed(hit, hitResult) -> void:
	match hitResult:
		HitResult.GOOD:
			onGoodHit()
		HitResult.MISS:
			onMissHit()
		HitResult.DESTROY_MISS:
			onBadHit()


#TODO: refactor these to just be connected
func _on_pause_on_enter() -> void:
	TogglePauseUI(true)


func _on_pause_on_exit() -> void:
	TogglePauseUI(false)



func _on_player_1_hit_processed(hit, hitResult) -> void:
		match hitResult:
			HitResult.GOOD:
				onGoodHit()
			HitResult.MISS:		
				onBadHit()
			HitResult.DESTROY_MISS:
				onMissHit()
