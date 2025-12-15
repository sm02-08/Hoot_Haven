extends NodeState

@export var character: CharacterBody2D 
@export var animated_sprite_2d: AnimatedSprite2D
@export var idle_state_time_interval: float = 5.0

# if you go to the StateMachine node and go to Initial Node State, it'll be Idle
# this is so that when chickens load in, they'll be idle first 
# this code here btw is copied from node_state.gd 

@onready var idle_state_timer: Timer = Timer.new() # create new instance of timer 
# ^ we want the chicken to be idle for a certain amount of time, and then after
# that time has passed, move it from idle to walk state 

var idle_state_timeout: bool = false # boolean set to default value of false 

func _ready() -> void: 
	idle_state_timer.wait_time = idle_state_time_interval 
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if idle_state_timeout: # if the timeout is true, then
		transition.emit("Walk") # transition to the walk state 


func _on_enter() -> void:
	animated_sprite_2d.play("idle") # when chicken enter, play idle
	
	idle_state_timeout = false # every time we go into idle state, reset the timer
	idle_state_timer.start() 

func _on_exit() -> void:
	animated_sprite_2d.stop() # on exit, stop chicken animation 
	idle_state_timer.stop()
	
func on_idle_state_timeout() -> void: # return to void 
	idle_state_timeout = true  # set the timeout to true once the timeout interval has been reached

# on the Idle node, character = Chicken and Animated Sprite 2D = the chicken's AnimatedSprite2D 
