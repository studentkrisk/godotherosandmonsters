extends KinematicBody2D

var velocity = Vector2.ZERO
var dashing = false
var can_dash = true
var invincible = false

export(int) var ACCELERATION = 400
export(int) var MAX_SPEED = 200
export(int) var FRICTION = 0.9
export(int) var ROTATIONSPEED = 10

onready var animatedSprite = $AnimatedSprite
onready var dashCooldown = $DashCooldown
onready var HitEffect = preload("res://HitEffect.tscn")

var tick = 0
var flipped = false

func move(delta, slow):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animatedSprite.animation = "Run"
		
		if !dashing:
			velocity += input_vector * ACCELERATION * delta
			velocity = velocity.clamped(MAX_SPEED)
		else:
			velocity += input_vector * ACCELERATION * delta * 2
			velocity = velocity.clamped(MAX_SPEED * 2)
		if slow:
			velocity *= 0.1
	else:
		animatedSprite.animation = "Idle"
	
	velocity *= 0.9
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		$DashTimer.start(2)
		
	if dashing:
		get_tree().current_scene.scale = Vector2(min(max(parabolaThing(2 - $DashTimer.time_left), 0.7), 1), min(max(parabolaThing(2 - $DashTimer.time_left), 0.7), 1))
	else:
		get_tree().current_scene.scale = Vector2(1, 1)

func _physics_process(delta):
	if !PManager.pause:
		if get_global_mouse_position().x < global_position.x and !flipped:
			self.scale.x *= -1
			$Position2D.scale.y *= -1
			$Position2D.position.y *= -1
			$Position2D/SwordPivot/Sword.scale.x *= -1
			$Position2D/SwordPivot/Sword.position.x *= -1
			$Position2D.rotation_degrees = 0
			flipped = true
		if get_global_mouse_position().x > global_position.x && flipped:
			self.scale.x *= -1
			$Position2D.scale.y *= -1
			$Position2D.position.y *= -1
			$Position2D/SwordPivot/Sword.scale.x *= -1
			$Position2D/SwordPivot/Sword.position.x *= -1
			$Position2D.rotation_degrees = 0
			flipped = false
	if(PManager.statusCondition == "Slow"):
		MAX_SPEED = 25
	else:
		MAX_SPEED = 200
	$Position2D/SwordPivot/Sword.swordtransform = $Position2D/SwordPivot.transform
	if !PManager.pause:
		$AnimatedSprite.playing = true
		move(delta, false)
		get_tree().current_scene.material.set("shader_param/timeStop", false)
		$AnimatedSprite.material.set("shader_param/timeStop", false)
	else:
		$AnimatedSprite.playing = false
		move(delta, true)
		get_tree().current_scene.material.set("shader_param/timeStop", true)
		$AnimatedSprite.material.set("shader_param/timeStop", true)
	if !$Position2D/SwordPivot/Sword.slashing:
		rotateToTarget(get_global_mouse_position(), delta)

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	$Position2D/SwordPivot/Sword.knockbackVector = direction
	var angleTo = 0
	angleTo = $Position2D/SwordPivot.transform.x.angle_to(direction)
	$Position2D/SwordPivot.rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func parabolaThing(time):
	return (time * time)/(4 * 0.5)

func _on_DashTimer_timeout():
	dashing = false
	can_dash = false
	$DashCooldown.start(5)

func _on_DashCooldown_timeout():
	can_dash = true

func _on_Hurtbox_area_entered(area):
	if !invincible:
		generate_hit_effect()
		velocity += area.knockbackVector * 200
		PManager.health -= area.damage
		invincible = true
		$Invincibility.start(1)
		if PManager.health <= 0:
			queue_free()

func generate_hit_effect():
	var hitEffect = HitEffect.instance()
	hitEffect.global_position = global_position
	hitEffect.z_index = 2
	get_tree().current_scene.add_child(hitEffect)

func _on_Invincibility_timeout():
	invincible = false
