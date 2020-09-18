extends "res://scripts/PhysicsObject.gd"

const HOT_THRESHOLD = 320.0

var holded = false
var character = null

onready var collBox = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ball")


func _physics_process(delta):
	if not is_hot() or not is_moving():
		$FlyParticles.emitting = false
		self.character = null
	._physics_process(delta)


func on_collision(collider):
	if is_hot() and collider.has_method("hit") and not collider == self.character:
		collider.hit(velocity)


func is_hot():
	return velocity.length() > HOT_THRESHOLD


func pick_up():
	if is_hot():
		return
	self.velocity = Vector2()
	self.holded = true
	self.collBox.disabled = true


func throw(shooter, pos, dir, speed):
	self.character = shooter
	self.holded = false
	self.collBox.disabled = false
	self.collision_layer
	self.rotation = dir
	self.velocity = Vector2(speed, 0).rotated(rotation)
	$FlyParticles.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
