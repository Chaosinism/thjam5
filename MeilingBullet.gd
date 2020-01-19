extends KinematicBody2D

var speed=500
var direction=Vector2(0,0)
var finalDirection=Vector2(0,0)
var delay=-.1
var tint=Color(1,1,1,1)

func _ready():
	rotation=direction.angle()
	$Sprite.modulate=tint
	
func _physics_process(delta):
	delay-=delta
	if delay>0:
		return
		
	direction=.98*direction.normalized()+.02*finalDirection.normalized()
	rotation=direction.angle()
	var collision_info = move_and_collide(speed*direction.normalized()*delta)
	if collision_info:
		queue_free()
		var collider = collision_info.collider
		
		# hit MC
		if collider.has_method('HitMC'):
			collider.HitMC()
