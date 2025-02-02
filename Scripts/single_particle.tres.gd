extends GPUParticles2D

class_name SingleParticle

func play(sprite_sheet : Texture2D, sheet_length : int, particle_size : Vector2 = Vector2(1,1)):
	texture = sprite_sheet
	process_material.scale_min = particle_size.x
	process_material.scale_max = particle_size.y
	material.set_particles_anim_h_frames(sheet_length)
	emitting = true

func _on_finished():
	queue_free()
