extends Node

export var game_ui = "res://scenes/ui/GameUI.tscn"

export (NodePath) var PlayerPath = null
onready var player : Player = get_node(PlayerPath)

onready var gameUI = $GameUI

func _ready():
	if player.input_mode == Player.InputMode.JOYSTICK:
		print("JOYSTICK")
	else:
		print("NOT JOYSTICK")
		gameUI.queue_free()
