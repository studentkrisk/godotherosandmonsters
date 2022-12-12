extends Node2D

export(int) var level = 1
export(float) var spawn_range = 10.0

onready var Goblin = preload("res://Enemies//Goblin.tscn")
onready var Spellcaster = preload("res://Enemies//Spellcaster.tscn")
onready var Slime = preload("res://Enemies//Slime.tscn")

var rng = RandomNumberGenerator.new()
var player_in_range = false
var time_wait
var can_spawn

func _ready():
	$Timer.start(20)

func _process(delta):
	if !PManager.pause and player_in_range:
		_spawn()

func _spawn():
	rng.randomize()
	if can_spawn:
		var enemy
		var num_spawn = rng.randi_range(0, 2)
		match num_spawn:
			0:
				enemy = Slime.instance()
			1:
				enemy = Goblin.instance()
			2:
				enemy = Spellcaster.instance()
		var offset = Vector2(rng.randf_range(-spawn_range, spawn_range), rng.randf_range(-spawn_range, spawn_range))
		enemy.global_position = global_position + offset
		get_tree().current_scene.add_child(enemy)
		can_spawn = false
				
func _on_PlayerDetectionZone_body_entered(body):
	player_in_range = true

func _on_PlayerDetectionZone_body_exited(body):
	player_in_range = false

func _on_Timer_timeout():
	can_spawn = true
	$Timer.start(10 - level)
