extends Node3D

var player_speed: float = 6.0


func _ready() -> void:
	create_environment()
	create_ground()
	create_base()
	create_egg()


func create_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()

	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	environment.sky.sky_material = ProceduralSkyMaterial.new()

	world_environment.environment = environment
	add_child(world_environment)

	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-50, -30, 0)
	sunlight.light_energy = 1.2
	add_child(sunlight)

	var camera := Camera3D.new()
	camera.position = Vector3(10, 10, 14)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	camera.current = true
	add_child(camera)


func create_ground() -> void:
	var ground := MeshInstance3D.new()
	var mesh := BoxMesh.new()

	mesh.size = Vector3(40, 1, 40)
	ground.mesh = mesh
	ground.position.y = -0.5

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.25, 0.65, 0.3)
	ground.material_override = material

	add_child(ground)


func create_base() -> void:
	var base := MeshInstance3D.new()
	var mesh := BoxMesh.new()

	mesh.size = Vector3(8, 0.3, 8)
	base.mesh = mesh
	base.position = Vector3(0, 0.2, 0)

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.45, 1.0)
	base.material_override = material

	add_child(base)


func create_egg() -> void:
	var egg := MeshInstance3D.new()
	var mesh := SphereMesh.new()

	mesh.radius = 0.7
	mesh.height = 1.5
	egg.mesh = mesh
	egg.position = Vector3(0, 1.2, -3)

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.8, 0.15)
	egg.material_override = material

	add_child(egg)
