extends Node2D

var health = 4
var inventory = []
var slotavailible = 1
var statusCondition = ""
var currentWeaponis1 = true
var weapon1 = "Sword"
var weapon2 = ""

var movementVector = Vector2.ZERO
var fightVector = Vector2.ZERO

var slot1time = 1
var slot2time = 1
var slot3time = 1

var slot1stop = true
var slot2stop = true
var slot3stop = true

var can_useslot1 = true
var can_useslot2 = true
var can_useslot3 = true

onready var slot1Timer = $slot1Timer
onready var slot2Timer = $slot2Timer
onready var slot3Timer = $slot3Timer

var pause = false

func _on_slot1Timer_timeout():
	can_useslot1 = true
	slot1stop = true

func _on_slot2Timer_timeout():
	can_useslot2 = true
	slot2stop = true

func _on_slot3Timer_timeout():
	can_useslot3 = true
	slot3stop = true
	
func equipWeapon(weapon, slot):
	evaluate("weapon" + slot + " = " + weapon)
	
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
