class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day: int = 0: # if i set int = 0, it starts at day 15 for some reason?? this way it starts a day 1
	# ^ fixed apparently just set the initial day, hour, minute, and second to 0 too and it'll be fixed 
	set(id): # id = initial day, ih = initial hour, im = initial minute
		initial_day = id
		DayNightCycleManager.initial_day = id 
		DayNightCycleManager.set_initial_time() 
		
@export var initial_hour: int = 0: 
	set(ih): 
		initial_hour = ih 
		DayNightCycleManager.initial_hour = ih 
		DayNightCycleManager.set_initial_time() 
		
@export var initial_minute: int = 0: 
	set(im): 
		initial_minute = im 
		DayNightCycleManager.initial_minute = im 
		DayNightCycleManager.set_initial_time() 
		
@export var day_night_gradient_texture: GradientTexture1D 

func _ready() -> void: 
	DayNightCycleManager.initial_day = initial_day 
	DayNightCycleManager.initial_hour = initial_hour 
	DayNightCycleManager.initial_minute = initial_minute 
	DayNightCycleManager.set_initial_time() 
	
	DayNightCycleManager.game_time.connect(on_game_time)
	
func on_game_time(time: float) -> void: 
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	# sin oscillates the value between 0 and 1 
	# the oscillation allows the gradient to continuously change so the screen turns from like
	# red dawn to yellow daylight to purple sunset 
	color = day_night_gradient_texture.gradient.sample(sample_value) # set the colored variable inside the canvas modulate
	# the sample method 
	# ^ color is a property of the component 
