class_name Round
extends RefCounted

#we can just inject refs to the necessary systems here too
#so an mvp of this looks like starting by spawning just an infinite record phase
#we want to basically be able to schedule state machine transitions
#I think the rhythm state machine thing has semi failed cause its actually TOO constrained
#doing control from a higher level than the state machine isnt really possible...
#or is it?
#it kind of is yeah, there's too much black box going on...
#we can still do the actual transition in the state machine but the order to transition I think comes from here
#cause then we know like, when a "ROUND" has started and have an actual useful metric for doing timings
#cause as is there's no way to know in a "bout" or where time is at

var game_mode_state_machine : StateMachine
var recordingPlayer: Player
var defendingPlayer: Player
var stream : AudioStreamOggVorbis


func _init(game_mode_state_machine: StateMachine,recordingPlayer: Player, defendingPlayer :Player, stream : AudioStreamOggVorbis):
	self.game_mode_state_machine = game_mode_state_machine
	self.recordingPlayer = recordingPlayer
	self.defendingPlayer = defendingPlayer
	self.stream = stream


#so we start by looking at the audio and constructing timings for things
#timings will really never change dynamically, we're basically always going to do stuff at the same time
#some of these will be pre-determined, some will need to ask the game mode state machine for a response
#I think the UI will just move between "screens" which are basically UI states
#players ought to control their own little record radials
#but the UI state machine will basically be its own thing later
#lets start by playing the sample, and scheduling when recording state starts
#we then will mark a time where the round has started, and then use that to do timings
#so the round does its own scheduling

#so when would this end, well depends how long phases are
#phase length is semi variable, but is mainly based on the stream length iirc
#so one full playback counts as an audio phase
#listen will happen once, then recording

var schedule_test: float

#so i think the old scheduling in the metronome thing will work good again actually
#just schedule a thing, with a callback
#or... rounds do it....

#like I think we can just be way more explicit with this, be declarative with game modes
#its not needed to be THAT flexible right now I really dont care about future modes that much and can always make room later

#listen will actually end early based on input window size




func Start():
	HardwareClockMetronome.instance.PlayStream(stream)
	HardwareClockMetronome.instance.AddCallback(HandleListenEnd, stream.beat_count - (0.125) )
	
	#we want to get the animation for records sliding in working
	#before we go any farther
	#so leave off here

func HandleListenEnd():
	print(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())
	#move the offense player into recording
	#recording writes to the blackboard still which is fine
	
	recordingPlayer.StartRecording()
	
	


#we can probably just use this in the round tbh?
#how is that different from just doing callbacks though?

#rounds only start the core stream once
#the callback thing is honestly the way to go
#yeah damnit hahah
#ok so we build the callback thing again in the metronome
#and then hinge off using that, and pre-scheduling events

func _process(delta):
	#print(HardwareClockMetronome.instance.GetCurrentPlaybackPositionBeats())
	
	pass
