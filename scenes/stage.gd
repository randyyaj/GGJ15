
extends Node2D

# Constants --------------------------------------------------------------------
const MAX_CHARGE = 100

# Flags ------------------------------------------------------------------------
var is_ui_cancel_pressed = false
var is_ui_accept_pressed = false

# Global vars ------------------------------------------------------------------
var player
var current_platform
var previous_platform
var scene
var charge = 0;

# Functions --------------------------------------------------------------------
func _ready():
	player = get_node('player')
	previous_platform = get_node('drawer')
	generate_random_platform()
	set_process(true)


func reset_position(delta):
	if (player.get_pos().x != 0):
		player.move_local_x(-delta*200, false)
		
	#current_platform.move_local_x(delta*200, false)
	#previous_platform.free()
	#remove_and_delete_child(child_node)

func generate_random_platform():
	var platforms = ["res://scenes/drawer.scn",
		"res://scenes/tv.scn",
		"res://scenes/bed.scn",
		"res://scenes/couch.scn"]
	
	randomize()
	var random = randi() % 4
	
	randomize()
	var x_coordinate = rand_range(200,680)
	var y_coordinate = 500
	
	if (random == 2):
		y_coordinate = 520
	
	scene = load(platforms[random])
	var node = scene.instance()
	add_child(node)
	node.set_pos(Vector2(x_coordinate, y_coordinate))
	node.set_scale(Vector2(3,3))
	#node.set_z(1)
	move_child(node, 1)
	
	current_platform = node
	

#TODO: prevent jumping if character is already moving
	
func check_landing():
	#if get_node('player/collsion2d').collide(get_node('drawer/collision2d')): #player.get_collision.collide(previous_platform):
	#	print('oh yeah!')
	
	#player.get_contact_count()
	# if in lava then end game
	reset_position()
	generate_random_platform()
	pass #If player lands on current_platform and is no longer moving then reset position	

func _process(delta):
	var player_pos = player.get_pos()
	
	# SPACE
	if Input.is_action_pressed('ui_accept'):
		charge += 2
		is_ui_accept_pressed = true
	else:
		if is_ui_accept_pressed == true:
			launch_player(charge)
			charge = 0
			is_ui_accept_pressed = false
		

	# ESCAPE
	if Input.is_action_pressed('ui_cancel'):
		if is_ui_cancel_pressed == false:
			print('cancel pressed')
			is_ui_cancel_pressed = true
	else:
		is_ui_cancel_pressed = false

func launch_player(charge):
	#player.set_angular_velocity(1.0)
	player.set_linear_velocity(Vector2(charge, -(charge)))
	#print(charge)
