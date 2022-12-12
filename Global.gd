extends Node

var textBox = null

var tile_size = 16

var state = "" # can be inText{n} or ""
var text_i = 0
var kept_vars_textbox = {
	"box": null,
	"name": null,
	"text": null
}

var flags = {
	"talkedBefore": false
}
var player_interact_enabled = true

func showText(name, text, box):
	player_interact_enabled = false
	state = "inText"
	box.set_text(text[text_i])
	box.set_name(name)
	box.show()
	kept_vars_textbox.box = box
	kept_vars_textbox.name = name
	kept_vars_textbox.text = text

func _input(event):
	match state:
		"inText":
			if Input.is_action_just_pressed("game_interact"):
				text_i += 1
				if text_i == len(kept_vars_textbox.text):
					state = ""
					text_i = 0
					kept_vars_textbox.box.hide()
				else:
					showText(kept_vars_textbox.name, kept_vars_textbox.text, kept_vars_textbox.box)
