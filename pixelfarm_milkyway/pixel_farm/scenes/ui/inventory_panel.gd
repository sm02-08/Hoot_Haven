extends PanelContainer

@onready var log_label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var stone_label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var corn_label = $MarginContainer/VBoxContainer/Corn/CornLabel
@onready var tomato_label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label = $MarginContainer/VBoxContainer/Egg/EggLabel
@onready var milk_label = $MarginContainer/VBoxContainer/Milk/MilkLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	
func on_inventory_changed() -> void: # when inventory changes, get the dictionary from the inventory
	var inventory: Dictionary = InventoryManager.inventory # when we get hte inventory from the inventory manager

	if inventory.has("log"): 
		log_label.text = str(inventory["log"])
		
	if inventory.has("stone"): 
		stone_label.text = str(inventory["stone"])
		
	if inventory.has("corn"): 
		corn_label.text = str(inventory["corn"])
		
	if inventory.has("tomato"): 
		tomato_label.text = str(inventory["tomato"])
		
	if inventory.has("egg"): 
		egg_label.text = str(inventory["egg"])
		
	if inventory.has("milk"): 
		milk_label.text = str(inventory["milk"])

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
