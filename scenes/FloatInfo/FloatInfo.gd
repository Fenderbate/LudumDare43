extends Node2D

var text = "" setget set_text

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(self,"position",position,position + Vector2(0,-50),2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property(self,"modulate",modulate,Color(1,1,1,0),1.75,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	

func set_text(value):
	$Label.text = value

func _on_Tween_tween_completed(object, key):
	queue_free()
