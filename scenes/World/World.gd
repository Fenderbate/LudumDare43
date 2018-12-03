extends Node2D

var foodrate = 1.0 setget set_foodrate
var pplrate = 1 setget set_pplrate
var resrate = 2.0 setget set_resrate
var goldrate = 25.0 setget set_goldrate

var up = false

var click_reduce = 0.025

var factory_tick_max = 1.5
var granary_tick_max = 0.5
var village_tick_max = 2.5
var castle_tick_max = 1.5

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
	
	
	
	set_menu_info()
	
	$Timers/FactoryTick.wait_time = factory_tick_max
	$Timers/VillageTick.wait_time = village_tick_max
	$Timers/GranaryTick.wait_time = granary_tick_max
	$Timers/FactoryTick.start()
	$Timers/GranaryTick.start()
	$Timers/VillageTick.start()
	$Timers/CastleTick.start()
	
	$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Dark,"energy",$Dark.energy,0.8,20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	set_menu_info()
	$UI/BotMenu/PopupButton/Progress.value = float($Timers/GodTimer.time_left / $Timers/GodTimer.wait_time) * 100
	

func _input(event):
	
	if event is InputEventMouseMotion:
		$Camera.position += event.relative/20


func win():
	
	get_tree().paused = true
	$UI/Won.show()
	print("make victory animation!")

func lost():
	
	get_tree().paused = true
	$UI/Lost.show()
	print("implement losing animation!")

	
func info_text(text,position):
	
	$Info.text = text
	$Info.rect_position = position - $Info.rect_size/2

func spawn_floater(start_position,text,icon = null):
	var f = Global.floater.instance()
	f.position = (start_position + Vector2(0,-100)) + Vector2(rand_range(-25,25),rand_range(-25,25))
	if icon != null:
		f.get_node("Icon").texture = icon
	f.text = text
	add_child(f)
	

func set_menu_info():
	$UI/TopMenu/Food/Value.text = str(Global.food)
	$UI/TopMenu/People/Value.text = str(Global.people)
	$UI/TopMenu/Resources/Value.text = str(Global.resources)
	$UI/TopMenu/Gold/Value.text = str(Global.gold)
	
	$UI/TopMenu/D_Food/Value.text = str(Global.dungeon_food)
	$UI/TopMenu/D_Poeple/Value.text = str(Global.dungeon_people)
	$UI/TopMenu/D_Resources/Value.text = str(Global.dungeon_resources)
	$UI/TopMenu/D_Gold/Value.text = str(Global.dungeon_gold)
	
	if Global.gold <= 0 and !no_gold:
		text_bubble($Castle,"My Lord! We have no gold left!")
		no_gold = true
	elif Global.gold > 0 and no_gold:
		text_bubble($Castle,"My Lord! We have gold again!!")
		no_gold = false
	
	if Global.people <= 0 and !no_people:
		lost()
	
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
	var anim = Global.boop_animation.duplicate()
	#print(anim.track_get_path(0))
	$AnimPlayers.add_child(ap)
	anim.track_set_path(0,str(sprite,":scale"))
	ap.add_animation("booop",anim)
	ap.play("booop")
	
	if $AnimPlayers.get_child_count() >= 10:
		$AnimPlayers.get_children()[0].queue_free()

func animate_icon(sprite):
	var ap = AnimationPlayer.new()
	var anim = Global.icon_boop_animation.duplicate()
	#print(anim.track_get_path(0))
	$AnimPlayers.add_child(ap)
	anim.track_set_path(0,str(sprite,":scale"))
	ap.add_animation("booop",anim)
	ap.play("booop")
	
	if $AnimPlayers.get_child_count() >= 10:
		$AnimPlayers.get_children()[0].queue_free()

func click_info(text, color = Color(1,1,1,1)):
	$UI/ClickInfoLabel.modulate = color
	$UI/ClickInfoLabel.text = text
	$UI/ClickInfoLabel/Tween.interpolate_property(
			$UI/ClickInfoLabel,
			"modulate",
			color,
			Color(color.a,color.g,color.b,0),
			3,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN
			)
	$UI/ClickInfoLabel/Tween.start()

func _on_Building_input_event(viewport, event, shape_idx, building_name):
	
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		match building_name:
			"Castle":
