extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_smile", "emote_3_ear_wave", "emote_4_blink"] # these are 4 emotes from the animated sprite 2D spritesheet -- in there, we have 6 animations in total 



func _ready() -> void: # overriden ready method
	animated_sprite_2d.play("emote_1_idle") # start with default emote: idle

func play_emote(animation: String) -> void: 
	animated_sprite_2d.play(animation) # use the play function and pass in animation 


func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0, 3)
	var emote = idle_emotes[index] # every time this item is called, it'll randomly call one of the four idle emotes shown above (on line 6) 
	
	animated_sprite_2d.play(emote) 
