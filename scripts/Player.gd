extends "res://scripts/PhysicsObject.gd"

class_name Player

enum InputMode {JOYSTICK, MOUSE}
export(InputMode) var input_mode := InputMode.JOYSTICK

const MOVE_SPEED = 300

export(int) var THROW_FORCE = 700

export (NodePath) var joystickLeftPath
onready var joystickLeft : Joystick = get_node(joystickLeftPath)

export (NodePath) var joystickRightPath
onready var joystickRight : Joystick = get_node(joystickRightPath)

onready var raycast = $RayCast2D
onready var anim = $animation

var holding_ball = null


func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)


func _physics_process(delta):
	if anim.is_playing() or is_moving():
		return ._physics_process(delta)
	
	if input_mode == InputMode.JOYSTICK:
		_process_joystick(delta)
	else:
		_process_mouse(delta)

	if has_ball():
		holding_ball.position = $BallHold.global_position
	else:
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.name == "Ball":
			if not coll.is_hot():
				print("BALL HAS BEEN PICKED UP BY ", self)
				coll.pick_up()
				holding_ball = coll


func _process_joystick(delta):
	
	if joystickLeft and joystickLeft.is_working:
		move_and_collide(joystickLeft.output * MOVE_SPEED * delta)
		global_rotation = joystickLeft.output.angle()

	if joystickRight and joystickRight.is_working:
		global_rotation = joystickRight.output.angle()


func _process_mouse(delta):
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
	
	if Input.is_action_just_pressed("shoot") and has_ball():
		shoot()


func hit(projectile_velocity):
	# rotation = atan2(pos.y, pos.x)
	velocity = projectile_velocity
	velocity.x *= .75
	velocity.y *= .75
	anim.play("hit")
	lose_ball()


func kill():
	get_tree().reload_current_scene()


func shoot():
	if not has_ball():
		return
	print("shoot ball!")
	holding_ball.throw(self, $BallHold.global_position, rotation, THROW_FORCE)
	lose_ball()


func has_ball():
	return holding_ball != null


func lose_ball():
	holding_ball = null


func _on_Control_pressed():
	if input_mode == InputMode.JOYSTICK:
		shoot()
