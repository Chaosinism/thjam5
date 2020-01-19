extends KinematicBody2D
onready var Bullet = preload("res://YachieBullet.tscn")
onready var Bullet2 = preload("res://YachieBullet2.tscn")
onready var Shield = preload("res://YachieShield.tscn")

var speed=75
var target=self
var status=0
var schedule=0
var timer=.5
var level=1
var passiveVector=Vector2(0,0)

func _ready():
	if level>2:
		var shield=Shield.instance()
		shield.position=$Shooter.position
		shield.scale=Vector2(.5,.5)
		add_child(shield)

func _physics_process(delta):
	timer-=delta
		
	if status==0:
		if target.position.distance_to(position)>100:
			move_and_collide((target.position-position).normalized()*speed*delta)
		if timer<0:
			timer=.25
			schedule+=1
			if schedule%10>=level-1:
				Shoot()
			else:
				Fireball()
	else:
		move_and_collide(passiveVector*speed*5*delta)
		passiveVector*=.9
		if timer<0:
			timer=.25
			schedule+=1
			if schedule>4:
				$CollisionShape2D.disabled=true
			if schedule>40:
				Recover()
	
func Shoot():
	var direction=target.position-$Shooter.global_position
	var bullet=Bullet.instance()
	bullet.direction=direction
	bullet.life=.5
	bullet.position=$Shooter.global_position
	get_parent().add_child(bullet)

func Fireball():
	var direction=get_parent().get_node('Reimu').position-$Shooter.global_position
	var bullet=Bullet2.instance()
	bullet.direction=direction
	bullet.position=$Shooter.global_position
	get_parent().add_child(bullet)	

func Hit(impulse):
	if status!=0:
		return
	passiveVector=impulse.normalized()
	rotation=-PI/2
	schedule=0
	status=1
	$Sprite.play('faint')

func Recover():
	status=0
	$Sprite.play('normal')
	rotation=0
	$CollisionShape2D.disabled=false