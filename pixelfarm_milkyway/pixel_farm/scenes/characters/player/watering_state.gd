extends NodeState

@export var player : Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D # copied from chopping.gd

func _ready() -> void: 
	hit_component_collision_shape.disabled = true 
	hit_component_collision_shape.position = Vector2(0, 0); # copied from chopping.gd 

func _on_process(_delta : float) -> void:
	pass

# this code is the exact same as tilling state & chopping state just replaced with "water" instead of till/chop

func _on_physics_process(_delta : float) -> void:
	pass

# turn off loop for all watering animations just like for chopping & tilling 

func _on_next_transitions() -> void: # on next transition, check if animated sprite is playing
	if !animated_sprite_2d.is_playing(): # if animated sprite is NOT playing, transition back to idle
		transition.emit("Idle")


func _on_enter() -> void: # only play the animation as you enter the state 
	if player.player_direction == Vector2.UP: 
		animated_sprite_2d.play("watering_back")
		hit_component_collision_shape.position = Vector2(2, -20)
	elif player.player_direction == Vector2.RIGHT: 
		animated_sprite_2d.play("watering_right") 
		hit_component_collision_shape.position = Vector2(9, 0)
	elif player.player_direction == Vector2.LEFT: 
		animated_sprite_2d.play("watering_left")
		hit_component_collision_shape.position = Vector2(-9, 0)
	elif player.player_direction == Vector2.DOWN: 
		animated_sprite_2d.play("watering_front")
		hit_component_collision_shape.position = Vector2(-2, 2)
	
	else: 
		animated_sprite_2d.play("watering_front") # similar code as the idle and walk animations


func _on_exit() -> void: # this makes sure tilling stops when we move back to idle 
	animated_sprite_2d.stop() 
	hit_component_collision_shape.disabled = true # copied from chopping.gd 
	
# also go into AnimatedSprite2D and into the SpriteFrames tab. looping should be turned off for all the chopping_ 
#ones because we only want to play the tilling animation once 

# make sure because this wont work otherwise, go to "Tilling" under "StateMachine" and assign player 
#to this script & animatedsprite2d to "Animated Sprite" 
