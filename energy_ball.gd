extends Node3D

var camera_basis: Basis
var mass: float = (4.0/3.0)*(PI)*(0.025**3)
var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_life_span_timeout() -> void:
	queue_free()
