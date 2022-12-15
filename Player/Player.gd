extends KinematicBody

onready var Cam = get_node("/root/Game/Player/Pivoit/Camera")
onready var Pivot = get_node("/root/Game/Player/Pivoit") 

var velocity = Vector3()
var gravity = 2*  -9.8
var speed = 0.5
var max_speed = 10
var on_floor = true

var mouse_senitivity = 0.002

var Target = null

func _ready():
	Global.update_score(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	velocity.y += gravity * _delta
	var falling = velocity.y
	velocity.y = 0

	var desired_velocity = get_input() * speed
	if desired_velocity.length():
		velocity += desired_velocity

	var current_speed = velocity.length()
	velocity = velocity.normalized() * clamp(current_speed, 0, max_speed)
	velocity.y = falling
	
	if get_input() == Vector3.ZERO:
		var tempY = velocity.y
		velocity += velocity.normalized() * 0.5
		velocity = velocity.normalized() * clamp(current_speed, 0, max_speed)
		velocity.y = tempY
	
	if Input.is_action_just_pressed("shoot"):
		$AnimationTree.active = false
		$AnimationPlayer.play("Shoot")
		if Target != null and Target.is_in_group("target"):
			Target.die()
		
	
	if Input.is_action_just_pressed("jump") and on_floor == true:
		on_floor = false
		velocity.y += 20
		$JumpTimer.start()
	if not $AnimationPlayer.is_playing():
		$AnimationTree.active = true
		$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed/max_speed)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if global_transform.origin.y < -100:
		get_tree().change_scene("res://UI/Game_Over.tscn")
	
	if get_node("/root/Game/Drone_container").get_child_count() == 0:
		get_tree().change_scene("res://UI/Win_screen.tscn")
	
	if Global.timer < 0:
		get_tree().change_scene("res://UI/Game_Over.tscn")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_senitivity)
		Pivot.rotate_x(event.relative.y * mouse_senitivity)
		Pivot.rotation_degrees.x = clamp(Pivot.rotation_degrees.x, -30 ,15)
	
func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir -= Cam.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Cam.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= Cam.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Cam.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir


func _on_JumpTimer_timeout():
	on_floor = true
	

func damage():
	Global.update_score(-5)
	get_node("/root/Game/UI").add_damage(0.5)
