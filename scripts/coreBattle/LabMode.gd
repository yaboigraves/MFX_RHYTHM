class_name LabMode
extends GameMode





#so i think the way lab mode ought to work is we can oscillate between like 
# "free mode"
# and then some drum stuff thats preprogrammed
# it would be cool if you could build stuff to practice against but that can happen later

#being able to pause is also probably necessary
#so yeah at the bat we just let you go into free mode

#so we need a way to get players too
#we really only need to id them by 0 or 1 

#turn queues can kinda be established easily
#its always round robin ish

#so we should basically be able to just like tell a player to enable record, yada yada
#actually before we do that lets translate the scheduling
#so each of these game mode states can handle their own durations
#the game mode can handle like, core battle state i suppose
#we can maintain a history of each game mode in a state instance

#state instances should get bound or something to each state
#they can store absolute start and end times 

#this is kinda awkward actually
#but lets re-use this
var gameStateHistory : Array[GameState]

var currentGameState : GameState

#hmmm
#yeah all the actual logic happens here for scheudling too so this makes sense
#no scheduling logic, states just handle their own pocket dimension
#if we restart and stuff we just renter state to clear the old one
#for combos and what not, that can all be stored better this way
#rather than in the player input states
#yeah that makes more sense for like bouts and what not
#cause there will be a good amount of unique stuff
#and also some repeated shit

var stateMachine : StateMachine


func Start():
	stateMachine = $LabModeStateMachine as StateMachine
	stateMachine.StartMachine()
	
	#so lets get scheduling
	#each state will spawn a game state object, which we use to schedule the next event
	#the scheduling cant be interrupted

#this has no real place, there's no "next phase"
func MoveToNextPhase():
	player.MoveToNextPhase()
	

func _on_metronome_beat_update(timeInBeats) -> void:
	pass # Replace with function body.


func OnGameModeStateEntered() -> void:
	currentGameState = stateMachine.state.currentGameState as GameState
	#cool so we got the current game state
	#lets assume we just want to wait like 8 frames
	#we should be able to like override the standard lengths
	#but lets just use the overrides for now
	print(currentGameState.lengthInBeats)
	#so once the game mode is started, queue its callback to resolve next state
	#this oughtta be base game mode
	
	#yeah yeah
	
	#emit_signal("BeatPhaseCallback",stateMachine.state.duration ,MoveToNextPhase, true)
	#metronome._on_player_beat_phase_callback(currentGameState.lengthInBeats, EvaluateNextState, true)
	
	#im kinda stressin myself out over this
	#ought to relax a bit this is good for now take a break


func EvaluateNextState():
	print("hah!!")
