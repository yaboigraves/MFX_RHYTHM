class_name IntroState
extends State

func enter(args ={}):
	$UI.DoIntroSequence(func():
		#start the timer, then go into the first listen sequence
		$"DebugTimer".start()
		await $"DebugTimer".timeout
		state_machine.transition_to("BattleRound")
		)

