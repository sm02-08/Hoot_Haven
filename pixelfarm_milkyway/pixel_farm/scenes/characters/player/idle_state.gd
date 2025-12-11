extends NodeState

@export var player: Player 
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.player_direction == Vector2.UP: 
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT: 
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.DOWN: 
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT: 
		animated_sprite_2d.play("idle_left")
	else: 
		animated_sprite_2d.play("idle_front")
	#direction = GameInputEvents.movement_input()
	#if player.player_direction == Vector2.UP: 
		#animated_sprite_2d.play("idle_back")
	#if direction == Vector2.UP: 
		#animated_sprite_2d.play("idle_back")
	#elif direction == Vector2.RIGHT: 
		#animated_sprite_2d.play("idle_right")
	#elif direction == Vector2.DOWN: 
		#animated_sprite_2d.play("idle_front")
	#elif direction == Vector2.LEFT: 
		#animated_sprite_2d.play("idle_left")
	#else: 
		#animated_sprite_2d.play("idle_front")



func _on_next_transitions() -> void: # this automatically checks what to do for next
	GameInputEvents.movement_input() 
	if GameInputEvents.is_movement_input(): # if there's movement input, you start walking 
		transition.emit("Walk") # "transition" is found in node_state.gd at "signal transition" at the very top

	#if player.current_tool == DataTypes.Tools.AxeWood: # if the player uses axewood tool...
		#transition.emit("Chopping") # change the transition of the player to chopping
		
	# next thing to do is to ONLY transition to chopping when we press MouseDown 
	if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvents.use_tool():
		# improvement from the previous code right above because it tests for game input
		transition.emit("Chopping") # change the transition of the player to chopping
		
	if player.current_tool == DataTypes.Tools.TillGround && GameInputEvents.use_tool():
		transition.emit("Tilling")
		
	if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.use_tool():
		transition.emit("Watering")

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop() # stop idle animation on exit 
