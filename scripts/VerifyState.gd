extends State

var targetHits

func enter(_msg := {}) -> void:
	targetHits = _msg["hits"]



#verification step!
#so this is a bit tricky cause we gotta factor in latency
#for now lets not even worry about that
#lets literally just look in the lane, find if any hits are close enough
#if any are close enough, then we count it as good and remove it
#latency WILL fuck the feel of this, so keep that in mind
#technically the audio cue is LAW, so we do need to factor in how long it takes for the cue to play

#also this gets called regardless so we need to process hits In the state machine not here
func _on_player_input_handler_hit(index) -> void:
	print(index)
