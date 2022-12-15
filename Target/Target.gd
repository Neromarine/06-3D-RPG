extends StaticBody


func _ready():
	pass

func die():
	Global.update_score(10)
	queue_free()
