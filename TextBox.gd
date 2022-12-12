extends CanvasLayer

func _ready():
	hide()

func hide():
	offset.y = 128

func show():
	offset.y = 0

func set_text(text):
	$TextContainer/Background/VBoxContainer/HBoxContainer/Text.text = text

func set_name(text):
	$NameContainer/Background/Name.text = text
