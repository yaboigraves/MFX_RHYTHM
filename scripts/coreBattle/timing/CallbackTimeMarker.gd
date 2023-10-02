class_name CallbackTimeMarker
extends RefCounted

var callback : Callable
var time : float

func _init(callback : Callable, time : float):
	self.callback = callback
	self.time = time
	

