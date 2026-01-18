class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer # add a variable that appears in the "Inspector" tab
# of type tilemaplayer 
@export var tilled_soil_tilemap_layer: TileMapLayer 
@export var terrain_set: int = 0 # default value of 0 
@export var terrain: int = 3 # default value of 3 

#var player: Player = get_tree().get_first_node_in_group("player") # when running a test on the main screen, an error occurred where "cannot call method 'get_first_node_in_group' on a null value." therefore, fix this with a _ready method
# this has been changed
var player: Player
# to do this, go to the player scene, go to "Node" and "Groups" and create a new global group
# that's called 'player' 

var mouse_position: Vector2 
var cell_position: Vector2i # vector2i is not a typo 
var cell_source_id: int 
var local_cell_position: Vector2 
var distance: float 

func _ready() -> void: 
	await get_tree().process_frame # after the tree has been set up and the framework has been added...
	# grab the player from the first noded group 
	player = get_tree().get_first_node_in_group("player")

func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed("remove_dirt"): 
		# go to project settings and then add a new input map 
		# ctrl + left mouse button removes dirt so this allows that input event 
		# to actually be translated to in-game stuff
		if ToolManager.selected_tool == DataTypes.Tools.TillGround: 
			get_cell_under_mouse()
			remove_tilled_soil_cell() 

	elif event.is_action_pressed("hit"): # changed to elif after the input event 
		# so when the player uses the till tool, this event will be called 
		if ToolManager.selected_tool == DataTypes.Tools.TillGround: 
			get_cell_under_mouse()
			add_tilled_soil_cell() 
			
	"""
	why check for "remove dirt" first? 
	because in the input map, we use the left mouse button for both remove dirt AND hit (tilling) but for remove dirt, we have a dual hit combo (ctrl + lmb) so if "hit" was first, we'd only ever have the tilling happen, because it wouldn't be checking for the remove dirt part. the lmb would always be called and then "hit" would always be called 
	(also i just realized how to wrap text and now i feel stupid) -- 12/26/2025, 10:49 AM  
	"""
			
			
func get_cell_under_mouse() -> void: 
	mouse_position = grass_tilemap_layer.get_local_mouse_position() 
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	# for debugging, print a few statements
	print("Mouse_position: ", mouse_position, ". Cell_position: ", cell_position, ". Cell_source_id: ", cell_source_id)
	print("Distance: ", distance)
	
# call another function to connect the terrain 
func add_tilled_soil_cell() -> void: 
	if distance < 25.0 && cell_source_id != -1: # if dist is less than 20 pixels 
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)
		# basically, if the distance is less than 20 from the mouse click, and the terrain is grass, 
		# then the terrain will be tilled 

func remove_tilled_soil_cell() -> void: 
	if distance < 25.0: 
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
		# this sets the "terrain set" to 0 and sets "terrain" to -1 (grass) 

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

# open up tilesets -> game_tile_set.tres
# scroll down to "Terrain Sets" 
# each one corresponds to an index: GrassTerrain is index 0, TilledDirtTerrain is index 1, so on so forth
# if you go to "FieldCursorComponent" and look at the Terrain, if you set the "Terrain" to 3, 
# then each tilling will use the wide_dirt_cropfield instead of wide_dirt. 
# but keep Terrain Set to 0 
