extends BaseGameDialogueBalloon

@onready var emotes_panel: Panel = $Balloon/Panel/Dialogue/HBoxContainer/EmotesPanel

func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	# the func start ^ is copied from base_game_dialogue_balloon.gd's func start 
	super.start(dialogue_resource, title, extra_game_states) 
	emotes_panel.play_emote("emote_12_talking") # so that when an npc's talking, the icon displays their talking animation instead of an ear flop or something else 
	
func next(next_id: String) -> void:
	super.next(next_id)
	emotes_panel.play_emote("emote_12_talking")
