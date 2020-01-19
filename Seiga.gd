extends KinematicBody2D
onready var Bullet = preload("res://SeigaBullet.tscn")
onready var Bullet2 = preload("res://SeigaBullet2.tscn")

var speed = 300
var targetPosition = Vector2(0,0)

func _ready():
	pass

func _physics_process(delta):
	if targetPosition.distance_to(position)>10:
		move_and_collide((targetPosition-position).normalized()*speed*delta)
	if modulate[1]<1:
		modulate[1]+=.05
	if modulate[2]<1:
		modulate[2]+=.05

func Hit(impulse):
	modulate[1]=0
	modulate[2]=0
	get_parent().get_node('PopBar').Better()
	
func Attack(level):
	for i in range(8):
		var bullet=Bullet.instance()
		bullet.speed=200
		var randAngle=(15*(level-1)-randi()*30*(level-1))/360
		bullet.direction=Vector2(1,0).rotated(0.25*PI*i)
		bullet.rotation=0.25*PI*i
		bullet.finalDirection=Vector2(1,0).rotated(0.25*PI*i+randAngle)
		bullet.position=$Shooter.global_position
		get_parent().add_child(bullet)		
	var ghostAmount=[0,1,1,2,2,2,2,2,2,2]
	for i in range(ghostAmount[level]):
		var ranDirection=Vector2(256-randi()%512,randi()%256)
		var bullet=Bullet2.instance()
		bullet.speed=200
		bullet.direction=ranDirection
		bullet.position=$Shooter.global_position
		get_parent().add_child(bullet)