extends Area2D

var speed = 550
export(int) var damage = 1
export var knockbackVector : Vector2

func _physics_process(delta):
	knockbackVector = transform.x	
	if !PManager.pause:
		position += transform.x * speed * delta
	else:
		position += transform.x * speed * delta * 1/100
