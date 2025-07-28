extends CharacterBody2D

@export var speed: float = 32.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var can_move: bool = true
@onready var direction: Vector2

const valid_directions = {
	&"left": Vector2(-1, 0),
	&"right": Vector2(1, 0),
	&"up": Vector2(0, -1),
	&"down": Vector2(0, 1)
}

var pressed_actions = []

func _unhandled_key_input(_event: InputEvent) -> void:
	for d in valid_directions:
		if Input.is_action_just_pressed(d):
			if not pressed_actions.has(d):
				pressed_actions.push_back(d)
		if Input.is_action_just_released(d):
			pressed_actions.erase(d)
	direction = Vector2.ZERO if pressed_actions.is_empty() else valid_directions[pressed_actions[-1]]

func _process(_delta: float) -> void:
	if not pressed_actions.is_empty():
		animated_sprite.play(pressed_actions[-1])
	else:
		animated_sprite.stop()
		
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
