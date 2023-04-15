
extends Node
signal Hit(index:int)
signal Escape

#TODO: cache a ref to the metronome, as timing info is super important to all input events

func _process(delta: float) -> void:
	for i in range(1,5):
		if Input.is_action_just_pressed("Drum" + str(i)):
			get_child(i-1).play()
			HandleHit(i-1)
	
#	if Input.is_action_just_pressed("Cancel"):
#		emit_signal("Escape")
#
func HandleHit(index : int):
	emit_signal("Hit",index)
	
	
	
func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)

func _print_midi_info(midi_event: InputEventMIDI):
#	print(midi_event)
#	print("Channel " + str(midi_event.channel))
##	print("Message " + str(midi_event.message))
#	print("Pitch " + str(midi_event.pitch))
#	print("Velocity " + str(midi_event.velocity))
#	print("Instrument " + str(midi_event.instrument))
#	print("Pressure " + str(midi_event.pressure))
#	print("Controller number: " + str(midi_event.controller_number))
#	print("Controller value: " + str(midi_event.controller_value))
	if midi_event.velocity > 0:
		print(midi_event.pitch - 36)
		
		if midi_event.pitch - 36 < 4:
			get_child(midi_event.pitch - 36).play()
			HandleHit(midi_event.pitch - 36)


func _on_input_spoofer_spoof_hit(lane, time) -> void:
	print("player got lane ", lane)
	HandleHit(3 - lane)
	get_child(3-lane).play()
