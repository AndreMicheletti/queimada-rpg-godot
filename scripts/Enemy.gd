extends "res://scripts/PhysicsObject.gd"

const MOVE_SPEED = 200

onready var raycast = $RayCast2D

var player = null

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	._physics_process(delta)

func hit(velocity):
	kill()

func kill():
	queue_free()

func set_player(p):
	player = p
