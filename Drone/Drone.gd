extends KinematicBody

var radius = 50
var angel = 0
export var height = 30

export var speed = 5

var health = 100

func _ready():
	randomize()
	angel = randf() * 2 * PI
	new_position(angel)
	
func new_position(a):
	var position = Vector3(0,height,0)
	position.x = radius * cos(a)
	position.z = radius * sin(a)
	look_at(position, Vector3(0,1,0))
	$Tween.interpolate_property(self, "global_transform:origin", global_transform.origin, position, speed, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(_delta):
	if get_node("/root/Game/Target_container").get_child_count() == 0:
		$Sprite3D.show()
	else:
		$Sprite3D.hide()

func _on_Tween_tween_all_completed():
	angel += PI/2 + (randf() * (PI/2))
	angel = wrapf(angel, 0, 2*PI)
	new_position(angel)


func _on_Area_body_entered(body):
	body.damage()

func die():
	if get_node("/root/Game/Target_container").get_child_count() == 0:	
		health -= 10
		if health <= 0:
			Global.update_score(100)
			queue_free()
