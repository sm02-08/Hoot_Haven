extends Node2D
# ohh so to get rid of the constant issue of having the func _ready(): pass already loaded in and stuff, just disable template... why did i never try this before.

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent


func _ready() -> void: 
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide() 
	
func on_interactable_activated() -> void: 
	interactable_label_component.show() 
	
func on_interactable_deactivated() -> void: 
	interactable_label_component.hide() 
