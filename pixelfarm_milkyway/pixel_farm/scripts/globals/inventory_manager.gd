extends Node

var inventory: Dictionary = Dictionary() # create a new variable that's type dictionary 

signal inventory_changed 

func add_collectible(collectible_name: String) -> void: # adding the collectible name to inv dictionary
	inventory.get_or_add(collectible_name)
	
	if inventory[collectible_name] == null: # if we have nothing in the inventory...
		inventory[collectible_name] = 1 # just add the value 1
		
	else: 
		inventory[collectible_name] += 1 
		
	inventory_changed.emit()

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
