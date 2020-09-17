extends KinematicBody2D

const MOVE_SPEED = 300

onready var raycast = $RayCast2D

var has_ball = null

export(int) var THROW_FORCE = 700

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	
	if has_ball != null:
		has_ball.position = $BallHold.global_position
		if Input.is_action_just_pressed("shoot"):
			print("shoot ball!")
			has_ball.throw($BallHold.global_position, rotation, THROW_FORCE)
			has_ball = null
			
	else:
		if Input.is_action_just_pressed("shoot"):
			var coll = raycast.get_collider()
			if raycast.is_colliding() and coll.name == "Ball":
				coll.pick_up()
				has_ball = coll

func kill():
	get_tree().reload_current_scene()
