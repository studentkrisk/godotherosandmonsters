extends AnimatedSprite

export(bool) var playinpause = false
export(bool) var disappear = true

func _ready():
	playing = true

func _on_AnimatedSprite_animation_finished():
	if disappear:
		queue_free()
