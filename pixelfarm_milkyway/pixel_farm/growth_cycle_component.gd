class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination # new data type 
# .Germination is the default state 
# utilizes the data_types.gd enums 
@export_range(5, 365) var days_until_harvest: int = 7 # a value between 5 and 365 for days 

signal crop_maturity 
signal crop_harvesting 
# there are signals for crop maturity and harvesting 

var is_watered: bool # new variables
var starting_day: int 
var current_day: int 

func _ready() -> void: 
	DayNightCycleManager.time_tick_day.connect(on_time_tick_day) # get the signal time tick day and connect that signal 
	# to the daynightcyclemanager. 
	
	# continuation from on_hurt in corn.gd: 
	# the day night cycle manager will always be constantly communicating with the growth component
	# this gives it the current time of day 
	# scroll down to on_time_tick_day (right below) 
	
func on_time_tick_day(day: int) -> void: 
	if is_watered: 
		if starting_day == 0: 
			starting_day = day
			
		growth_states(starting_day, day)
		harvest_state(starting_day, day)
	# continuation of _ready: 
	# when the crop is watered, then the growth cycle component will start to go through
	# the growth state
	# so until the crop's been watered, nothing will happen 
	
# so we first go through the growth state, calculate the number of days that have passed, 
# then calculate the state index, which we get later to modify the frame on the sprite 
# so the growth_states have been separated from the last state (the harvest state) 
# because we want to be able to set a diff number of days for the harvest state 
# BUT the growth state is fixed because of the NUMBER OF frames on the sprite
# but the harvest day can be several days later to give some variation 
# u want crops with different harvest days 

func growth_states(starting_day: int, current_day: int): 
	if current_growth_state == DataTypes.GrowthStates.Maturity: 
		return 
# basically, when the growth states are being traversed -- once we get to the maturity state, 
# we want to come out of the method
	
	var num_states = 5 
	
	# check the data_types.gd to see the number of states: 
	"""
	enum GrowthStates { # new enum for plants -- corn and tomatoes 
		Seed,
		Germination,
		Vegetative,
		Reproduction,
		Maturity,
		Harvesting
	}
	
	so there's 5 states, minus harvesting
	"""
	var growth_days_passed = (current_day - starting_day) % num_states 
	var state_index = growth_days_passed % num_states + 1 
	
	current_growth_state = state_index 
	
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state: ", name, " State index: ", state_index)
	
	if current_growth_state == DataTypes.GrowthStates.Maturity: 
		crop_maturity.emit() 
# if the growth state is of data type growth_state, then the index value will set at enum value

func harvest_state(starting_day: int, current_day: int) -> void: # pass in again the starting day and current day
	if current_growth_state == DataTypes.GrowthStates.Harvesting: 
		return
	
	var days_passed = (current_day - starting_day) % days_until_harvest
	# days until harvest is defined in @export_range 
	
	if days_passed == days_until_harvest - 1: 
		current_growth_state = DataTypes.GrowthStates.Harvesting 
		crop_harvesting.emit() # once you get to the harvest days, emit thru signal crop_harvesting 
		
func get_current_growth_state() -> DataTypes.GrowthStates: 
	return current_growth_state
	# this just enables us to update the frame 
	
