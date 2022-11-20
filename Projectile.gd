extends Area2D

var speed = 200
export(int) var damage = 1
export var knockbackVector : Vector2

func _physics_process(delta):
	knockbackVector = transform.x.normalized()
	position += transform.x * speed * delta
