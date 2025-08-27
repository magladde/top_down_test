extends Node2D

@export var thrust := 400.0
@export var rotation_speed := 10.0
@export var friction := 2.0
@export var brake_strength := 300

@onready var PlanetScene: PackedScene = preload("res://scenes/planet.tscn")

var velocity := Vector2.ZERO
var braking := false
var in_landing_zone := false
var speed := 0

func _can_land(speed, in_landing_zone) -> bool:
	if not in_landing_zone:
		print("not by planet")
		return false
	if speed > 10:
		print("moving too fast")
		return false
	return true

func _physics_process(delta):
	speed = velocity.length()
	if Input.is_action_just_pressed("land_ship"):
		if _can_land(speed, in_landing_zone):
			print("can land")
			get_tree().change_scene_to_packed(PlanetScene)
			### To Do: Implement scene change, landing successful ###
	
	##### ship movement #####
	
	# flag to handle breaking
	braking = Input.is_action_pressed("reverse_thrust")

	# user input for turning
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# user input for thrust
	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation) * thrust * delta

	# slow ship down with either of these two methods
	if braking:
		velocity = velocity.move_toward(Vector2.ZERO, brake_strength * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Apply velocity to position
	position += velocity * delta


func _on_planet_area_entered(area: Area2D) -> void:
	in_landing_zone = true

func _on_planet_area_exited(area: Area2D) -> void:
	in_landing_zone = false
