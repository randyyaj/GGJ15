
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var JUMP_VELOCITY = 200

func _ready():
	# Initalization here
	pass

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	
	if (Input.is_action_pressed('ui_accept')):
		lv.y = -JUMP_VELOCITY
		

