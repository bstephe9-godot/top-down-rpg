extends CharacterBody2D

var tile_size = 16

@export var seconds_per_tile: float = 0.35
@onready var can_move: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

const directions = {
	&"left": Vector2.LEFT,
	&"right": Vector2.RIGHT,
	&"up": Vector2.UP,
	&"down": Vector2.DOWN
}

var pressed_actions: Array[StringName] = []

func _physics_process(_delta: float) -> void:
	for d in directions:
		if Input.is_action_just_pressed(d):
			if not pressed_actions.has(d):
				pressed_actions.push_back(d)
		if Input.is_action_just_released(d):
			pressed_actions.erase(d)

	if not pressed_actions.is_empty() and can_move:
		var direction_name = pressed_actions[-1]
		var direction = directions[direction_name]
		animated_sprite.play(direction_name)
		ray_cast.target_position = direction * tile_size
		ray_cast.force_raycast_update()
		
		if not ray_cast.is_colliding():
			move(direction)
			can_move = false

func move(direction: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + direction * tile_size, seconds_per_tile)
	tween.tween_callback(func():
		can_move = true
		animated_sprite.stop()
	)
