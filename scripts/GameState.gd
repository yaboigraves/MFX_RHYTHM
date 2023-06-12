class_name GameState
extends Resource



#@export var currentTime : float
@export var lengthInBeats: int = 4
@export var startTime : float
var endTime: float
var progress : float
var currentTime : float


var recordedHits = [
	[],
	[],
	[],
	[]
]

func StartCurrentState(time:float):
	progress = 0
	startTime = time 
	endTime = startTime + lengthInBeats
	

func _process(timeInBeats):
	currentTime = timeInBeats
	progress = (timeInBeats - startTime )/ lengthInBeats

func GenerateSnapshot() -> GameStateSnapshot:
	var snapshot = GameStateSnapshot.new(lengthInBeats,recordedHits)
	return snapshot
