extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export(int) var ACCELERATION = 200
export(int) var MAX_SPEED = 100
export(int) var FRICTION = 0.9
export(int) var ROTATIONSPEED = 10
export(int) var health = 3

enum{
	WANDER,
	CHASE,
	ATTACK
}

var player = null
var wr = null
var state = WANDER
var spawn_position = Vector2.ZERO
var wander_point = Vector2.ZERO
var velocity = Vector2.ZERO

onready var HitEffect = preload("res://HitEffect.tscn")

func _ready():
	spawn_position = global_position
	wander_point = global_position
	rng.randomize()

func _physics_process(delta):
	rng.randomize()
	if !PManager.pause:
		if state == WANDER:
			wander(delta)
		elif state == CHASE:
			chase(delta)
		elif state == ATTACK:
			attack(delta)
		$AnimatedSprite.playing = true
		get_tree().current_scene.material.set("shader_param/timeStop", false)
		$AnimatedSprite.material.set("shader_param/timeStop", false)
		if !$SwordPivot/EnemySword.slashing:
			if !state == WANDER:
				rotateToTarget(player.global_position, delta)
				$SwordPivot/EnemySword.knockbackVector = global_position.direction_to(player.global_position)
			else:
				rotateToTarget(Vector2(1000, 1000), delta)
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.material.set("shader_param/timeStop", true)

func attack(delta):
	$AnimatedSprite.animation = "Idle" 
	$SwordPivot/EnemySword.slash()
	if global_position.distance_to(player.global_position) >= 15:
		state = CHASE

func wander(delta):
	if global_position.distance_to(wander_point) <= 5:
		var offset = Vector2(rng.randi_range(-50, 50), rng.randi_range(-50, 50))
		wander_point = spawn_position + offset
	else:
		var direction = global_position.direction_to(wander_point)
		velocity += (direction * ACCELERATION * delta)/2
		velocity.clamped(MAX_SPEED/2)
		velocity *= 0.9
		velocity = move_and_slide(velocity)

func chase(delta):
	$AnimatedSprite.animation = "Run"
	if wr.get_ref():
		var direction = global_position.direction_to(player.global_position)
		direction = direction + Vector2(rng.randi_range(-0.1, 0.1), rng.randi_range(-0.1, 0.1))
		direction = direction.normalized()
		velocity += direction * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity *= 0.9
		velocity = move_and_slide(velocity)
		if global_position.distance_to(player.global_position) <= 15:
			state = ATTACK

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	var angleTo = $SwordPivot.transform.x.angle_to(direction)
	$SwordPivot.rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	wr = weakref(player)
	state = CHASE

func _on_PlayerDetectionZone_body_exited(body):
	player = null
	state = WANDER

func generate_hit_effect():
	var hitEffect = HitEffect.instance()
	hitEffect.global_position = global_position
	hitEffect.z_index = 2
	get_tree().current_scene.add_child(hitEffect)

func _on_Hurtbox_area_entered(area):
	health -= area.damage
	velocity += area.knockbackVector * 5
	generate_hit_effect()
	if health <= 0:
		var EnemyDeath = load("res://Enemies/EnemyDeath.tscn")
		var enemyDeath = EnemyDeath.instance()
		enemyDeath.global_position = global_position
		get_tree().current_scene.add_child(enemyDeath)
		queue_free()
