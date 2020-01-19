extends Control

var Intro = preload("res://Intro.tscn")
var Selection = preload("res://SelectDifficulty.tscn")
var Menu = preload("res://Menu.tscn")

var difficulty = 0
var startingMoney = [2000,1500,1500,1500]
var opponentMoney = [1500,1500,1800,2000]
var battleLevel = [0,2,4,6]
var currentBGM = null

func _ready():
	$Particle1.emitting=true
	$Particle2.emitting=true
	$Particle3.emitting=true

func StartGame():
	hide()
	get_parent().add_child(Intro.instance())

func SelectDifficulty():
	get_parent().add_child(Selection.instance())
	
func SpawnMenu(d):
	var newGame=Menu.instance()
	newGame.mcCash=startingMoney[d]
	newGame.opCash=opponentMoney[d]
	newGame.performerExp=[battleLevel[d]-1,battleLevel[d]-1,battleLevel[d]-1]
	get_parent().add_child(newGame)
	
func Reset():
	show()
	$GameStart.disabled=false
	

	
func AudioFadeIn(name):
	if name==currentBGM:
		return
	$Tween.interpolate_property(get_node('Bgm'+name), "volume_db", -50, 5, 2, 1, Tween.EASE_IN, 0)
	$Tween.start()
	if currentBGM!=null:
		$Tween.interpolate_property(get_node('Bgm'+currentBGM), "volume_db", 5, -50, 2, 1, Tween.EASE_IN, 0)
		$Tween.start()
	currentBGM=name