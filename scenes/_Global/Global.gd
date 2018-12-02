extends Node

# resources
var font = preload("res://misc/Font.tres")

#nodes
var floater = preload("res://scenes/FloatInfo/FloatInfo.tscn")
var bubble = preload("res://scenes/TextBubble/TextBubble.tscn")

#animations
var boop_animation = preload("res://animatons/Boop.tres")
var icon_boop_animation = preload("res://animatons/IconBoop.tres")

#sounds

var talk =[
preload("res://audio/sound/talk1.wav"),
preload("res://audio/sound/talk2.wav"),
preload("res://audio/sound/talk_3.wav")
]

#dialogs
var click_response_generic = [
"We're working as fast as we can my Lord!",
"Faster?!? But my Lord I'm tireeeed!",
"Right away Sir!"
]
var village_response = [
"We're lovin' as fast as we can!",
"But I already have 15 children!",
"We're gettin' another bed!"

]

#images
var gold_icon = preload("res://art/Gold.png")
var resource_icon = preload("res://art/Resource.png")
var food_icon = preload("res://art/Food.png")
var people_icon = preload("res://art/People.png")

var no_negative = true

var food = 100
var resources = 200
var people = 50
var gold = 1000

var village_needs = {"Food":50,"Resources":20,"Gold":100}
var dungeon_needs = {"People":20,"Food":20,"Resources":50,"Gold":200}
var granary_needs = {"People":10,"Resources":20,"Gold":100}
var factory_needs = {"People":30,"Food":30,"Gold":300}

var base_village_needs = {"Food":50,"Resources":20,"Gold":100}
var base_dungeon_needs = {"People":20,"Food":20,"Resources":50,"Gold":200}
var base_granary_needs = {"People":10,"Resources":20,"Gold":100}
var base_factory_needs = {"Poeple":30,"Food":30,"Gold":300}

func set_food(value):
	
	if value >= 0:
		food = value
	else:
		food = 0

func set_resources(value):

	if value >= 0:
		resources = value
	else:
		resources = 0

func set_people(value):

	if value >= 0:
		people = value
	else:
		 people = 0

func set_gold(value):

	if value >= 0:
		gold = value
	else:
		gold = 0
