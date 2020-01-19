extends Control

var Intro = preload("res://Intro.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Particle1.emitting=true
	$Particle2.emitting=true
	$Particle3.emitting=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func StartGame():
	hide()
	get_parent().add_child(Intro.instance())

