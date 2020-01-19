extends KinematicBody2D

var speed=100
var direction=Vector2(0,0)
var life=3

func _ready():
	rotation=direction.angle()
	
func _physics_process(delta):
	speed*=1.01
	speed=clamp(speed,100,300)
	var collision_info = move_and_collide(speed*direction.normalized()*delta)
	if collision_info:
		life-=1
		if life<0:
			queue_free()
		var collider = collision_info.collider
		direction = direction.bounce(collision_info.normal)
		rotation=direction.angle()
		# hit a target
		if collider.has_method('Hit'):
			queue_free()
			collider.Hit(direction)
		if collider.has_method('HitMC'):
			queue_free()
			collider.HitMC()
			
