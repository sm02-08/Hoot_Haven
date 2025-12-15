class_name NonPlayableCharacter 
extends CharacterBody2D 

@export var min_walk_cycle: int = 2 # minimum of 2 walk cycles
@export var max_walk_cycle: int = 6 # maximum of 6 walk cycles 

var walk_cycles: int # creating walk cycles for chickens 
# some chickens take 2 walk cycles to start idling, some 3, some 1, etc. 
var current_walk_cycle: int # we need a current walk cycle, which is also a type of int 
