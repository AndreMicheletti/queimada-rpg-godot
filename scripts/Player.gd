extends "res://scripts/PhysicsObject.gd"

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

	if joystickLeft and joystickLeft.is_working:
		move_and_collide(joystickLeft.output * MOVE_SPEED * delta)
	
	if joystickRight and joystickRight.is_working:
		global_rotation = joystickRight.output.angle()

	if has_ball():
		holding_ball.position = $BallHold.global_position
	else:
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.name == "Ball":
			if not coll.is_hot():
				print("BALL HAS BEEN PICKED UP BY ", self)
				coll.pick_up()
				holding_ball = coll

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
	shoot()
