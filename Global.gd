extends Node

var timer = 0
var score = 0

func ready():
	update_score(0)

func reset():
	timer = 0
	score = 0
	update_score(score)

func _input(_event):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func update_score(d):
	score += d
	if get_node_or_null("/root/Game/UI/Score") != null:
		get_node("/root/Game/UI/Score").text = "Score: " + str(score)

func update_timer():
	var t_m = floor(timer/60.0)
	var t_s = timer % 60
	var t = "Time: %02d" % t_m
	t += ":%02d" % t_s
	get_node("/root/Game/UI/Time").text = "Time: " + t
