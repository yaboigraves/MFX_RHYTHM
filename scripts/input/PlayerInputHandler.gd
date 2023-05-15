extends Node
signal Hit(index:int)
signal Escape

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())


func _process(delta: float) -> void:
	for i in range(1,5):
		if Input.is_action_just_pressed("Drum" + str(i)):
			HandleHit(i-1)
	
#
func HandleHit(index : int):
	emit_signal("Hit",index)

	
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
		if midi_event.pitch - 36 < 4:
			HandleHit(midi_event.pitch - 36)


func _on_input_spoofer_spoof_hit(lane, time) -> void:
	print("player got lane ", lane)
	HandleHit(3 - lane)

