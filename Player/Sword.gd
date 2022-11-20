extends Area2D

var slashing = false
var can_slash = true
var swordtransform = null
var player = true

export var knockbackVector : Vector2

export(int) var damage = 1

onready var HeavenSlash = preload("res://Player/HeavenSlash.tscn")

func _ready():
	$AnimationPlayer.play("Slash")

func _physics_process(delta):
	if !PManager.pause && player:
		if Input.is_action_just_pressed("slash"):
			slash()
		if Input.is_action_just_pressed("1") and PManager.can_useslot1:
			evaluate(PManager.slot1 + "(1)")
		elif Input.is_action_just_pressed("2") and PManager.can_useslot2:
			evaluate(PManager.slot2 + "(2)")
		elif Input.is_action_just_pressed("3") and PManager.can_useslot3:
			evaluate(PManager.slot3 + "(3)")

func slash():
	if can_slash:
		slashing = true
		$AnimationPlayer.play("Slash")
		$Timer.start(1)
		can_slash = false

func heavenslash(num):
	slashing = true
	$AnimationPlayer.play("Slash")
	var heavenSlash = HeavenSlash.instance()
	heavenSlash.transform = swordtransform
	heavenSlash.global_position = global_position
	get_tree().current_scene.add_child(heavenSlash)
	startTime(num, 5)

func tripslash(num):
	slashing = true
	$AnimationPlayer.play("TripleSlash")
	startTime(num, 3)

func startTime(num, time):
	match num:
		1:
			PManager.can_useslot1 = false
			PManager.slot1Timer.start(time)
			PManager.slot1time = time
			PManager.slot1stop = false
		2:
			PManager.can_useslot2 = false
			PManager.slot2Timer.start(time)
			PManager.slot2time = time
			PManager.slot2stop = false
		3:
			PManager.can_useslot3 = false
			PManager.slot3Timer.start(time)
			PManager.slot3time = time
			PManager.slot3stop = false

func slashing_finished():
	slashing = false

func _on_Timer_timeout():
	can_slash = true

func none(num):
	pass

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

