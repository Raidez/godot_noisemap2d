tool
extends Sprite

const shader = preload("res://addons/noisemap2d/NoiseMap2D.shader")

export(Vector2) var size = Vector2(512, 512) setget set_size
export(OpenSimplexNoise) var noise = OpenSimplexNoise.new() setget set_noise
export(bool) var use_gradient = true setget set_which_use
export(Gradient) var gradient = Gradient.new() setget set_gradient

const width = 2048.0

func set_size(value):
	size = value
	apply_noisemap()

func set_noise(value):
	noise = value
	if !noise:
		noise = OpenSimplexNoise.new()
	apply_noisemap()

func set_which_use(value):
	use_gradient = value
	if use_gradient:
		apply_gradient()
	else:
		apply_color_ramp()

func set_gradient(value):
	gradient = value
	if !gradient:
		gradient = Gradient.new()
	
	if use_gradient:
		apply_gradient()
	else:
		apply_color_ramp()

################################################################################

func _ready():
	centered = false
	material = ShaderMaterial.new()
	material.shader = shader
	
	apply_noisemap()
	if use_gradient:
		apply_gradient()
	else:
		apply_color_ramp()

func apply_noisemap():
	texture = NoiseTexture.new()
	texture.width = size.x
	texture.height = size.y
	texture.noise = noise

func apply_gradient():
	var gradient_tex = GradientTexture.new()
	gradient_tex.gradient = gradient
	material.set_shader_param("gradient", gradient_tex)

func apply_color_ramp():
	var image_tex = ImageTexture.new()
	
	var image = Image.new()
	image.create(width, 1, false, Image.FORMAT_RGB8)
	image.lock()
	for x in range(width):
		var sample = gradient.colors[0]
		var x_pos = x / width
		
		for idx in range(gradient.colors.size()):
			var color = gradient.colors[idx]
			var offset = gradient.offsets[idx]
			if offset <= x_pos:
				sample = color
		
		image.set_pixel(x, 0, sample)
	
	image.unlock()
	image_tex.create_from_image(image)
	material.set_shader_param("gradient", image_tex)
