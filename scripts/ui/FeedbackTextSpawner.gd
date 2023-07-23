class_name FeedBackTextSpawner
extends Node

#yeah this can get absorbed by the indicators
#the only issue is loading these textures but its not an issue really


#TOCO: Maybe show this above the characters head
#shrink the indicators or pulse them on hits or something

@export var niceTex:Texture
@export var missTex:Texture
@export var oopsTex:Texture
#so this node facilitates the spawning of feedback text images/text
#really any node we're gonna spawn that tweens around then gets cleaned
#for now itll be dumb and not use a pool

#so we have target positions which will just be indexes?
#fow now maybe just spawn them somewhere at an anchor
#set multiple anchors later

@onready var textures = {
	"nice":niceTex,
	"oops":oopsTex,
	"miss":missTex,
}


#ok yeah this arg is confusingly named
func SpawnHit(targetPos,hitType):
	var textureRect = TextureRect.new()
	textureRect.z_index = 6
	textureRect.size = Vector2(100,100)
	textureRect.texture = textures[hitType]
	textureRect.position = targetPos - textureRect.size/2.0

	var tween = get_tree().create_tween()
	tween.tween_property(textureRect,"position",textureRect.position + Vector2.UP * 200,1)
	
	tween.tween_callback(textureRect.queue_free)
	
	add_child(textureRect)
