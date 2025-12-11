class_name InteractableComponent 
extends Area2D

signal interactable_activated 
signal interactable_deactivated 

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

# these two allow for the player to walk *through* the door instead of colliding with it 
func _on_body_entered(body):
	interactable_activated.emit() 


func _on_body_exited(body):
	interactable_deactivated.emit() 


# layer 1 = objects, layer 2 = player, layer 3 = interactables 
# on collision, this is layer 3 
# you select mask layer 2 so that it interacts with player (layer 2) 
