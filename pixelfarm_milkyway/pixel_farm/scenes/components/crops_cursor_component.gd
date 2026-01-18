class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player: Player = get_tree().get_first_node_in_group("player")

var corn_plant_scene = preload("res://scenes/objects/plants/corn.tscn") # preload the corn scene
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn") #and the tomato scene 

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int 
var local_cell_position: Vector2
var distance: float 
# used these ^ same variables in field cursor component 

func _ready() -> void: 
	await get_tree().process_frame # after the tree has been set up and the framework has been added...
	# grab the player from the first noded group 
	player = get_tree().get_first_node_in_group("player")


# unhandled_input and get_cell_under_mouse are copied from fieldcursorcomponent 
func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed("remove_dirt"): 
		# go to project settings and then add a new input map 
		# ctrl + left mouse button removes dirt so this allows that input event 
		# to actually be translated to in-game stuff
		if ToolManager.selected_tool == DataTypes.Tools.TillGround: 
			get_cell_under_mouse()
			#remove_tilled_soil_cell() <-- has to be replaced
			remove_crop() # remove_tilled_soil cell is replaced with remove_crop

	elif event.is_action_pressed("hit"): # changed to elif after the input event 
		# so when the player uses the till tool, this event will be called 
		#if ToolManager.selected_tool == DataTypes.Tools.TillGround: 
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:  # instead of the TillGround, check if the corn or tomato tool is selected
			get_cell_under_mouse()
			#add_tilled_soil_cell() 
			add_crop() # new function defined below 
	
	"""
	Why is it that when hitting, you can use plantcorn or planttomato, but when removing, only check for tilling tool? 
	Because you can plant both corn and tomatoes, but you can only remove dirt with the tilling tool 
	"""

func get_cell_under_mouse() -> void: 
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position() 
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	# the grass tilemap layer is changed to tilled_soil_tilemap_layer because this time, we want to check if we're clicking the tilled soilmap layer, which gets us the correct source ID so we know we're interacting with the right type of layer so we can apply and add our crop scene to the tile 
	
	# for debugging, print a few statements
	print("Mouse_position: ", mouse_position, ". Cell_position: ", cell_position, ". Cell_source_id: ", cell_source_id)
	print("Distance: ", distance)

func add_crop() -> void: 
	if distance < 25.0: 
		if has_crop_in_dirt(): # check: if there's already crops in that area, then don't plant anything
			return 
		
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn: # check if the current tool is the plantcorn tool 
			var corn_instance = corn_plant_scene.instantiate() as Node2D 
			# instantiate an instance of the corn scene
			corn_instance.global_position = local_cell_position # set global position to be the local cell position, which we get from the tilled soile tilemap layer 
			get_parent().find_child("Cropfields").add_child(corn_instance) # we want to find the cropfields and add the corn instance to the cropfields node 
			
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato: # now, if the tool we selected is to plant tomatoes instead of corn...
			var tomato_instance = tomato_plant_scene.instantiate() as Node2D # create an instance of the tomato scene 
			tomato_instance.global_position = local_cell_position 
			get_parent().find_child("Cropfields").add_child(tomato_instance) # get parent, find child, and add child to the Cropfields node in the TestSceneCropfieldsTilledDirt scene 

func remove_crop() -> void: 
	if distance < 25.0: 
		var crop_nodes = get_parent().find_child("Cropfields").get_children()
		# if the distance is less than 20, get all the crop nodes from the Cropfields node 
		
		for node: Node2D in crop_nodes: # use a forloop to search for a node inside the crop nodes
			if node.global_position == local_cell_position: 
				node.queue_free() 
			

func has_crop_in_dirt() -> bool: 
	var cropfields = get_parent().find_child("Cropfields")
	if cropfields == null: # identify if there's planted crops already
		return false 
		
	for node: Node2D in cropfields.get_children(): 
		if node.global_position == local_cell_position: # if there's a crop already in the tilled dirt area before we plant a new one, adding another plant in there should not be possible. we want only one plant per tilled dirt square 
			return true 
	return false 


## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
