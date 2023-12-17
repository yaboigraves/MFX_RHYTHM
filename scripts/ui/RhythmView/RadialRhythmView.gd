class_name RadialRhythmView
extends Control

#so this node handles rendering the UI layer that is actually animated
#this means the record, the input window displays, and the stickers

#so to start, I want to re-add my arc section code in but make it more sticker based

#so to start, we need a circle that I can spin
#I want to be able to make lanes and outlines later too

#so we start by just spinning that child


#so we need to just initially read the size of this square
#the size may be effected by the scale lemme look


func _ready() -> void:
	
	print(size)


func _process(delta: float) -> void:
	$TextureRect.rotation += delta


	
