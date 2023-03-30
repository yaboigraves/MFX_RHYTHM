extends Node

@export var defaultCharIcon : Texture
@export var goodCharIcon :Texture
@export var missCharIcon : Texture 
@export var badCharIcon : Texture



func _on_metronome_beat_update(timeInBeats) -> void:
	var tween =create_tween()
	tween.tween_property($Control/VBoxContainer/Pivot/CharacterIcon, "scale", Vector2.ONE * 0.8, %Metronome.spb)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(func() : $Control/VBoxContainer/Pivot/CharacterIcon.scale = Vector2.ONE)

func _on_verify_state_bad_hit(hit) -> void:
	$Control/VBoxContainer/Pivot/CharacterIcon.texture = badCharIcon
	$CharResetTimer.start()

func _on_verify_state_good_hit(hit) -> void:
	$Control/VBoxContainer/Pivot/CharacterIcon.texture = goodCharIcon
	$CharResetTimer.start()
	
func _on_verify_state_missed_hit(hit) -> void:
	$Control/VBoxContainer/Pivot/CharacterIcon.texture = missCharIcon
	$CharResetTimer.start()

func _on_char_reset_timer_timeout() -> void:
	$Control/VBoxContainer/Pivot/CharacterIcon.texture = defaultCharIcon


func _on_verify_state_combo_update(combo) -> void:
	if(combo > 0):
		$Control/ComboText.visible = true
		$Control/ComboText.text = '\n' + str(combo)
	else:
		$Control/ComboText.visible = false
