extends KinematicBody2D

var speed=500
var direction=Vector2(0,0)
var finalDirection=Vector2(0,0)

func _ready():
	$AnimationPlayer.play('normal')
	
func _physics_process(delta):
	direction = 0.98 * direction.normalized() + .02 * finalDirection.normalized()
	speed *= 1.01
	rotation=direction.angle()
	
	var collision_info = move_and_collide(speed*direction.normalized()*delta)
	if collision_info:
		queue_free()

		var collider = collision_info.collider
		# hit MC
		if collider.has_method('HitMC'):
			collider.HitMC()
