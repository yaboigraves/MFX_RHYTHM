extends Node


#game ideas 
#1. free loop mode, just make and edit loops 
#2. one at a time (or X at a time mode)
	#players go back and forth adding x beats to the loop
	#whoever cant do it after adding a beat loses
#3. skate/horse mode (self explanitory original idea)

#cool so overall we just need to tie in from some gameplay rules
#lets make a resource for that that we can just load and plug into
#we can get stuff like input window size, num beats, etc
#gamemoderules

#so the main main todos here are to handle the weirdness that can handle by doing slightly early inputs
#i think technically, we ought to allow input in the idle state right near the end as a beggining of an input
#same with the end of the record state, if you do an input and its like super close to a target hit, we should just kind of switch the mode pre-emptively
#so technically there's like a buffer area thats the size of the window input BEFORE the phase starts technically

#we dont want to trigger anything neccessarily, just buffer I guess
#we could also technically start the mode early, but that seems bad to me
#better to just open the window ON hit being received rather than doing it in state
#the window might be small or not needed

#so to start lets make it so that hits at the very end of the idle state can be buffered, or at least can count towards a record state

#ok so some rough ideas are sketched out but I REALLY need a way to inject test code in
#so lets do this, lets be smart and make an input spoofer that will just spawn hits

#4/9
#there appears to be a good deal of refuse accumulated in this codebase 
#phases look decent
#I think what really ought to be done today is proper testing of input windows
#so lets do that
#create a test case that has a miss in it first

#ok overall this buffer system fuckin sucks
#honestly, input starts at the 0, but ends when the new input window starts
#you're never going to want to do a fresh input at the start of a record phase
#it's just not a thing you do in this game
#so lets just switch phases earlier, and deal with the fallout
#completly cut this bs buffer system out
#ay ok that was way simple than i thought

#so now all that needs to be done is create the "bad window"
#this is when you do a hit thats close to the input, but enough to actually cancel out an input in that lane
#if you do an input and any hits are in the dead zone, you miss
#we want to encourage people swinging though so careful
#this should just be a way to penalize full on mistimes
#I guess another approach, is to close input for a brief period after missing
#that feels bad though
#yeah just check a threshold
#lets assume its outside the window * 2
#the fucked bit, is that this CAN occur before a phase starts
#i guess that counts as an input then though
#so thats a different kind of mistake
#assume thats fine
#so this exists only in the verify state

#so when we check a hit, see if its within that extra bad threshold
#this is to prevent spamming mainly

#some characters can maybe open extra bonus windows offset
#thats a cool idea
#maybe a swing character?
#anyways, lets first do some project cleanup
#lotta commented code

#honestly just have the radial ui exist in all the scenes too it'll be easier to connect to ui endpoints in game code then

#this can handle the menu shit later too

#audio is a pretty big concern
#we def want a core audio engine

@export var display : RhythmDisplay

signal RecordedHit

signal SpawnHit(index,timeInBeats)
 
@export var event : EventAsset

func _ready() -> void:
	$GameModeManager.StartGame()
	RuntimeManager.play_one_shot(event,self)
	

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
		
