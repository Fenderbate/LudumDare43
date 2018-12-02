extends Node2D

var foodrate = 1.0 setget set_foodrate
var pplrate = 1 setget set_pplrate
var resrate = 2.0 setget set_resrate
var goldrate = 10.0 setget set_goldrate

var up = false

var click_reduce = 0.05

var factory_tick_max = 2.0
var granary_tick_max = 1.0
var village_tick_max = 3.0

var no_people = false
var no_gold = false
var no_resources = false
var no_food = false

func set_foodrate(value):
	foodrate = value

func set_pplrate(value):
	pplrate = value

func set_resrate(value):
	resrate = value

func set_goldrate(value):
	goldrate = value

func _ready():
	randomize()
	
	
	
	set_menu_info_nopar()
	
	$Timers/FactoryTick.wait_time = factory_tick_max
	$Timers/VillageTick.wait_time = village_tick_max
	$Timers/GranaryTick.wait_time = granary_tick_max
	$Timers/FactoryTick.start()
	$Timers/GranaryTick.start()
	$Timers/VillageTick.start()
	
	$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Dark,"energy",$Dark.energy,0.8,5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_menu_info_nopar()
	
	

func _input(event):
	
	if event is InputEventMouseMotion:
		$Camera.position += event.relative/20

func _draw():
	pass
	
func info_text(text,position):
	
	$Info.rect_position = position - $Info.rect_size/2
	$Info.text = text

func spawn_floater(start_position,text,icon = null):
	var f = Global.floater.instance()
	f.position = (start_position + Vector2(0,-100)) + Vector2(rand_range(-25,25),rand_range(-25,25))
	f.text = text
	add_child(f)
	

func set_menu_info_nopar():
	$UI/TopMenu/Food/Value.text = str(Global.food)
	$UI/TopMenu/People/Value.text = str(Global.people)
	$UI/TopMenu/Resources/Value.text = str(Global.resources)
	$UI/TopMenu/Gold/Value.text = str(Global.gold)
	
	if Global.gold <= 0 and !no_gold:
		text_bubble($Castle,"My Lord! We have no gold left!")
		no_gold = true
	elif Global.gold > 0 and no_gold:
		text_bubble($Castle,"My Lord! We have gold again!!")
		no_gold = false
	
	if Global.people <= 0 and !no_people:
		get_tree().paused = true
		$UI/Lost.show()
		print("implement losing animation")
	
	if Global.resources <= 0 and !no_resources:
		text_bubble($Factory,"We ran out of resources my Lord!")
		no_resources = true
	elif Global.resources > 0 and no_resources:
		text_bubble($Factory,"We managed to get some resources my Lord!")
		no_resources = false
	
	if Global.food <= 0 and !no_food:
		text_bubble($Granary,"My Lord! The people are hungry, we need food!")
		no_food = true
	elif Global.food > 0 and no_food:
		text_bubble($Granary,"Finally we can eat again! Thank you my Lord!")
		no_food = false

func text_bubble(target,text):
	
	for child in target.get_children():
		if child.name.find("TextBubble") != -1:
			child.queue_free()
	
	var b = Global.bubble.instance()
	b.position = Vector2(0,0)
	b.target_text = text
	target.add_child(b)

func animate(sprite):
	var ap = AnimationPlayer.new()
	var anim = Global.boop_animation
	#print(anim.track_get_path(0))
	$AnimPlayers.add_child(ap)
	anim.track_set_path(0,str(sprite,":scale"))
	ap.add_animation("booop",anim)
	ap.play("booop")
	
	if $AnimPlayers.get_child_count() >= 10:
		$AnimPlayers.get_children()[0].queue_free()

func _on_Building_input_event(viewport, event, shape_idx, building_name):
	
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		match building_name:
			"Castle":
				Global.gold += 10
				set_menu_info_nopar()
				spawn_floater($Castle.position,"Gold +10")
				animate($Castle/Sprite.get_path())
			"Factory":
				if $Timers/FactoryTick.wait_time > factory_tick_max / 2:
					$Timers/FactoryTick.wait_time -= $Timers/FactoryTick.wait_time * click_reduce
					animate($Factory/Sprite.get_path())
					
					if $Timers/ClickedTimers/FactoryTimer.time_left <= 0:
						text_bubble($Factory,Global.click_response_generic[randi() % Global.click_response_generic.size()])
						$Timers/ClickedTimers/FactoryTimer.start()
					
				return
				Global.food -= Global.factory_needs.Food
				Global.people -= Global.factory_needs.People
				Global.gold -= Global.factory_needs.Gold
			"Granary":
				if $Timers/GranaryTick.wait_time > granary_tick_max / 2:
					$Timers/GranaryTick.wait_time -= $Timers/GranaryTick.wait_time * click_reduce
					animate($Granary/Sprite.get_path())
					
					if $Timers/ClickedTimers/GranaryTimer.time_left <= 0:
						text_bubble($Granary,Global.click_response_generic[randi() % Global.click_response_generic.size()])
						$Timers/ClickedTimers/GranaryTimer.start()
				
				return
				Global.resources -= Global.granary_needs.Resources
				Global.people -= Global.granary_needs.People
				Global.gold -= Global.granary_needs.Gold
			"Village":
				if $Timers/VillageTick.wait_time > village_tick_max / 2:
					$Timers/VillageTick.wait_time -= $Timers/VillageTick.wait_time * click_reduce
					animate($Village/Sprite.get_path())
					
					if $Timers/ClickedTimers/VillageTimer.time_left <= 0:
						text_bubble($Village,Global.village_response[randi() % Global.village_response.size()])
						$Timers/ClickedTimers/VillageTimer.start()
				return
				Global.resources -= Global.village_needs.Resources
				Global.food -= Global.village_needs.Food
				Global.gold -= Global.village_needs.Gold
				
			"Dungeon":
				return
				Global.people -= Global.dungeon_needs.People
				Global.resources -= Global.dungeon_needs.Resources
				Global.food -= Global.dungeon_needs.Food
				Global.gold -= Global.dungeon_needs.Gold
			_:
				print("oops... ",building_name)

