extends State

#so the record state can hold input for a round
#the verify state can then be passed that data in the transition
#record state doesnt need to store anything

#so yeah we need a class for hits

var hits = [
	[],
	[],
	[],
	[]
]

func enter(_msg = {}):
	hits = [
		[],
		[],
		[],
		[]
	]


func _on_player_input_handler_hit(index) -> void:
	var hit = Hit.new(index,get_node("/root/Main/Metronome").timeInBeats)
	hits[index].append(hit)
	
	
