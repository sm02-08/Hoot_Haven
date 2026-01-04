extends PanelContainer

@onready var tool_axe = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato = $MarginContainer/HBoxContainer/ToolTomato


## Called when the node enters the scene tree for the first time.
func _ready(): # when the player first loads in, the tool panels must be disabled 
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
	# only after the user interacts with the guides, should the tools be enabled
	tool_tilling.disabled = true 
	tool_tilling.focus_mode = Control.FOCUS_NONE 
	
	tool_watering_can.disabled = true 
	tool_watering_can.focus_mode = Control.FOCUS_NONE 
	
	tool_corn.disabled = true 
	tool_corn.focus_mode = Control.FOCUS_NONE 
	
	tool_tomato.disabled = true 
	tool_tomato.focus_mode = Control.FOCUS_NONE 
#

func on_enable_tool_button(tool: DataTypes.Tools) -> void: 
	# the tool taskbar has to be disabled before it's... enabled lol after the dialogue passes 
	if tool == DataTypes.Tools.TillGround: 
		tool_tilling.disabled = false 
		tool_tilling.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.WaterCrops: 
		tool_watering_can.disabled = false 
		tool_watering_can.focus_mode = Control.FOCUS_ALL 
	elif tool == DataTypes.Tools.PlantCorn: 
		tool_corn.disabled = false 
		tool_corn.focus_mode = Control.FOCUS_ALL 
	elif tool == DataTypes.Tools.PlantTomato: 
		tool_tomato.disabled = false 
		tool_tomato.focus_mode = Control.FOCUS_ALL 

# THERE'S AN ISSUE WITH THIS THOUGH -- if you're trying to test other scenes (e.g. tilled dirt scene), your tools will be DISABLED AND THERE'S NO WAY TO FIX THEM 
# so there needs to be some type of way to enable the tools within testing scenes 

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
"""
to do this function below (ontoolaxepressed and all the other ontool___pressed), go to ToolAxe, 
then "Node," then "pressed()", then click "pressed()" and "Connect"
we basically want to set this tool so that when you click the axe UI, you switch item to axe
"""
# to do this function 
func _on_tool_axe_pressed(): 
	ToolManager.select_tool(DataTypes.Tools.AxeWood) # use select_tool function from tool_manager
	# when axe selected, axe is assigned to player 

func _on_tool_tilling_pressed():
	ToolManager.select_tool(DataTypes.Tools.TillGround) # copied from on_tool_axe_pressed

func _on_tool_watering_can_pressed():
	ToolManager.select_tool(DataTypes.Tools.WaterCrops) # copied from on_tool_axe_pressed

func _on_tool_corn_pressed():
	ToolManager.select_tool(DataTypes.Tools.PlantCorn) # copied from on_tool_axe_pressed

func _on_tool_tomato_pressed():
	ToolManager.select_tool(DataTypes.Tools.PlantTomato) # copied from on_tool_axe_pressed

# but right now we can't deselect tools 
# so we added a release tool on the project -> project settings -> input map 
# and will have a new function below 

func _unhandled_input(event: InputEvent) -> void: 
	if event.is_action_pressed("release_tool"): 
		ToolManager.select_tool(DataTypes.Tools.None)
		tool_axe.release_focus()
		tool_tilling.release_focus()
		tool_watering_can.release_focus() 
		tool_corn.release_focus() 
		tool_tomato.release_focus() 
		# these will allow us to release the button when we reclick 
