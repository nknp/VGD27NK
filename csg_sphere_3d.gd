extends CSGSphere3D

@onready var Planets = get_node("../../Planets")
var G = 6.0
var ownMass: float = (4.0/3.0)*(PI)*((float(radius))**3)
var velocity: Vector3 = Vector3.ZERO
func _physics_process(delta: float) -> void:	
	#gravity
	var acceleration = Vector3()
	var currentPos: Vector3 = global_position
	for planet in Planets.get_children():
		var mass = (4.0/3.0)*(PI)*((float(planet.radius))**3)
		var planetPos: Vector3 = planet.global_position
		var distance = (currentPos-planetPos).length() 
		if distance <= planet.radius:
			continue
		var direction = (planetPos-currentPos).normalized()
		var localAccel = (G*mass/(distance**2))*direction
		acceleration += localAccel
	var acceleration1 = acceleration
	velocity += acceleration * delta
	global_position += velocity * delta
	
	#camera stuffs
