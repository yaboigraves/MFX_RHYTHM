class_name RecordState
extends PlayerInputState


func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats,0,HitType.RECORD,self)
	
	#the blackboard is probably fine to still write to
	Blackboard.Instance.recordedPattern[hit.laneIndex].append(hit)

	player.HitRecorded.emit(hit)
	Goodhit.emit(hit)

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	HandleHit(lane,time)
