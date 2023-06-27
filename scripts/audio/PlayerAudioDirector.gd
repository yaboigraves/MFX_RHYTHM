class_name PlayerAudioDirector
extends Node


func _on_record_state_hit_processed(hit:Hit, hitResult) -> void:
	$DrumsAudio.get_child(hit.laneIndex).play()

#we should make some cringe audio at some point
func _on_verify_state_hit_processed(hit, hitResult) -> void:
	match hitResult:
		HitResult.GOOD:
			$DrumsAudio.get_child(hit.laneIndex).play()


func _on_record_state_goodhit(hit) -> void:
	$DrumsAudio.get_child(hit.laneIndex).play()


func _on_verify_state_goodhit(hit) -> void:
	$DrumsAudio.get_child(hit.laneIndex).play()
