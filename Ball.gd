extends KinematicBody2D

const STOP_THRESHOLD = 20.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var holded = false

var velocity = Vector2()
var current_speed = 0
var drag = 25
var hit_drag = 100

onready var collBox = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ball")
	
func _physics_process(delta):
	#if current_speed <= 5.0:
	#	current_speed = 0
	#	velocity = Vector2()
	#	return
	print(velocity, " - " , velocity.length())
	if abs(velocity.x) <= STOP_THRESHOLD and abs(velocity.y) <= STOP_THRESHOLD:
		velocity = Vector2()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		current_speed -= hit_drag
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	velocity.x *= .94
	velocity.y *= .94

func pick_up():
	current_speed = 0
	holded = true
	collBox.disabled = true
	
func throw(pos, dir, speed):
	holded = false
	collBox.disabled = false
	rotation = dir
	# position = pos
	current_speed = speed
	velocity = Vector2(speed, 0).rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
