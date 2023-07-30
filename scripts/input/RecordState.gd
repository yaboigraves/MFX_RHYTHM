class_name RecordState
extends PlayerInputState

var buffer : Array[Hit]


var recordedHits = []

func initialize():
	super.initialize()

func enter(_msg = {}):
	super.enter()
	recordedHits = [[],[],[],[]]

func HasAnyHits():
	for hitLane in recordedHits:
		if hitLane.size() > 0:
			return true
	return false

func update(_delta):
	super.update(_delta)


func HandleHit(index, timeInBeats):
	var hit = Hit.new(index,timeInBeats,0,HitType.RECORD,self)
	recordedHits[hit.laneIndex].append(hit)
	
	player.HitRecorded.emit(hit)
	Goodhit.emit(hit)

func _on_input_spoofer_spoof_hit(lane, time) -> void:
	HandleHit(lane,time)
