extends KinematicBody2D

export(int) var ACCELERATION = 800;
export(int) var MAX_SPEED = 200;
export(float) var FRICTION = 0.9;

var v = Vector2.ZERO

func _process(delta):
	var input = Input.get_vector("game_left", "game_right", "game_up", "game_down").normalized()
	
	if input != Vector2.ZERO:
		$RayCast.cast_to = input*16
		v += input * ACCELERATION * delta
		v = v.clamped(MAX_SPEED)
		
	v *= FRICTION
	move_and_slide(v)
