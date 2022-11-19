extends Node2D

export(int) var lifetime = 5
export(int) var waitTime = 0.1

var counter = 0
var ready = false
var hasStatusEffect = false

func _ready():
	$Sprite.visible = false
	$WaitTimer.start(waitTime)
	$Timer.start(lifetime)

func _process(delta):
	if ready:
		counter += 1
		if fmod(counter, 2) == 0:
			$Hitbox.monitoring = true
		else:
			$Hitbox/CollisionShape2D.disabled = false
	else:
		$Hitbox/CollisionShape2D.disabled = true

func _on_Timer_timeout():
	if hasStatusEffect:
		PManager.statusCondition = ""
	self.queue_free()

func _on_PlayerDetectionZone_body_entered(body):
	if ready:
		hasStatusEffect = true
		PManager.statusCondition = "Slow"

func _on_PlayerDetectionZone_body_exited(body):
	if ready:
		hasStatusEffect = false
		PManager.statusCondition = ""

func _on_WaitTimer_timeout():
	ready = true
	$ColorRect.visible = false
	$Sprite.visible = true
