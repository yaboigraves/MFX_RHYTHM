class_name MenuState
extends State

@export var visibleControlNodes: Array[Node]
@export var stateButtons : Array[BaseButton]
#so this is just a base class for all of these
#menu states are basically ways to easily control navigation targets in the UI
#each 

#i  think we can keep these the same for everything tbh
#just have containers and navigatables register to a state
#and then also register animations to states I guess too

#ok
