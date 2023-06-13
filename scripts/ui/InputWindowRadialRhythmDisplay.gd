class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

#this is all kind of weird and all
#honestly I think all of this is really roundabout now that I code it out
#we should just move the code for this into the player state machine ngl
#yeah im kind of unhappy with this
#it was a decent afternoon of experimentation though
#so tldr, the metronome refactor is good
#we should just really drive the ui steering from the player state machine
#the player can get an injection of a ref to the metronome
#we're good to go
#this UI shouldn't do any update shit like that

#ok so a BUNCH of this code is obfuscated as hell now
#this ought to get bound to a player and the player steers it

#


@export var rules: GameModeRules
@export var markerColors: Array[Color]
@export var radialMetronomeDot : PackedScene
@export var hitParticleSystem : PackedScene
@export var currentPhaseProgressVar : FloatVariable

@export var metronome:Metronome
@export var playerGameState: GameState

var metronomeDots = []

var inputWindowViews:Array[InputWindowView] = [] 

#obselete in a moment
var hitParticleSystems = []

var markerHitMap: Dictionary

var stateTextMap = {
	"IdleState": "WAIT",
	"RecordState":"REC",
	"VerifyState":"PLAY"
}

func HandleCurrentPhaseProgressChanged():
	print(currentPhaseProgressVar.Value)





#this maybe ought to be seperated to like an autoload utilities func or something
func CreateArcSection(index = 1, color = Color.DARK_GOLDENROD, outlineWidth = 10, alpha = 0.5):
	
	var poly = OutlinedPolygon2D.new()
	poly.outlineWidth = outlineWidth
	poly.color = color
	poly.color.a = alpha
	var windowSizeRadians = 2 * (PI) * (rules.windowSize/beatsPerRotation)

	var topBound = origin.rotated(-windowSizeRadians/2.0)
	var bottomBound = origin.rotated(windowSizeRadians/2.0)
	
	var closeMult =  (startDist + (laneMargins/2.0) + (index * laneSize))
	var farMult = (startDist + (laneMargins/-2.0)+ (laneSize) + (index * laneSize))

	var arcRadius = 1
	#so rotate by 5 multiples of that dif from 0 the actual max
	var arcSizeDelta = windowSizeRadians/(2.0 * arcRadius)
	
	var rotationMax = windowSizeRadians/2.0
	
	var arcPoints = []


#	for i in range(arcRadius):
#		arcPoints.append((origin.rotated(rotationMax - (i * arcSizeDelta))   ) * closeMult)


	#so maybe to start here we just figure out the tween for this value

	#top right
	arcPoints.append(origin.rotated((rotationMax)) * closeMult)
	poly.topIndexes.append(0)
	poly.topIndexes.append(5)
	
	poly.bottomIndexes.append(2)
	poly.bottomIndexes.append(3)
	
	
	
	#..top close values

	#middle right
	arcPoints.append(origin * closeMult)
	
	#...bottom close values
	
	#bottom right
	arcPoints.append(origin.rotated((-rotationMax)) * closeMult)
	
	
	#bottom left
	arcPoints.append(origin.rotated((-rotationMax)) * farMult)
	
	#...far bottom details
	
	#middle left
	arcPoints.append(origin * farMult)
	
	#...far top details
	
	arcPoints.append(origin.rotated((rotationMax)) * farMult)

	poly.set_polygon(arcPoints)
	
	return poly

func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()	
	DrawInputWindows()
	#make metronome a resource!!
	metronome.Tick.connect(_on_metronome_tick)
	currentPhaseProgressVar.OnValueChanged.connect(HandleCurrentPhaseProgressChanged)

#debug
func DrawBadZone():
	var windowSizeRadians = 2 * (PI) * (rules.badZoneSize/beatsPerRotation)
	var line = Line2D.new()
	var edge = Vector2(-500,0)
	edge = edge.rotated(-windowSizeRadians)
	line.points = [Vector2(0,0), edge]	
	%CenterPivot/LineRenderers.add_child(line)


func DrawInputWindows():
	var windowSizeRadians = 2 * (PI) * (rules.windowSize/beatsPerRotation)
	for index in range(numLanes):
		var shape = CreateArcSection(index, markerColors[index])
		
		var pSystem = hitParticleSystem.instantiate()
		shape.add_child(pSystem)
		var closeMult =  (startDist + (laneSize/2.0) + (index * laneSize))
		pSystem.position = origin * closeMult
		
		var inputWindowView =  InputWindowView.new(index,shape,pSystem)
		inputWindowViews.append(inputWindowView)
		
		%InputWindows.add_child(inputWindowView.shape)
	

	
func SpawnMarker(hit:Hit):
	var indexPos = (numLanes - 1) - hit.laneIndex
	var shape = CreateArcSection(indexPos, markerColors[indexPos])
	%Markers.add_child(shape)
	
	markers.append(shape)
	markerHitMap[hit] = shape

	
func _on_metronome_tick(timeSeconds, timeBeats) -> void:
#	%Markers.rotation =  origin.angle() + ((timeBeats * PI)/(beatsPerRotation/2.0))
	for hit in markerHitMap.keys():
		markerHitMap[hit].rotation = ((timeBeats - hit.time )/ beatsPerRotation) * 2 * PI
	
	$RecordOverlay.value = metronome.currentGameState.progress * 100
		
func ClearAllMarkers():
	super.ClearAllMarkers()
	markerHitMap.clear()
	
#===DEBUG===

func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()

func _on_record_state_spawn_marker(hit:Hit) -> void:
	SpawnMarker(hit)
	
func _on_verify_state_missed_hit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1) -hit.laneIndex) * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"miss")
	markerHitMap[hit].queue_free()
	markerHitMap[hit].modulate = Color(1,1,1,0.25)
	markerHitMap.erase(hit)


func OnHitProcessed(hit, hitResult) -> void:
	match hitResult:
		HitResult.GOOD:
			onGoodHit(hit)
		HitResult.MISS:		
			onBadHit(hit)
		HitResult.DESTROY_MISS:
			onDestroyMiss(hit)

#honestly each input window could contain its own feedback text spawner


func onBadHit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"oops")

func onGoodHit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"nice")
	markerHitMap[hit].queue_free()
	markers.erase(markerHitMap[hit])
	markerHitMap.erase(hit)
	inputWindowViews[3 - hit.laneIndex].particleSystem.restart()
	inputWindowViews[3-hit.laneIndex].HandleGoodHit()

func onDestroyMiss(hit):
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	%FeedbackTextSpawner.SpawnHit(pivotPos,"miss")
	markerHitMap[hit].queue_free()
	markers.erase(markerHitMap[hit])
	markerHitMap.erase(hit)




