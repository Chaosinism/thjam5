extends KinematicBody2D

var defaultSpeed = 300
var shootingInverval = .25
var shootingReady = .0
var shootingRange = .4
var hitReady=.0

onready var Bullet = preload("res://ReimuBullet.tscn")

func _ready():
	pass
	
func Shoot(targetPosition):
	var direction=targetPosition-global_position
	var bullet=Bullet.instance()
	bullet.direction=direction
	bullet.life=shootingRange
	bullet.position=$Shooter.global_position
	get_parent().add_child(bullet)	
	get_parent().get_node('Audio_Shoot').play()

func _physics_process(delta):
	
	# handle movement
	var moveVector=Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		moveVector+=Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		moveVector+=Vector2(0,1)
	if Input.is_action_pressed("ui_left"):
		moveVector+=Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		moveVector+=Vector2(1,0)
		
	if Input.is_action_pressed("slow"):
		$Indicator.visible=true
		var collision_info = move_and_collide(moveVector.normalized()*defaultSpeed*.5*delta)
	else:
		$Indicator.visible=false
		var collision_info = move_and_collide(moveVector.normalized()*defaultSpeed*delta)
	
	# handle shooting
	if shootingReady>0:
		shootingReady-=delta
	if shootingReady<.1:
		if Input.is_action_pressed("shoot"):
			Shoot(get_global_mouse_position())
		shootingReady=shootingInverval
	
	# handle being hit
	if hitReady>0:
		hitReady-=delta
	if modulate[1]<1:
		modulate[1]+=.03
	if modulate[2]<1:
		modulate[2]+=.03	
		
func HitMC():
	if hitReady<=0:
		get_parent().get_node('Audio_LoseLife').play()
		modulate[1]=0
		modulate[2]=0
		get_parent().get_node('LifeBar').Hit()
		hitReady=.5