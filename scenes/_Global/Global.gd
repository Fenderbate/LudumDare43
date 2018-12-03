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
preload("res://audio/sound/talking/talk1.ogg"),
preload("res://audio/sound/talking/talk2.ogg"),
preload("res://audio/sound/talking/talk3.ogg"),
preload("res://audio/sound/talking/talk4.ogg"),
preload("res://audio/sound/talking/talk5.ogg"),
preload("res://audio/sound/talking/talk6.ogg"),
preload("res://audio/sound/talking/talk7.ogg"),
preload("res://audio/sound/talking/talk8.ogg")
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


var dungeon_food = 500
var dungeon_resources = 500
var dungeon_people = 500
var dungeon_gold = 5000

var d_food_remove = 50
var d_resources_remove = 50
var d_people_remove = 50
var d_gold_remove = 500

var god_food_blessing = 50
var god_resources_blessing = 50
var god_people_blessing = 30
var god_gold_blessing = 650


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
