extends KinematicBody2D

var velocity = Vector2.ZERO
var dashing = false
var can_dash = true
var invincible = false
var can_switch = true

export(int) var ACCELERATION = 400
export(int) var MAX_SPEED = 200
export(int) var FRICTION = 0.9
export(int) var ROTATIONSPEED = 10

onready var animatedSprite = $AnimatedSprite
onready var dashCooldown = $DashCooldown
onready var position2D = $Position2D
onready var swordPivot = $Position2D/SwordPivot
onready var sword = $Position2D/SwordPivot/Sword
onready var HitEffect = preload("res://HitEffect.tscn")
onready var Sword = preload("res://Weapons//Sword.tscn")

var tick = 0
var flipped = false

func move(delta):
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

func switchWeapon():
	if(PManager.weapon2 != ""):
		var prevSword = sword
		sword.queue_free()
		if PManager.currentWeaponis1:
			match PManager.weapon1:
				"Sword":
					sword = Sword.instance()
		else:
			match PManager.weapon2:
				"Sword":
					sword = Sword.instance()
		sword.transform = prevSword.transform
		swordPivot.add_child(sword)
	else:
		PManager.currentWeaponis1 = !PManager.currentWeaponis1

func flip():
	self.scale.x *= -1
	position2D.scale.y *= -1
	position2D.position.y *= -1
	sword.scale.x *= -1
	sword.position.x *= -1
	position2D.rotation_degrees = 0
	flipped = !flipped

func processStatus():
	if(PManager.statusCondition == "Slow"):
		MAX_SPEED = 25
	else:
		MAX_SPEED = 200

func _physics_process(delta):
	if Input.get_action_strength("switchWeapon") > 0 and can_switch:
		PManager.currentWeaponis1 = !PManager.currentWeaponis1
		can_switch = false
		$Swiching.start(1)
		switchWeapon()
	if get_global_mouse_position().x < global_position.x and !flipped:
		flip()
	if get_global_mouse_position().x > global_position.x && flipped:
		flip()
	processStatus()
	sword.swordtransform = swordPivot.transform
	if !PManager.pause:
		move(delta)
	if !sword.slashing:
		rotateToTarget(get_global_mouse_position(), delta)

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	sword.knockbackVector = direction.normalized()
	var angleTo = 0
	angleTo = swordPivot.transform.x.angle_to(direction)
	swordPivot.rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

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
	
func evaluate(command, variable_names = [], variable_values = []) -> void:
	var expression = Expression.new()
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return

	var result = expression.execute(variable_values, self)

	if not expression.has_execute_failed():
		pass
		#print(str(result))

func _on_Swiching_timeout():
	can_switch = true
