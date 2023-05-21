extends VBoxContainer

#this node loads a button for each track listed in track select
#these can get loaded dynamically later

@export var tracks : Array[AudioStreamOggVorbis]

signal TrackSelected(track)


func _ready() -> void:
	for track in tracks:
		var button = Button.new()
		button.text= track.resource_path
		#haha holy shit how cool
		button.pressed.connect(HandleButtonUp.bind(button,track))
		add_child(button)
		button.disabled = false
		
		

func HandleButtonUp(button,track):
	emit_signal("TrackSelected",track)
