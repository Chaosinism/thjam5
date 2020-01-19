extends KinematicBody2D

var direction=Vector2(0,0)
var speed=50
var status=0	# 0 - normal, 1 - hit, 2 - dead

func Appearance(i):
	$Sprite.animation='type'+str(i)
	
func _ready():
	Appearance(randi()%3+1)
	var x=256-randi()%512
	var y=256-randi()%512
	direction=Vector2(x,y).normalized()
	$AnimationPlayer.play('normal')
	
func _physics_process(delta):
	
	if status==0:
		var collision_info = move_and_collide(speed*direction.normalized()*delta)		
		if collision_info:
			var collider = collision_info.collider
			
			# walk in a wall
			if collider.get_collision_layer_bit(1)==true or collider.get_collision_layer_bit(7)==true:
				direction = direction.bounce(collision_info.normal)
			
	if status==1 and $AnimationPlayer.is_playing()==false:
		#queue_free()
		get_parent().SpawnFairy()
		status=2

func Hit(impulse):
	if status!=0:
		return
	status=1
	get_parent().FairyDied(self)
	scale[0]=int(impulse[0]>0)*2-1
	$AnimationPlayer.play('die')
	$CollisionShape2D.disabled=true
	get_parent().get_node('PopBar').Worse()