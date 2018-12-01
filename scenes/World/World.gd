extends Node2D

var foodrate = 1.0 setget set_foodrate
var pplrate = 0.5 setget set_pplrate
var resrate = 2.0 setget set_resrate
var goldrate = 10.0 setget set_goldrate

var up = false


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
	
	set_menu_info(Global.food,Global.people,Global.resources,Global.gold)
	
	$Timers/ResourceTick.start()
	
	$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property($Sun,"energy",$Sun.energy,0.25,5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass
	
	

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
	

func set_menu_info(_food,_people,_resources,_gold):
	$UI/TopMenu/Food/Value.text = str(_food)
	$UI/TopMenu/People/Value.text = str(_people)
	$UI/TopMenu/Resources/Value.text = str(_resources)
	$UI/TopMenu/Gold/Value.text = str(_gold)

func set_menu_info_nopar():
	$UI/TopMenu/Food/Value.text = str(Global.food)
	$UI/TopMenu/People/Value.text = str(Global.people)
	$UI/TopMenu/Resources/Value.text = str(Global.resources)
	$UI/TopMenu/Gold/Value.text = str(Global.gold)

func _on_Building_input_event(viewport, event, shape_idx, building_name):
	
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		match building_name:
			"Castle":
				Global.gold += 10
				set_menu_info_nopar()
				spawn_floater($Castle.position,"Gold +10")
			"Factory":
				Global.food -= Global.factory_needs.Food
				Global.people -= Global.factory_needs.People
				Global.gold -= Global.factory_needs.Gold
			"Granary":
				Global.resources -= Global.granary_needs.Resources
				Global.people -= Global.granary_needs.People
				Global.gold -= Global.granary_needs.Gold
			"Village":
				Global.resources -= Global.village_needs.Resources
				Global.food -= Global.village_needs.Food
				Global.gold -= Global.village_needs.Gold
			"Dungeon":
				Global.people -= Global.dungeon_needs.People
				Global.resources -= Global.dungeon_needs.Resources
				Global.food -= Global.dungeon_needs.Food
				Global.gold -= Global.dungeon_needs.Gold
			_:
				print("oops... ",building_name)
		
		#Global.people -= Global.factory_needs.People
		
		set_menu_info_nopar()

func _on_Building_mouse_entered(building_name):
	match building_name:
		"Granary":
			info_text("Granary - Cost: 50",$Granary.position + Vector2(0,-50))
		"Factory":
			info_text("Factory - Cost: 50",$Factory.position + Vector2(0,-50))
		"Barn":
			info_text("Castle - Gold +10",$Castle.position + Vector2(0,-50))
		"Village":
			info_text("Village - Cost: 50",$Village.position + Vector2(0,-50))
		"Dungeon":
			info_text("Dungeon - Cost: 50",$Dungeon.position + Vector2(0,-50))
		_:
			print(building_name)


func _on_Building_mouse_exited():
	$Info.text = ""


func _on_ResourceTick_timeout():
	Global.food += foodrate
	Global.people += pplrate
	Global.resources += resrate
	Global.gold += goldrate
	
	spawn_floater($Granary.position,str("Food +",foodrate))
	spawn_floater($Village.position,str("Poeple +",pplrate))
	spawn_floater($Factory.position,str("Resources +",resrate))
	spawn_floater($Castle.position,str("Gold +",goldrate))
	
	
	set_menu_info(Global.food,Global.people,Global.resources,Global.gold)


func _on_ReduceTick_timeout():
	self.foodrate -= foodrate * 0.1
	self.pplrate -= pplrate * 0.1
	self.resrate -= resrate * 0.1
	self.goldrate -= goldrate * 0.1




func _on_Tween_tween_completed(object, key):
	match object.name:
		"Demon":
			if !up:
				$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,-100),0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sky,"color",$Sky.color,Color("00dbff"),0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sun,"energy",$Sun.energy,1,0.5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				Global.food -= 25
				Global.people -= 12.5
				Global.resources -= 50
				Global.gold -= 250
				set_menu_info_nopar()
				up = true
			else:
				$Tween.interpolate_property($Demon,"position",$Demon.position,$Demon.position-Vector2(0,100),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sky,"color",$Sky.color,Color("2f0000"),5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				$Tween.interpolate_property($Sun,"energy",$Sun.energy,0.25,5,Tween.TRANS_CUBIC,Tween.EASE_OUT)
				$Tween.start()
				up = false


func _on_Village_area_entered(area):
	match area.type:
		area.types.PEOPLE:
			print("people")
		1:
			pass
		2:
			pass
		3:
			pass

