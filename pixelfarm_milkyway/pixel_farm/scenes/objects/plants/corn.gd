extends Node2D

var corn_harvest_scene = preload("res://scenes/objects/plants/corn_harvest.tscn")
# created the corn harvest scene as a collectible previously

# click and drag + ctrl everything in the corn scene 
@onready var sprite_2d = $Sprite2D
@onready var watering_particles = $WateringParticles
@onready var flowering_particles = $FloweringParticles
@onready var growth_cycle_component = $GrowthCycleComponent
@onready var hurt_component = $HurtComponent

var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed
func _ready() -> void: 
	watering_particles.emitting = false 
	flowering_particles.emitting = false 
	
	hurt_component.hurt.connect(on_hurt) 
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
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
