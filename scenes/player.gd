
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var JUMP_VELOCITY = 200

func _ready():
	# Initalization here
	pass

func _integrate_forces(s):
	#print("HERE ", s)
	print(s.get_contact_count())
	#print(s.get_contact_count())
	if (s.get_contact_count() == 0):
		Input.disconnect()

#func collisionCallback():
	

	


