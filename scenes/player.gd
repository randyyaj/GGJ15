extends RigidBody2D

var IN_AIR = 0

var is_in_air = false

func _integrate_forces(s):
	#print("HERE ", s)
	#print(s.get_contact_count())
	if (s.get_contact_count() == IN_AIR):
		is_in_air = true
	else:
		is_in_air = false

func is_in_air():
	return is_in_air