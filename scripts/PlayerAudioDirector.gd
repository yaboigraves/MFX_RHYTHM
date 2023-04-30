class_name PlayerAudioDirector
extends Node

#so base states just know how to send to here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_record_state_hit_processed(hit:Hit, hitResult) -> void:
	$DrumsAudio.get_child(hit.laneIndex).play()


#we should make some cringe audio at some point
func _on_verify_state_hit_processed(hit, hitResult) -> void:
	match hitResult:
		HitResult.GOOD:
			$DrumsAudio.get_child(hit.laneIndex).play()

