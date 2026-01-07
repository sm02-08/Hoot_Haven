extends Node2D

func _ready() -> void: 
	call_deferred("set_scene_process_mode") # call deferred waits for the home scene to be set up and then we freeze the scene
	# so just this alone would cause the game menu to be completely frozen 
	# we need to set up a flip for some of the animals 
	
func set_scene_process_mode() -> void: 
	process_mode = PROCESS_MODE_DISABLED 
