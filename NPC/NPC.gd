extends KinematicBody

onready var Dialogue = get_node("/root/Game/UI/Dialogue")

var dialogue = ["Wellcome to the Game! (press e to continue!)", 
"Your life depend your speed and accuracy!",
"Shoot the targets and the drone before you run out of time!",
"The challenge starts as you press e !"]

func _ready():
	$AnimationPlayer.play("Idle")
	Dialogue.connect("finished_dialogue", self, "finished")


func _on_Area_body_entered(_body):
	Dialogue.start_dialogue(dialogue)


func _on_Area_body_shape_exited():
	Dialogue.hide_dialogue()

func finished():
	get_node("/root/Game/Target_container").show()
	Global.timer = 120
	Global.update_timer()
	get_node("/root/Game/UI/Timer").start()
