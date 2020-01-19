extends KinematicBody2D
onready var Bullet = preload("res://MeilingBullet.tscn")

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
	var colorList=[Color(1.5,.5,.6,1), Color(.5,.8,1,1),Color(.5,1,.5,1),Color(1.5,1.2,.0,1)]
	if randi()%2==0:
		for i in range(8+level*4):
			var ranDirection=Vector2(256-randi()%512,256-randi()%512)
			var bullet=Bullet.instance()
			bullet.speed=200+level*80
			bullet.tint=colorList[randi()%4]
			bullet.direction=ranDirection
			bullet.finalDirection=ranDirection
			bullet.delay=.1*(ranDirection.angle()+PI+2*PI*(randi()%2) )
			bullet.position=$Shooter.global_position
			get_parent().add_child(bullet)
	else:
		for i in range(4+level*2):
			var ranDirection=Vector2(256-randi()%512,256-randi()%512)
			var bullet=Bullet.instance()
			bullet.speed=100+level*60
			bullet.tint=colorList[0]
			bullet.direction=ranDirection
			bullet.finalDirection=Vector2(0,1)
			bullet.position=$Shooter.global_position
			get_parent().add_child(bullet)		