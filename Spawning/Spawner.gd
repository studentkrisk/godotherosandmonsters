extends Node2D

export(int) var howMany = 0
export(int) var spawnRange = 0;
export var OBJECT : PackedScene

var rng = RandomNumberGenerator.new()

func _ready():
	for i in range(howMany):
		rng.randomize()
		var object =  OBJECT.instance()
		var x = global_position.x + rng.randf_range(-spawnRange, spawnRange)
		rng.randomize()
		var y = global_position.y + rng.randf_range(-spawnRange, spawnRange)
		object.global_position = Vector2(x, y)
		print("Tree spawned at: " + str(object.global_position.x) + " ," + str(object.global_position.y))
		add_child(object)
