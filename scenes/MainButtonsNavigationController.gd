extends VBoxContainer

#so anytime one of these buttons is preses
#we want to create a mutually exclusive set of values


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("comeIn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_multi_player_2_toggled(button_pressed: bool) -> void:
	pass # Replace with function body.
