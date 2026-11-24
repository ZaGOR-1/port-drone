extends SceneTree
## In a scratch project with the production path_kit.gd copied under res://ui/ui24/.

const PathKit = preload("res://ui/ui24/path_kit.gd")
const SIZE = Vector2i(32, 32)

func _initialize() -> void:
	_bake.call_deferred()

func _bake() -> void:
	var surface := SubViewport.new()
	surface.size = SIZE
	surface.transparent_bg = true
	surface.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(surface)
	var item := Node2D.new()
	item.draw.connect(func() -> void:
		PathKit.reticle(item, Vector2(16.5, 16.5), Color("ff8a4a"), 0.0, 7.0))
	surface.add_child(item)
	await process_frame
	await RenderingServer.frame_post_draw
	var image: Image = surface.get_texture().get_image()
	# The transparent render target stores premultiplied RGB. The sprite uses normal blending.
	for y in SIZE.y:
		for x in SIZE.x:
			var p: Color = image.get_pixel(x, y)
			if p.a > 0.0:
				image.set_pixel(x, y, Color(p.r / p.a, p.g / p.a, p.b / p.a, p.a))
	var status: Error = image.save_png(OS.get_cmdline_user_args()[0])
	quit(0 if status == OK else 1)
