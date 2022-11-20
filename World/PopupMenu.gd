extends PopupMenu

func _ready():
	clear()
	if len(PManager.inventory) != 0:
		for i in range(len(PManager.inventory)):
			self.add_radio_check_item(PManager.inventory[i], i)

func _physics_process(delta):
	if Input.is_action_just_pressed("menu"):
		if PManager.pause == false:
			PManager.pause = true
			visible = true
		else:
			PManager.pause = false
			self.visible = false

func _on_PopupMenu_index_pressed(index):
	if PManager.slotavailible < 4 and len(PManager.inventory) != 0:
		match PManager.slotavailible:
			1:
				PManager.slot1 = PManager.inventory[index]
			2:
				PManager.slot2 = PManager.inventory[index]
			3:
				PManager.slot3 = PManager.inventory[index]
		PManager.inventory.remove(index)
		PManager.slotavailible += 1
		_ready()
