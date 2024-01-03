class_name MainMenuButton
extends Button

var hoverTween:Tween


func _ready() -> void:
	mouse_entered.connect(func():
		if hoverTween: hoverTween.stop()
		
		hoverTween = create_tween()
		hoverTween.tween_property(self, "size", Vector2(900,180), 0.1)
	
	)
	
	pressed.connect(func():
		if hoverTween: hoverTween.stop()
	
	)
		
	mouse_exited.connect(func():
		if hoverTween: hoverTween.stop()
		hoverTween = create_tween()
		hoverTween.tween_property(self, "size", Vector2(767,180), 0.1)
	
		
	)
		
		
