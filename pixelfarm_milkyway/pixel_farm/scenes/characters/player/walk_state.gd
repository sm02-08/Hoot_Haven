extends NodeState

@export var player: CharacterBody2D 
@export var animated_sprite_2d: AnimatedSprite2D 
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input() 
	
	if direction == Vector2.UP: 
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.RIGHT: 
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.DOWN: 
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.LEFT: 
		animated_sprite_2d.play("walk_left")
		
	if direction != Vector2.ZERO: 
		player.player_direction = direction # the .player_direction doesn't appear in the dropdown menu
		#because we're using dynamic time 
		# but fixing the player.gd script has allowed the player_direction to become possible 

	player.velocity = direction * speed
	player.move_and_slide() # issue right now is that after releasing from walk, the player keeps in the movement 
	#animation instead of going back to idle.
	# this is fixed on on next transitions 

func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input(): # if movement input is false
		transition.emit("Idle") # issue right now is that when u release, the idle goes back to front idle 
		# this is fixed timestamp 11/27 on the player node itself 


func _on_enter() -> void:
	pass


func _on_exit() -> void: # when we transition back to idle, we exit again 
	animated_sprite_2d.stop() 