func _on_Building_mouse_entered(building_name):
	match building_name:
		"Granary":
			info_text("Granary",$Granary.position + Vector2(0,-50))
		"Factory":
			info_text("Factory",$Factory.position + Vector2(0,-50))
		"Castle":
			info_text("Castle",$Castle.position + Vector2(0,-50))
		"Village":
			info_text("Village",$Village.position + Vector2(0,-50))
		"Dungeon":
			info_text("Dungeon",$Dungeon.position + Vector2(0,-50))
		_:
			print(building_name)


func _on_Building_mouse_exited():
	$Info.text = ""

func _on_ReduceTick_timeout():
	
	
	if $Timers/FactoryTick.wait_time < factory_tick_max:
		$Timers/FactoryTick.wait_time += factory_tick_max * click_reduce
	if $Timers/GranaryTick.wait_time < granary_tick_max:
		$Timers/GranaryTick.wait_time += factory_tick_max * click_reduce
	if $Timers/VillageTick.wait_time < village_tick_max:
		$Timers/VillageTick.wait_time += factory_tick_max * click_reduce




func _on_Tween_tween_completed(object, key):
	match object.name:
		"Demon":
			if !up:
				$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,-100),0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sky,"color",$Sky.color,Color("00dbff"),0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Dark,"energy",$Dark.energy,0,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				Global.food -= round(Global.food * 0.25) if Global.food > 35 else 15
				Global.people -= round(Global.people * 0.25) if Global.people > 15 else 5
				Global.resources -= round(Global.resources * 0.25) if Global.resources > 35 else 20
				Global.gold -= round(Global.gold * 0.25) if Global.gold > 400 else 100
				set_menu_info_nopar()
				up = true
			else:
				$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Dark,"energy",$Dark.energy,0.8,5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				up = false
		"BotMenu":
			if $Timers/GodTimer.time_left > 0:
				$UI/BotMenu.rect_position.y = 720
		_:
			return
			print(object.name)


func _on_FactoryTick_timeout():
	if Global.food <= 0 and Global.gold <= 0:
		return
	Global.resources += resrate
	spawn_floater($Factory.position,str("Resources +",resrate))


func _on_GranaryTick_timeout():
	if Global.gold <= 0:
		return
	Global.food += foodrate
	spawn_floater($Granary.position,str("Food +",foodrate))

func _on_Villagetick_timeout():
	if Global.food <= 0 and Global.gold <= 0:
		return
	Global.people += pplrate
	spawn_floater($Village.position,str("Poeple +",pplrate))

func _on_PopupButton_button_down():
	$UI/BotMenu/BotMenuTween.stop($UI/BotMenu,"rect_position")
	if $UI/BotMenu/PopupButton/Arrow.scale.y == 1:
		if $Timers/GodTimer.time_left > 0:
			return
		$UI/BotMenu/BotMenuTween.interpolate_property(
		$UI/BotMenu,"rect_position",
		$UI/BotMenu.rect_position,
		Vector2(0,420),
		2,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
		)
		$UI/BotMenu/PopupButton/Arrow.scale.y = -1
		$UI/BotMenu/BotMenuTween.start()
	elif $UI/BotMenu/PopupButton/Arrow.scale.y == -1:
		$UI/BotMenu/BotMenuTween.interpolate_property(
		$UI/BotMenu,"rect_position",
		$UI/BotMenu.rect_position,
		Vector2(0,720),
		1,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT
		)
		$UI/BotMenu/PopupButton/Arrow.scale.y = 1
		$UI/BotMenu/BotMenuTween.start()

func _on_God_button_down(namee):
	if $Timers/GodTimer.time_left > 0:
			return
	match namee:
		"Kaja":
			if Global.gold > 0:
				Global.gold -= 200
				Global.food += 100
		"Anyag":
			if Global.gold > 0:
				Global.gold -= 200
				Global.resources += 100
		"Ember":
			if Global.gold > 0:
				Global.gold -= 200
				Global.people += 50
		"Arany":
			if Global.people > 0 and Global.resources > 0 and Global.food > 0:
				Global.gold += 1000
				Global.resources -= 100
				Global.food -= 50
				Global.people -= 20
	
	set_menu_info_nopar()
	_on_PopupButton_button_down()
	
	$Timers/GodTimer.start()

