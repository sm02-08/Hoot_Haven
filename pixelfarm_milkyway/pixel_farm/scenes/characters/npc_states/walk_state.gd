# copied too from node_state.gd
# copied from chicken's walk state 
extends NodeState

@export var character: NonPlayableCharacter # gives us access to the non_playable_character.gd script 
#@export var character: CharacterBody2D 
@export var animated_sprite_2d: AnimatedSprite2D # these two copied from chicken's idle script 
@export var navigation_agent_2d: NavigationAgent2D 
@export var min_speed: float = 5.0 # default to 5 
@export var max_speed: float = 10.0 # default to 10

var speed: float 

func _ready() -> void: 
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	
	call_deferred("character_setup") # call deferred allows you to call other functions after the 
	# current frame has finished processing 
	# thus, call_deferred will call character setup during idle time 
	# when character set up is called, we will wait until after the first physics frame 
	# this allows for a smoother setup of our navigation agent before we start to move between 
	# different targets 
	
func character_setup() -> void: 
	await get_tree().physics_frame # wait for the first physics frame
	# when we use navigation region, the navigation agent has to wait for hte first physics frame 
	# and then starts to process the next target
	
	set_movement_target() 
	
func set_movement_target() -> void: 
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(), navigation_agent_2d.navigation_layers, false)
	navigation_agent_2d.target_position = target_position 
	speed = randf_range(min_speed, max_speed) # what this does is set the default speed value, 
	# and choose a speed between 5 and 10 
	# this allows every chicken to get a different speed, allowing for character variation 

func _on_process(_delta : float) -> void:
	pass



func _on_physics_process(_delta : float) -> void:
	# check if navigation has finished 
	if navigation_agent_2d.is_navigation_finished(): 
		character.current_walk_cycle += 1 
		set_movement_target() 
		return # this allows the chicken to stop spasming out when it reaches the end of its path 
		# the chicken also starts on a new path afterwards 
		# but we want the chicken to go back to idle state before walking again
		# go to next transitions method
	
	var target_position: Vector2 = navigation_agent_2d.get_next_path_position() 
	var target_direction: Vector2 = character.global_position.direction_to(target_position) # export var character
	# ^ this will get the facing direction that our character is facing towards 
	
	# next step: get our animated sprite 2d and use .flip(H) = target direction.x (which is the axis value)
	# if this is less than 0, flip the chicken 
	# animated_sprite_2d.flip_h = target_direction. x < 0 
	
	var velocity: Vector2 = target_direction * speed 
	if navigation_agent_2d.avoidance_enabled: # if avoidance is enabled, set velocity to navigationagent2d
		animated_sprite_2d.flip_h = velocity.x < 0 # copied from line 58 and changed target_direction to velocity
		# this then calls on the on _safe_velocity_computed function to be called 
		navigation_agent_2d.velocity = velocity 
	else: 
		character.velocity = velocity 
		character.move_and_slide() # process the movement of our character 
	# not using delta in our calculation because character will use delta calculation within the
	# move and slide 
	# so all we need to do is calculate direction * speed and assign that to velocity
	# internally, delta will be calculated for us 
		# if avoidance is disabled, character moves like normal 

# go to navigation agent 2d and go down to "Debug" and click "enabled" to see the line the chicken
# follows when it's walking 

func on_safe_velocity_computed(safe_velocity: Vector2) -> void: # parameter is safe_velocity, which
	# is a type Vector2, and returns void
	animated_sprite_2d.flip_h = safe_velocity.x < 0 # resolves flipping the sprite randomly 
	# when the chicken wants to avoid other chickens 
	character.velocity = safe_velocity # if avoidance is enabled, set safe velocity 
	character.move_and_slide() 

func _on_next_transitions() -> void:
	# if navigation_agent_2d.is_navigation_finished(): instead of this...
	if character.current_walk_cycle == character.walk_cycles: # as we go thru each walk cycle, 
		# when the current walk cycle = that value, transition goes back to idle 
		character.velocity = Vector2.ZERO 
		transition.emit("Idle") # this means that when the navigation path has concluded, 
		# the chicken's velocity should go back to zero (speed = 0) and then the chicken should 
		# use the idle animation again 
		# this prevents the chicken from walking continuously forever 
	# if you run the test npc chicken scene, and go to "Remote" under "Scene," click "Chickens," and 
	# then click the "Chicken" child node, you'll see that there's a min walk cycle, max walk cycle, 
	# and another variable: Walk Cycles. this is the current number of walk cycles the chicken is doing
	

func _on_enter() -> void:
	animated_sprite_2d.play("walk") # play walk animation when entering walk state
	character.current_walk_cycle = 0 # on entering, the walk cycle should be set to 0 

func _on_exit() -> void:
	animated_sprite_2d.stop() # stop the walk animation on exit 

# we need to be able to get the chicken to walk to places, so we use a navigation region 2d 
# draw a navigation polygon that borders where the chicken can move 
