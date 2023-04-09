class_name InputSpoofProfile
extends Resource

#resource based way of doing spoofing

#the idea is we bind states to input spoofs
#the spoofer can store multiple profiles
#this way testing can be more accurately done

@export var stateName : String

@export var lane1Inputs: Array[float]
@export var lane2Inputs: Array[float]
@export var lane3Inputs: Array[float]
@export var lane4Inputs: Array[float]
