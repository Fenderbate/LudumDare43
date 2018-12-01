extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("draw",self,"_on_draw_emitted")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	pass


func _on_Building_input_event(viewport, event, shape_idx, building_name):
	
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		match building_name:
			"Granary":
				Global.food += 10
			"Factory":
				pass
			"Barn":
				pass
			"Village":
				emit_signal("draw")
				pass
		

func _on_draw_emitted():
	draw_line(Vector2(0,0),Vector2(100,100),Color(1,1,1,1),10)


