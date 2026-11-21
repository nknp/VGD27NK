extends Node3D

@onready var TestMass = get_parent()
@onready var Camera = $Camera
#defining variables
var sensitivity = 0.01
#cam mode stuffs
enum cameraMode {FIRST,THIRD}
var currentCamMode: cameraMode = cameraMode.FIRST
var a = 0
#1st person variabeles
var pivor1stPVector: Vector3
var angleRot = 0
#3rd person variables
var thirdCamGlobalPos: Vector3
var testMassForwardVector: Vector3
var thetaAngle = 0
var phiAngle = 0
#projectile momentum
const energyBall = preload("res://energy_ball.tscn")
var throwingSpeed: float = 5.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#other camera stuffs when not used
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("CameraToggle"):
		a=(a+1)%2
		currentCamMode = a as cameraMode
		match  currentCamMode:
			cameraMode.FIRST:
				position = Vector3(0,0,0)
			cameraMode.THIRD:
				thirdCamGlobalPos = to_global(Vector3(0,0,1))-TestMass.global_position
				position = thirdCamGlobalPos
				testMassForwardVector = TestMass.to_global(Vector3(0,0,-1))-TestMass.global_position
				thetaAngle = atan2(thirdCamGlobalPos.z, thirdCamGlobalPos.x)
				phiAngle = clamp(acos(clamp(-1*thirdCamGlobalPos.y/thirdCamGlobalPos.length(),-1,1)),PI/15,14*PI/15)
				look_at(TestMass.global_position)


func _input(event: InputEvent) -> void:
	#stuff for camera in use
	if event is InputEventMouseMotion:
		var mouseVector: Vector2 = event.screen_relative
		match currentCamMode:
			cameraMode.FIRST:
				pivor1stPVector = Vector3(-1*mouseVector.y,-1*mouseVector.x,0).normalized()
				angleRot = sensitivity*mouseVector.length()
				quaternion = quaternion*Quaternion(pivor1stPVector, angleRot)
			cameraMode.THIRD:
				phiAngle = clamp(phiAngle+sensitivity*mouseVector.y,PI/15,14*PI/15)# set phi=phi+sensitivity*mouseVector.y mod pi, note phi is between 0 to pi
				thetaAngle = fposmod((thetaAngle+sensitivity*mouseVector.x),TAU)# set theta=theta+sensitivity*mouseVector.x mod 2pi, note theta is between 0 to 2pi 
				position=Vector3(sin(phiAngle)*cos(thetaAngle),-cos(phiAngle),sin(phiAngle)*sin(thetaAngle))
				look_at(TestMass.global_position)
	if event.is_action_pressed("Momentum"):
		var projectile = energyBall.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = TestMass.global_position
		var throwDirection: Vector3 = -Camera.global_basis.z
		var velocity_0: Vector3 = TestMass.velocity
		var M: float = TestMass.ownMass
		var m: float = projectile.mass
		projectile.velocity = velocity_0 + (M/(M+m))*throwingSpeed*throwDirection
		TestMass.velocity = velocity_0 - (m/(M+m))*throwingSpeed*throwDirection
