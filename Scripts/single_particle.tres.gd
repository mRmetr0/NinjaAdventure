extends GPUParticles2D

class_name SingleParticle

func play(sprite_sheet : Texture2D, sheet_length : int, particle_size : Vector2 = Vector2(1,1), \
		anim_speed : float = 1):
	#setup texture with random size
	texture = sprite_sheet
	var new_process_mat = process_material.duplicate()
	new_process_mat.scale_min = particle_size.x
	new_process_mat.scale_max = particle_size.y
	process_material = new_process_mat
	#setup unique material for each particle 
	var new_canvas_mat = material.duplicate()
	new_canvas_mat.set_particles_anim_h_frames(sheet_length)
	material = new_canvas_mat
	#handle remains and start
	speed_scale = anim_speed
	emitting = true
	

func _on_finished():
	queue_free()
