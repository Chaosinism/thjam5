extends KinematicBody2D

var speed=1000
var direction=Vector2(0,0)
var life=8

func _ready():
	pass
	
func _physics_process(delta):
	var tracking=get_parent().get_node('Reimu').position-position
	direction = 0.98 * direction.normalized() + .02 * tracking.normalized()
	
	var collision_info = move_and_collide(speed*direction.normalized()*delta*abs(sin(life*delta*2*5*PI)))
	if collision_info:
		queue_free()

		var collider = collision_info.collider
		# hit MC
		if collider.has_method('HitMC'):
			collider.HitMC()

	life-=delta
	if life<0:
		queue_free()