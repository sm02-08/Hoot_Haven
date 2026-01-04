extends Node
# this will act as a singleton to appear for game scenes (specifically our tools taskbar) 

var selected_tool: DataTypes.Tools = DataTypes.Tools.None # of types datatypes.tool 
# assign it a non-variable as a default 

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools) # signal's parameter is tool, of type Tools

func select_tool(tool: DataTypes.Tools) -> void: 
	tool_selected.emit(tool) # call the signal defined above and emit selected tool
	selected_tool = tool # set selected tool to be the tool passed into select_tool function 

# script is complete! 
# apparently not actually, as i realize a few days later

func enable_tool_button(tool: DataTypes.Tools) -> void: 
	enable_tool.emit(tool) # emit and pass the tool

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
