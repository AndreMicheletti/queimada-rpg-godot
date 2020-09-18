extends KinematicBody2D

const STOP_THRESHOLD = 85.0
const DRAG = .97
const HIT_DRAG = .80

var velocity = Vector2()
var rotation_velocity = Vector2()


func _physics_process(delta):
	if velocity.length() <= STOP_THRESHOLD:
		velocity = Vector2()
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		reduce_velocity(HIT_DRAG)
		on_collision(collision.collider)
	reduce_velocity(DRAG)


func on_collision(collider):
	pass


func reduce_velocity(ratio):
	# ration must between 0 and 1 (example: if 0.97 will reduce velocity by 3%)
	velocity.x *= ratio
	velocity.y *= ratio

func is_moving():
	return velocity.length() >= STOP_THRESHOLD


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
