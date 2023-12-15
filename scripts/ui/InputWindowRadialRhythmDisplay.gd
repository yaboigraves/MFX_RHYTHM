class_name InputWidnowRadialRhythmDisplay
extends RadialRhythmDisplay

#lets tackle this rework from the ground up
#so we still want our dynamically drawn lanes thing
#we want to be able to construct it better though
#lets go for a vector art style thing for now, try some stuff a bit later
#i gotta just doodle this out or something or box it out



#super fugly, needs to be re-worked

@export var rules: GameModeRules
@export var markerColors: Array[Color]

@export var hitParticleSystem : PackedScene
@export var currentPhaseProgressVar : FloatVariable

@export var metronome:Metronome
@export var player:Player

var phaseView : PhaseView
var inputWindowViews:Array[InputWindowView] = [] 

#obselete in a moment
var hitParticleSystems = []

var markerHitMap: Dictionary

var stateTextMap = {
	"IdleState": "WAIT",
	"RecordState":"REC",
	"VerifyState":"PLAY"
}

func _ready():
	beatsPerRotation = rules.loopBeatSize
	super._ready()	
	DrawInputWindows()
	metronome.Tick.connect(_on_metronome_tick)
	RefreshOverlaySize()
	RefreshCenterLabelSize()
	phaseView = $Backplate/Plate/PhaseView as PhaseView
	
	player.RecordStateProgressUpdate.connect(SetRecordStateProgressRadial)
	player.VerifyStateProgressUpdate.connect(SetVerifyStateProgressRadial)
	
	player.HitProcessed.connect(OnHitProcessed)
	player.HitRecorded.connect(SpawnMarker)
	set_process(false)

#this has wayyyy too many responsibilities too
#so a refactor of this is well in order
#for now lets just get it working again with the new core drivers


func ToggleRotation(toggle: bool):
	set_process(toggle)


#so this rotation is fucked up
#technically, i think we're working
#come back to this we're gonna refactor it anyways
func _process(delta: float) -> void:
	var timeBeats = HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats()
	
	#new
	$CenterPivot/Markers.rotation = ( fposmod(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats(), 8.0))  * (PI/ 4.0) 
	
	#old
#	for hit in markerHitMap.keys():
#		markerHitMap[hit].rotation = ((timeBeats - hit.time )/ beatsPerRotation) * 2 * PI



func HandleStateStart(state):
	phaseView.SetPhase(state)


	
func RefreshCenterLabelSize():
	$CenterPivot/RecordCenterLabel.size = size * centerOffset
	#so this is kind of annoying math but it works I guess?	
	$CenterPivot/RecordCenterLabel.position = ($CenterPivot.size /2.0) - $CenterPivot/RecordCenterLabel.size/2.0

func RefreshOverlaySize():
	$VerifyOverlay.size = size * centerOffset
	#so this is kind of annoying math but it works I guess?	
	$VerifyOverlay.position = (size /2.0) - $VerifyOverlay.size/2.0
	


#TODO: these progress values should maybe actually literally be offset I think
#that or we slightly rotate the whole thing?
#we have a slight conflict in the ordering here
#the record overlay needs to be under this?
#soo...
#hm
#we can fix this with proper z indexing i guess



#so the order is 
#background (rim) 0
#lanes and lane lines 1
#record overlay 2
#center label background 3
#verify overlay 4
#center spoke and text 5
#markers 6

func SetRecordStateProgressRadial(progress):
	$RecordOverlay.value = progress * 100.0

func SetVerifyStateProgressRadial(progress):
	$VerifyOverlay.value = progress * 100.0



#TODO: make it so we can draw just on the top and bottom too
#thats actually really smarttt

#ok so lets first just get them overlapping at all
#then make it so we can control the sides that the outlines get put on
#that way we c an have you record with just like, sideways ones
#also we can use like ++, + , o, -, -- and stamp that inside too
#doesnt have to be NICE
#less localization

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
	

#so maybe what this does instead is spawns an unoutline alpha faded version
func SpawnMarker(hit:Hit):
	
	var indexPos = (numLanes - 1) - hit.laneIndex
	inputWindowViews[3-hit.laneIndex].HandleGoodHit()
	var a = 0.1
	if hit.state is VerifyState:
		a = 1
	
		
	var shape = CreateArcSection(indexPos, markerColors[indexPos],6,a)
	%Markers.add_child(shape)
	
	markers.append(shape)
	
	shape.rotation -= (hit.time) * (PI/4.0)
	markerHitMap[hit] = shape


#so this should be just like, a process function I suppose


		
func ClearAllMarkers():
	super.ClearAllMarkers()
	markerHitMap.clear()
	
#===DEBUG===

func _on_player_input_handler_escape() -> void:
	ClearAllMarkers()

#ahh yeah so we're killing state stuff here
#which 
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


#ok lets change this up
#so instead of destroying a hit
#so if you miss one I guess we can make it a miss color
#like black or something


func onGoodHit(hit) -> void:
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	#%FeedbackTextSpawner.SpawnHit(pivotPos,"nice")

	SpawnMarker(hit)

	inputWindowViews[3 - hit.laneIndex].particleSystem.restart()




#so this is less of a destroy miss
#lets just like, put a red x over it
#TODO of course
func onDestroyMiss(hit):
	var pivotPos =  %InputWindows.global_position +  (Vector2((startDist + (laneSize * 0.5) + (((numLanes -1)- hit.laneIndex)  * laneSize )),0)).rotated(origin.angle())
	

	%FeedbackTextSpawner.SpawnHit(pivotPos,"miss")
	#our handling of all this is bad fix later
	if markerHitMap.has(hit):
		markerHitMap[hit].queue_free()
		markers.erase(markerHitMap[hit])
		markerHitMap.erase(hit)


