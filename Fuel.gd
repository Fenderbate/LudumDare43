extends Area2D


enum types {PEOPLE,FOOD,RESOURCES,GOLD}

var type  = types.GOLD

var follow_mouse = false

var collided_with = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	
	if follow_mouse:
		position = get_global_mouse_position()


func _on_Fuel_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			follow_mouse = true
			collision_layer = 0
		else:
			follow_mouse = false
			collision_layer = 1
			

