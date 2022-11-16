extends KinematicBody2D

export(int) var ACCELERATION = 800;
export(int) var MAX_SPEED = 200;
export(int) var ROLL_SPEED = 150;
export(float) var FRICTION = 0.9;
export(int) var REGENTIME = 40;

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

func _process(delta):
	input_vector = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED)
		
	velocity *= FRICTION
	move()
	
func move():
	velocity = move_and_slide(velocity)	

