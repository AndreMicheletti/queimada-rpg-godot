extends KinematicBody2D

const STOP_THRESHOLD = 85.0
const HOT_THRESHOLD = 320.0
const DRAG = .97
const HIT_DRAG = .80

var holded = false
var velocity = Vector2()

onready var collBox = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ball")


func _physics_process(delta):
	#if current_speed <= 5.0:
	#	current_speed = 0
	#	velocity = Vector2()
	#	return
	if not is_hot():
		$FlyParticles.emitting = false
	if velocity.length() <= STOP_THRESHOLD:
		velocity = Vector2()
		$FlyParticles.emitting = false
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		reduce_velocity(HIT_DRAG)
		if is_hot() and collision.collider.has_method("hit"):
			collision.collider.hit()
	reduce_velocity(DRAG)


func reduce_velocity(ratio):
	# ration must between 0 and 1 (example: if 0.97 will reduce velocity by 3%)
	velocity.x *= ratio
	velocity.y *= ratio


func is_hot():
	return velocity.length() > HOT_THRESHOLD


func pick_up():
	velocity = Vector2()
	holded = true
	collBox.disabled = true


func throw(pos, dir, speed):
	holded = false
	collBox.disabled = false
	rotation = dir
	# position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	$FlyParticles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
