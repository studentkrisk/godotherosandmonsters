extends Area2D

var slashing = false
var can_slash = true
var swordtransform = null
var player = true

export var knockbackVector : Vector2
export(int) var damage = 1

func _ready():
	$AnimationPlayer.play("Slash")

func slash():
	if can_slash:
		slashing = true
		$AnimationPlayer.play("Slash")
		$Timer.start(1)
		can_slash = false

func slashing_finished():
	PManager.pause = false
	slashing = false

func _on_Timer_timeout():
	can_slash = true

