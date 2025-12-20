class_name CollectibleComponent
extends Area2D

@export var collectible_name: String # export variable for the collectible name
# every time we add this collectible component to a diff type of collectible, we just 
# reuse this  

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player: 
		InventoryManager.add_collectible(collectible_name) # add to the inventory manager
		print("Collected: ", collectible_name) # when player collects the log, print "Collected"
		# update 12/20/25: there's more collectibles 
		get_parent().queue_free() # then free the item from the game 
