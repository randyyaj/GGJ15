
extends Node2D

# Constants --------------------------------------------------------------------
const MAX_CHARGE = 100

# Flags ------------------------------------------------------------------------
var is_ui_cancel_pressed = false
var is_ui_accept_pressed = false

# Global vars ------------------------------------------------------------------
var player
var playerAnim
var charge = 0;

# Functions --------------------------------------------------------------------
func _ready():
	player = get_node('player')
	playerAnim = player.get_node('playerSprite').get_node('playerAnimation')
	set_process(true)


func _process(delta):
	var player_pos = player.get_pos()

	# SPACE
	if Input.is_action_pressed('ui_accept'):
		charge += 2
		is_ui_accept_pressed = true
		playerAnim.play('charge')
		print(charge)
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
	player.set_angular_velocity(10.0)
	playerAnim.play('fly')
	player.set_linear_velocity(Vector2(charge, -(charge * 2)))
	print(charge)
