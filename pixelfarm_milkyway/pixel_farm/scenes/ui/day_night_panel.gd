extends Control

@onready var day_label = $DayPanel/MarginContainer/DayLabel
@onready var time_label = $TimePanel/MarginContainer/TimeLabel

@export var normal_speed: int = 5 
@export var fast_speed: int = 100 
@export var cheetah_speed: int = 200

func _ready() -> void: 
	DayNightCycleManager.time_tick.connect(on_time_tick)
	
func on_time_tick(day: int, hour: int, minute: int) -> void: 
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute] # string formatter that converts integers to strings
	# ^ the [] allows you to pass in 2 variables at once 

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_normal_speed_button_pressed():
	DayNightCycleManager.game_speed = normal_speed

func _on_fast_speed_button_pressed():
	DayNightCycleManager.game_speed = fast_speed

func _on_cheetah_speed_button_pressed():
	DayNightCycleManager.game_speed = cheetah_speed