#				Global.gold += 10
#				set_menu_info()
#				spawn_floater($Castle.position,"Gold +10",Global.gold_icon)
#				animate($Castle/Sprite.get_path())
#				animate_icon($UI/TopMenu/Gold/Icon.get_path())
				if $Timers/CastleTick.wait_time > castle_tick_max / 4:
					$Timers/CastleTick.wait_time -= $Timers/CastleTick.wait_time * click_reduce * 4
					animate($Castle/Sprite.get_path())
					
					if $Timers/ClickedTimers/CastleTimer.time_left <= 0:
						text_bubble($Castle,Global.click_response_generic[randi() % Global.click_response_generic.size()])
						$Timers/ClickedTimers/CastleTimer.start()
				
			
			"Factory":
				if $Timers/FactoryTick.wait_time > factory_tick_max / 2:
					$Timers/FactoryTick.wait_time -= $Timers/FactoryTick.wait_time * click_reduce * 2
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
					$Timers/GranaryTick.wait_time -= $Timers/GranaryTick.wait_time * click_reduce * 2
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
					$Timers/VillageTick.wait_time -= $Timers/VillageTick.wait_time * click_reduce * 2
					animate($Village/Sprite.get_path())
					
					if $Timers/ClickedTimers/VillageTimer.time_left <= 0:
						text_bubble($Village,Global.village_response[randi() % Global.village_response.size()])
						$Timers/ClickedTimers/VillageTimer.start()
				return
				Global.resources -= Global.village_needs.Resources
				Global.food -= Global.village_needs.Food
				Global.gold -= Global.village_needs.Gold
				
			"Dungeon":
				
				if(Global.people - Global.d_people_remove <= 0 or
						Global.resources - Global.d_resources_remove <= 0 or
						Global.food - Global.d_food_remove <= 0 or
						Global.gold - Global.d_gold_remove <= 0):
					click_info("You don't have enough resources to advance the dungeon raid.")
					return
				
				
				Global.dungeon_people -= Global.d_people_remove
				Global.dungeon_resources -= Global.d_resources_remove
				Global.dungeon_food -= Global.d_food_remove
				Global.dungeon_gold -= Global.d_gold_remove
				
				Global.people -= Global.d_people_remove
				Global.resources -= Global.d_resources_remove
				Global.food -= Global.d_food_remove
				Global.gold -= Global.d_gold_remove
				
				set_menu_info()
				
				animate_icon($UI/TopMenu/Food/Icon.get_path())
				animate_icon($UI/TopMenu/Resources/Icon.get_path())
				animate_icon($UI/TopMenu/People/Icon.get_path())
				animate_icon($UI/TopMenu/Gold/Icon.get_path())
				
				animate_icon($UI/TopMenu/D_Food/Icon.get_path())
				animate_icon($UI/TopMenu/D_Resources/Icon.get_path())
				animate_icon($UI/TopMenu/D_Poeple/Icon.get_path())
				animate_icon($UI/TopMenu/D_Gold/Icon.get_path())
				
				animate($Dungeon/Sprite.get_path())
				
				if Global.dungeon_gold == 0:
					win()
				
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
			info_text(str("Raid cost:\nFood - ",Global.d_food_remove,"\nPeople - ",Global.d_people_remove,"\nResources - ",Global.d_resources_remove,"\nGold - ",Global.d_gold_remove),$Dungeon.position + Vector2(0,-100))
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
	if $Timers/CastleTick.wait_time < castle_tick_max:
		$Timers/CastleTick.wait_time += castle_tick_max * click_reduce * 3




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
				Global.food -= round(Global.food * 0.2) if Global.food > 50 else 30
				Global.people -= round(Global.people * 0.25) if Global.people > 20 else 12
				Global.resources -= round(Global.resources * 0.2) if Global.resources > 50 else 30
				Global.gold -= round(Global.gold * 0.25) if Global.gold > 400 else 225
				set_menu_info()
				up = true
			else:
				$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Dark,"energy",$Dark.energy,0.8,20,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				up = false
		"BotMenu":
			if $Timers/GodTimer.time_left > 0:
				$UI/BotMenu.rect_position.y = 720
		_:
			return
			print(object.name)


func _on_CastleTick_timeout():
	Global.gold += goldrate
	spawn_floater($Castle.position,str("Resources +",goldrate),Global.gold_icon)
	animate_icon($UI/TopMenu/Gold/Icon.get_path())


func _on_FactoryTick_timeout():
	if Global.food <= 0 or Global.gold <= 0:
		return
	Global.resources += resrate
	spawn_floater($Factory.position,str("Resources +",resrate),Global.resource_icon)
	animate_icon($UI/TopMenu/Resources/Icon.get_path())


func _on_GranaryTick_timeout():
	if Global.gold <= 0:
		return
	Global.food += foodrate
	spawn_floater($Granary.position,str("Food +",foodrate),Global.food_icon)
	animate_icon($UI/TopMenu/Food/Icon.get_path())

func _on_Villagetick_timeout():
	if Global.food <= 0 or Global.gold <= 0:
		return
	Global.people += pplrate
	spawn_floater($Village.position,str("Poeple +",pplrate),Global.people_icon)
	animate_icon($UI/TopMenu/People/Icon.get_path())

func _on_PopupButton_button_down():
	$UI/BotMenu/BotMenuTween.stop($UI/BotMenu,"rect_position")
	
	if $UI/BotMenu/PopupButton/Arrow.scale.y == 1:
		if $Timers/GodTimer.time_left > 0:
			click_info("The gods don't need another sacrifice yet.")
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
				Global.food += Global.god_food_blessing
		"Anyag":
			if Global.gold > 0:
				Global.gold -= 200
				Global.resources += Global.god_resources_blessing
		"Ember":
			if Global.gold > 0:
				Global.gold -= 200
				Global.people += Global.god_people_blessing
		"Arany":
			if Global.people > 0 and Global.resources > 0 and Global.food > 0:
				Global.gold += Global.god_gold_blessing
				Global.resources -= 100
				Global.food -= 50
				Global.people -= 20
	
	click_info("The gods have accepted your sacrifice.",Color("#f7bc33"))
	
	set_menu_info()
	_on_PopupButton_button_down()
	
	$Timers/GodTimer.start()




