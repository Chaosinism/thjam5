extends KinematicBody2D
onready var Bullet = preload("res://JunkoBullet.tscn")

var speed = 300
var targetPosition = Vector2(0,0)

func _ready():
	$AnimationPlayer.play('normal')
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
	var bullet=Bullet.instance()
	bullet.speed=250
	bullet.direction=get_parent().get_node('Reimu').position-position
	bullet.position=$Shooter.global_position
	bullet.child=level
	get_parent().add_child(bullet)
	
	for i in range(level/2):
		var ranDirection=Vector2(256-randi()%512,randi()%256)
		bullet=Bullet.instance()
		bullet.speed=250
		bullet.direction=ranDirection
		bullet.position=$Shooter.global_position
		bullet.child=level
		get_parent().add_child(bullet)