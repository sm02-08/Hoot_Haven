# copied from corn.gd

extends Node2D

var tomato_harvest_scene = preload("res://scenes/objects/plants/tomato_harvest.tscn")
# created the tomato harvest scene as a collectible previously

# click and drag + ctrl everything in the tomato scene 
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent


var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void: 
	watering_particles.emitting = false 
	flowering_particles.emitting = false 
	
	hurt_component.hurt.connect(on_hurt) 
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)
	# in this method, we're registering to the hurt_component signal and the growth_cycle_component signal
	# when the player uses the watering can and approaches the crop, the hurt_component will first be called
	# now, scroll down to on_hurt function 
	
func _process(delta: float) -> void: 
	growth_state = growth_cycle_component.get_current_growth_state() 
	sprite_2d.frame = growth_state 
	
	if growth_state == DataTypes.GrowthStates.Maturity: 
		flowering_particles.emitting = true 
	
func on_hurt(hit_damage: int) -> void: 
	if !growth_cycle_component.is_watered: 
		watering_particles.emitting = true 
		await get_tree().create_timer(5.0).timeout # after 5 seconds, register a timeout signal
		watering_particles.emitting = false 
		growth_cycle_component.is_watered = true # then after the 5 seconds, no more particles will be
		# emitted (specifically the watering particles) 
		
		# continuation from _ready func
		# here, we tell the growth cycle that the growth is currently watered. 
		# we then emit watering particles to show the player the crop has been activated
		# now, go to the growth_cycle_component.gd 
		
func on_crop_maturity() -> void:
	flowering_particles.emitting = true 
	# this activates those particles to show that the maturity has happened in the growth cycle

func on_crop_harvesting() -> void: # there was a bad edit in the tutorial
	# so this part isn't in the tutorial but it's from their github 
	# https://github.com/rapidvectors/tutorial-components-and-scripts/blob/main/tutorials/croptails/scripts/scenes/objects/plants/corn.gd
	var tomato_harvest_instance = tomato_harvest_scene.instantiate() as Node2D
	tomato_harvest_instance.global_position = global_position
	get_parent().add_child(tomato_harvest_instance)
	queue_free()
