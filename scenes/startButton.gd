
extends TextureButton

var pressed = false

func _ready():
	pass

func _input_event(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.button_index==BUTTON_LEFT and ev.pressed):
		pressed = true
