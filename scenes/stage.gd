extends Node2D

# Constants --------------------------------------------------------------------
const MAX_CHARGE = 100

# Flags ------------------------------------------------------------------------
var is_ui_cancel_pressed = false
var is_ui_accept_pressed = false
var is_player_in_air = false

# Global vars ------------------------------------------------------------------
var player
var current_platform
var previous_platform
var lava
var scene
var charge = 0;
var base_platform_position = Vector2(40, 500)

# Functions --------------------------------------------------------------------
func _ready():
	player = get_node('player')
	lava = get_node('death')
	generate_random_platform()
	set_process(true)


func reset_position():
	if (player.get_pos().x != 0):
		#player.move_local_x(200, false)
		#player.move_local_y(-100, false)
		player.set_pos(Vector2(40, 500))
		current_platform.free()
		
	#if (current_platform.get_pos().x != 0):
#		current_platform.move_local_x(200, false)
		
	#previous_platform.free()
	#remove_and_delete_child(previous_platform)
	#previous_platform = current_platform


func reset_game():
	previous_platform.free()
	current_platform.free()
	generate_random_platform()
	player.set_pos(Vector2(40, 500))
	previous_platform.set_pos(Vector2(35, 510))

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
	move_child(node, 0)
	current_platform = node
	
	scene = load(platforms[random])
	node = scene.instance()
	add_child(node)
	node.set_pos(Vector2(20, 510))
	node.set_scale(Vector2(3,3))
	move_child(node, 0)
	previous_platform = node

func _process(delta):
	var player_pos = player.get_pos()
	var lava_pos = lava.get_pos()
	
	if (player_pos.y > lava_pos.y):
		print("DEAD")
		reset_game()
		#TODO prompt game over retry
	
	#print(previous_platform.get_size())
	
	#if (player_pos.y == current_platform.get_pos().y):
	#	print("LANDED")
	
	# SPACE
	if (!player.is_in_air()):
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


#func prompt_game_over:
