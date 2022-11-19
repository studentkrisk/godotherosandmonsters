extends CanvasLayer

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $Movement.is_pressed():
			PManager.movementVector = event.position - $Movement.global_position
			print(PManager.movementVector)
		if $Fight.is_pressed():
			PManager.fightVector = event.position - $Fight.global_position
	else:
		PManager.movementVector = Vector2.ZERO
		PManager.movementVector = Vector2.ZERO
