class_name GameState
extends RefCounted

#this class can be used to store data about a game and serialize it
#this will be useful for keepign track of current time, holding winner, and so on

var currentTime : float
var lengthInBeats: int

#maybe modes can just store their state?
#and do the polling?
#that might be better than trying this callback shit tbh
#also annoying
#nah the callbakc works
#we ought to be able to change length anyways

#ok so the first thing that can happen is gamestate contains a set of recorded hits

var recordedHits = [
	[],
	[],
	[],
	[]
]


func _init(lengthInBeats: int):
	self.lengthInBeats = lengthInBeats
