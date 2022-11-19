extends AnimatedSprite

export(bool) var playinpause = false
export(bool) var disappear = true

func _process(delta):
	if !PManager.pause:
		playing = true
	else:
		if !playinpause:
			playing = false
		else:
			playing = true

func _on_AnimatedSprite_animation_finished():
	if disappear:
		queue_free()
