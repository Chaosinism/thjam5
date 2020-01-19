extends KinematicBody2D

var speed=500
var direction=Vector2(0,0)
var life=0.2

func _ready():
	rotation=direction.angle()
	
func _physics_process(delta):
	life-=delta
	if life<0:
		queue_free()
		
	var collision_info = move_and_collide(speed*direction.normalized()*delta)
	if collision_info:
		queue_free()
		var collider = collision_info.collider
		
		# hit a target
		if collider.has_method('Hit'):
			collider.Hit(direction)
		if collider.has_method('HitMC'):
			collider.HitMC()
			
