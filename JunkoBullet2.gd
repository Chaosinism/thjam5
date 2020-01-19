extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('normal')
	

func _physics_process(delta):
	if $AnimationPlayer.is_playing()==false:
		queue_free()
		
	var collision_info = move_and_collide(Vector2(0,0))
	if collision_info:
		queue_free()
		
		var collider = collision_info.collider
		# hit MC
		if collider.has_method('HitMC'):
			collider.HitMC()