extends Node

# resources
var font = preload("res://misc/Font.tres")

#nodes
var floater = preload("res://scenes/FloatInfo/FloatInfo.tscn")
var bubble = preload("res://scenes/TextBubble/TextBubble.tscn")

#animations
var boop_animation = preload("res://animatons/Boop.tres")

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
