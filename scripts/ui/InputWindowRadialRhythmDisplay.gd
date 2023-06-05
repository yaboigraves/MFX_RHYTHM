class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

#OK
#so
#some things just really ought to be either nodes or objects
#particularly, hit indicators
#as well, the pivot is kind of awkward, but hit indicators ought to be their own thing first
#mainly because then the particle systems can be managed by them, as well as the eventual pulse
#the indexing is super fucked on them too so we can create a hand made system for that
#they technically could be nodes but everything is established in the context of the actual radial
#so probably just ref counted things to aggregate responsibilities for this to do

#ok so this needs some love
#ui feedback is really lacking overall so I just want to spend some time on that
#we also need a good way to dynamically change length which i dont think works with scheduling right now

#I think we probably need to work on that really quick

#so first thing that would be great would be some pulse
#that is going to be a tricky thing to do but its def worth
#that and particle systems for each hit

#lets do the particle system bit

#yeah so I think what this really needs is just some clearer divisions of labor
#we do seem to have some like "entities" that are repeated
#namely
#markers (the ui side)
#and hit zones (the ui side)
#these ought to kind of be seperated out from the rest of the ui, though maybe lanes could be this way too
#They really OUGHT to be


@export var rules: GameModeRules
@export var markerColors: Array[Color]
@export var radialMetronomeDot : PackedScene
@export var hitParticleSystem : PackedScene
@onready var metronome:Metronome = get_node("/root/GameManager/Metronome") as Metronome


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

	var arcRadius = 22
	#so rotate by 5 multiples of that dif from 0 the actual max
	var arcSizeDelta = windowSizeRadians/(2.0 * arcRadius)
	
	var rotationMax = windowSizeRadians/2.0
	
	var arcPoints = []

	#so as we do this, we want to keep track of what indexes are on what side
	
	var pointIndex = 0
	#ok yea so this doesnt work the way i think it does!
	#gotta pick this up a little later im too small brain for this rn
	
	#so this is actually a top index yeah?
	for i in range(arcRadius):
		arcPoints.append((origin.rotated(rotationMax - (i * arcSizeDelta))   ) * closeMult)
		poly.topIndexes.append(pointIndex)
		pointIndex += 1
	
	#skip
#	arcPoints.append(origin * closeMult)
	
	for i in range(arcRadius + 1):
		arcPoints.append((origin.rotated( -(i * arcSizeDelta))   ) * closeMult)
		poly.bottomIndexes.append(pointIndex)
		pointIndex+= 1
	
	for i in range(arcRadius + 1, 0, -1):
		arcPoints.append((origin.rotated( -(i * arcSizeDelta))   ) * farMult)
		poly.bottomIndexes.append(pointIndex)
		pointIndex += 1
		
#	arcPoints.append(origin * farMult)
	
	for i in range(0,arcRadius + 1):
		arcPoints.append((origin.rotated( (i * arcSizeDelta))   ) * farMult)
		poly.topIndexes.append(pointIndex)
		pointIndex+= 1

	var points: PackedVector2Array = arcPoints	

	poly.set_polygon(points)
	
	return poly

func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()	
	DrawInputWindows()
	metronome.Tick.connect(_on_metronome_tick)


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
		
		var inputWindowView = InputWindowView.new(index,shape,pSystem)
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


func _on_verify_state_hit_processed(hit, hitResult) -> void:
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


