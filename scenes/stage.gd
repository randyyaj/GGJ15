extends Node2D

#for changing screen visit
#https://github.com/okamstudio/godot/wiki/tutorial_singletons#scene-switcher
#for loaders
#https://github.com/okamstudio/godot/wiki/Background%20loading

#func _ready()
#get_node("YourCustomButtonNane").connect("pressed",self,"_on_ButtonCustom_pressed")

#func _on_ButtonCustom_pressed():
#get_node("/root/global").goto_scene("res://scene_b.scn")


# Constants --------------------------------------------------------------------
const MAX_CHARGE = 160
var PLATFORMS = ["res://scenes/drawer_kinematic.scn",
	"res://scenes/tv_kinematic.scn",
	"res://scenes/bed_kinematic.scn",
	"res://scenes/couch_kinematic.scn"]

# Flags ------------------------------------------------------------------------
var is_ui_cancel_pressed = false
var is_ui_accept_pressed = false
var is_player_in_air = false
var is_platform_movable = true

# Global vars ------------------------------------------------------------------
var player
var score
var music
var player_anim
var current_platform
var previous_platform
var charge_meter
var lava
var scene
var charge = 0;
var base_platform_position = Vector2(40, 500)

# Functions --------------------------------------------------------------------
func _ready():
	player = get_node('player')
	score = get_node('score')
	charge_meter = get_node('chargeMeter')
	player_anim = player.get_node('playerSprite/playerAnimation')
	lava = get_node('death')
	music = get_node('SamplePlayer2D');
	generate_base_platform()
	generate_random_platform()
	set_process(true)


func _process(delta):
	var player_pos = player.get_pos()
	var lava_pos = lava.get_pos()
	
	if (previous_platform != null):
		previous_platform.move(Vector2(0,0))
	
	if (is_platform_movable):
		current_platform.move(Vector2(0,0))
	
	if (current_platform.is_colliding()):
		reset_position(delta)
	
	if (player_pos.y > lava_pos.y):
		print("DEAD")
		reset_game()
		#TODO prompt game over retry
	
	# SPACE
	if (!player.is_in_air()):
		if Input.is_action_pressed('ui_accept'):
			charge += 2
			is_ui_accept_pressed = true
			player_anim.play('charge')
			charge_meter.set_value(charge)
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
	player.set_angular_velocity(5.0)
	if (charge > MAX_CHARGE):
		charge = MAX_CHARGE
		
	player_anim.play('fly')
	music.play('Jump')
	player.set_linear_velocity(Vector2(charge, -(charge * 2)))


#todo finish this function
func reset_position(delta):
	is_platform_movable = false
	charge_meter.set_value(0)
	player.set_linear_velocity(Vector2(0,0))
	
	if (current_platform.get_pos().x > 35):
		player.set_pos(Vector2(player.get_pos().x - 400 * delta, player.get_pos().y))
		current_platform.set_pos(Vector2(current_platform.get_pos().x - 400 * delta, current_platform.get_pos().y))
		previous_platform.set_pos(Vector2(previous_platform.get_pos().x - 400 * delta, previous_platform.get_pos().y))
	else:
		is_platform_movable = true 
		score.increment()
		generate_random_platform()
		#previous_platform.free()
		#previous_platform = current_platform


func reset_game():
	charge_meter.set_value(charge)
	
	if (previous_platform != null):
		previous_platform.free()
	
	if (current_platform != null):
		current_platform.free()
	
	is_platform_movable = true
	generate_base_platform()
	generate_random_platform()
	player.set_pos(Vector2(70, 490))
	player.set_rot(0)
	player.set_linear_velocity(Vector2(0,0))
	previous_platform.set_pos(Vector2(35, 510))
	score.reset()
	

func get_random(number):
	randomize()
	return randi() % number


func get_random_range(begin, end):
	randomize()
	return rand_range(begin, end)


func generate_random_platform():
	var x_coordinate = get_random_range(200,680)
	var y_coordinate = 500
	var random = get_random(4)
	var scene = load(PLATFORMS[random])
	var node = scene.instance()
	
	if (random == 2):
		y_coordinate = 520
	
	add_child(node)
	node.set_pos(Vector2(x_coordinate, y_coordinate))
	node.set_scale(Vector2(3,3))
	#node.set_z(1)
	move_child(node, 0)
	current_platform = node
	current_platform.set_collide_with_rigid_bodies(true)
	current_platform.set_collide_with_character_bodies(true)
	
	
func generate_base_platform():	
	var random = get_random(4)
	var scene = load(PLATFORMS[random])
	var node = scene.instance()
	
	add_child(node)
	node.set_pos(Vector2(20, 510))
	node.set_scale(Vector2(3,3))
	move_child(node, 0)
	previous_platform = node
	previous_platform.set_collide_with_rigid_bodies(true)
	previous_platform.set_collide_with_character_bodies(true)
	
	

#func prompt_game_over:

