class_name VersusMode
extends GameMode

#what if the states are like super literal actually
#that might be way smarter
#like offenseRecord,offenseVerify,defense
#lets make another one called defense
#nahhhh this is still broken
#FUCK
#i really just need to rethink this a bit

#lowkey I think the rhythm state machine is a bit of a failed experiment
#input might just always be open



var stateMachine : RhythmStateMachine

@export var debugStream : AudioStreamOggVorbis

@export var player1 : Player
@export var player2 : Player


func Start():
	stateMachine = $RhythmStateMachine as RhythmStateMachine
	StartBout(player1,player2)
	
func StartBout(offensePlayer,defensePlayer):
	blackboard.offensePlayer = offensePlayer
	blackboard.defensePlayer = defensePlayer
	HardwareClockMetronome.instance.PlayStream(debugStream)
	
	stateMachine.transition_to("Record", {"duration": 15.84})
	
func Quit():
	print("this is where we would quit")
	



