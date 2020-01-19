extends KinematicBody2D
onready var Laser = preload("res://JunkoBullet2.tscn")

var speed=500
var direction=Vector2(0,0)
var child=0

func _ready():
	rotation=direction.angle()
	
func _physics_process(delta):
		
	var collision_info = move_and_collide(speed*direction.normalized()*delta)
	if collision_info:
		queue_free()
		if child>0:
			var laser=Laser.instance()
			laser.position=position
			laser.rotation=collision_info.normal.angle()
			get_parent().add_child(laser)
		for i in range(child):
			var bullet=load("res://JunkoBullet.tscn").instance()
			bullet.position=position
			bullet.direction=collision_info.normal.rotated(30-randi()%60)
			bullet.scale=Vector2(0.5,0.5)
			bullet.speed=100
			bullet.child=0
			get_parent().add_child(bullet)	
		
		var collider = collision_info.collider
		# hit MC 
		if collider.has_method('HitMC'):
			queue_free()
			collider.HitMC()
