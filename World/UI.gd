extends Control

onready 	var player = get_tree().current_scene.get_child(1)
onready var wr = weakref(player)

func _process(delta):
	$Health.rect_size.x = PManager.health * 15.5 + 15.5
	
	if !PManager.slot1stop:
		$Slot1.rect_size.x = 40 - (PManager.slot1Timer.time_left/PManager.slot1time) * 40
	else:
		$Slot1.rect_size.x = 40
	
	if !PManager.slot2stop:
		$Slot2.rect_size.x = 40 - (PManager.slot2Timer.time_left/PManager.slot2time) * 40
	else:
		$Slot2.rect_size.x = 40
	
	if !PManager.slot3stop:
		$Slot3.rect_size.x = 40 - (PManager.slot3Timer.time_left/PManager.slot3time) * 40
	else:
		$Slot3.rect_size.x = 40
	
	if wr.get_ref() and !player.can_dash:
		$Stamina.rect_size.x = 60 - (player.dashCooldown.time_left/5) * 60
	else:
		$Stamina.rect_size.x = 60

func _on_Button_pressed():
	print(PManager.pause)
	if !PManager.pause:
		PManager.pause = true
		$PopupMenu.visible = true
	else:
		PManager.pause = false
		$PopupMenu.visible = false
