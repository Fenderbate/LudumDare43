extends Node2D

var target_text = ""
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	display_text(target_text)

func display_text(text, speed = 0.1):
	target_text = text
	$Timer.wait_time = speed
	$Timer.start()

func _on_Timer_timeout():
	
	if $Tall.text != target_text:
		$Tall.text += target_text[index]
		index += 1
		if index < target_text.length() - 1 and index % 1 == 0 and target_text[index] != " ":
			var p = AudioStreamPlayer.new()
			p.stream = Global.talk[randi() % Global.talk.size()]
			p.pitch_scale = rand_range(0.85,1.15)
			p.volume_db = -10
			$Players.add_child(p)
			p.play()
		
		$Timer.start()
	else:
		$RemoveTimer.start()




func _on_RemoveTimer_timeout():
	queue_free()
