extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interactable_component: InteractableComponent = $InteractableComponent

func _ready() -> void: 
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated) 
	# when the scene loads, set the door's layer to 1 
	collision_layer = 1 
	
func on_interactable_activated() -> void: 
	animated_sprite_2d.play("open_door") 
	#print("activated")
	# when the door opens, set the door's layer to the same layer as the player (2) 
	collision_layer = 2 
	print("activated")
	
	
func on_interactable_deactivated() -> void: 
	animated_sprite_2d.play("close_door")
	# when deactivated, set collision layer back to 1 
	collision_layer = 1
	print("deactivated")

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
