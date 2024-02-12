
var _horizontal_mv = keyboard_check(vk_right) - keyboard_check(vk_left);


if (_horizontal_mv != 0){
	_dir = _horizontal_mv;
}
switch(gamestate){
	case GameState.Idle:
		sprite_index = spr_kirby_idle;
		image_xscale = _dir;
		if (_horizontal_mv != 0){
			gamestate = GameState.Walk;
		}
		if (keyboard_check(ord("Z"))){
			gamestate = GameState.Jump;
		}
		//go to PreFly
		if (keyboard_check(vk_up)){
			gamestate = GameState.PreFly;
			prefly = true;
		}

	break;
	case GameState.Walk:
		sprite_index = spr_kirby_walk;
		image_xscale = _dir;
		
		if (keyboard_check(ord("Z"))){
			gamestate = GameState.Jump;
		}
		if (_horizontal_mv == 0){
			gamestate = GameState.Idle;
		}
		//go to PreFly
		if (keyboard_check(vk_up)){
			gamestate = GameState.PreFly;
			prefly = true;
		}
	break;
	case GameState.Jump:
		
		sprite_index = spr_kirby_jump;
		image_xscale = _dir;
		
		var key_jump = keyboard_check(ord("Z"));
		var end_jump = keyboard_check_released(ord("Z"));	
		
		//always have gravity when walking
		vertical_velocity += grv;
		
		//if it can jump
		if(is_grounded-- > 0) && (key_jump)
		{
			is_jumping = true;
			is_grounded = 0;
			in_air = true;
		}

		if (is_jumping){
			jump_timer++;
			if (jump_timer <= 5){
				vertical_velocity = jump_speed;
				if(end_jump){
					is_jumping = false;
					jump_timer = 0;
				}
			}
			else if (jump_timer > 5 && jump_timer < 20){
				vertical_velocity = jump_speed;
				if(end_jump){
					is_jumping = false;
					jump_timer = 0;
			
					if (jump_timer == 0){
						vertical_velocity += y_deceleration;
					}
				}
			}
			else{
				is_jumping = false;
				jump_timer = 0;
				vertical_velocity += y_deceleration;
			}
		}
		
		//jump
		if (place_meeting(x+horizontal_velocity, y, obj_collision)){
			horizontal_velocity = 0;
		}

		if (place_meeting(x, y + vertical_velocity, obj_collision)) //if colliding with floor tile layer on Y
		{ 
	
			if (vertical_velocity > 0)
			{
				is_grounded = 6; //this is  our jump buffer - basically a nice little hang time for players to still be able to jump after dropping a bit
				gamestate = GameState.Walk;
			}
	
			while(abs(vertical_velocity) > 0.1) 
			{
				vertical_velocity *= 0.5; 
				if(!place_meeting(x,y + vertical_velocity, obj_collision)) //use obj_collider too
				{ 
					y += vertical_velocity;
				}
			}
	
			vertical_velocity = 0;
		}

		y += vertical_velocity; 
		
		//if fly
		if (keyboard_check(vk_up)){
			gamestate = GameState.PreFly;
			prefly = true;
		}
		
	break;
	case GameState.PreFly:
	
		var _drop_f = 0.5;
		var key_fly = keyboard_check(vk_up);
		
		//always apply
		vertical_velocity = _drop_f;
		
		//if key pressed
		if (key_fly){
			vertical_velocity = fly_force;
		}
		if(prefly){
			sprite_index = spr_kirby_inflate;
			image_xscale = _dir;
		}
		if (image_index >= image_number - 1){
			prefly = false;
			gamestate = GameState.Fly;
		}
		//land on the ground properly
		if (place_meeting(x, y + vertical_velocity, obj_collision) && !key_fly) //if colliding with floor tile layer on Y
		{ 
			while(abs(vertical_velocity) > 0.1) 
			{
				vertical_velocity *= 0.5; 
				if(!place_meeting(x,y + vertical_velocity, obj_collision)) //use obj_collider too
				{ 
					y += vertical_velocity;
				}
			}
	
			vertical_velocity = 0;
		}
		y += vertical_velocity;
		
	break;
	case GameState.Fly:
		var _drop_f = 0.5;
		var key_fly = keyboard_check(vk_up) || keyboard_check(ord("Z"));
		//drop gravity
		vertical_velocity = _drop_f;
		
		sprite_index = spr_kirby_fly_idle;
		image_xscale = _dir;
		if (key_fly){
			vertical_velocity = fly_force;
			sprite_index = spr_kirby_fly_up;
			image_xscale = _dir;
		}
		//land on the ground properly
		if (place_meeting(x, y + vertical_velocity, obj_collision) && !key_fly) //if colliding with floor tile layer on Y
		{ 
	
			while(abs(vertical_velocity) > 0.1) 
			{
				vertical_velocity *= 0.5; 
				if(!place_meeting(x,y + vertical_velocity, obj_collision)) //use obj_collider too
				{ 
					y += vertical_velocity;
				}
			}
	
			vertical_velocity = 0;
		}
		y += vertical_velocity;
		
		if (keyboard_check_pressed(ord("X"))){
			gamestate = GameState.Drop;
			is_drop = true;
		}
	break;
	case GameState.Drop:
		if (is_drop){
			sprite_index = spr_kirby_deflate;
			image_xscale = _dir;
		}
		if (image_index >= image_number - 1){
			sprite_index = spr_kirby_idle;
			image_xscale = _dir;
			is_drop = false;
		}
		
		var _drop_f = 0.5;
		vertical_velocity = _drop_f;
		
		//land on the ground properly
		if (place_meeting(x, y + vertical_velocity, obj_collision)) //if colliding with floor tile layer on Y
		{ 
	
			while(abs(vertical_velocity) > 0.1) 
			{
				vertical_velocity *= 0.5; 
				if(!place_meeting(x,y + vertical_velocity, obj_collision)) //use obj_collider too
				{ 
					y += vertical_velocity;
				}
			}
	
			vertical_velocity = 0;
			gamestate = GameState.Idle;
		}
		y += vertical_velocity;
		
	break;
	case GameState.Attack:
	break;
}

//just for boundary detection
var _width = sprite_width/2;

//if moving to right and within the room
if (_horizontal_mv == 1 && !place_meeting(x+horizontal_velocity, y, obj_collision)){
	//move it
	horizontal_velocity += x_acc;
	//move cam
	if (x > obj_camera.x + obj_camera.camera_width/2){
		obj_camera.x += horizontal_velocity;
	}	
}
//if moving to left and within the room
if (_horizontal_mv == -1  && !place_meeting(x+horizontal_velocity - 1, y, obj_collision)){
	//move it
	horizontal_velocity -= x_acc;
	
	//left
	if (x < obj_camera.x + obj_camera.camera_width/2)
	{
		obj_camera.x += horizontal_velocity;
	}
}

if (_horizontal_mv == 0){
	if (abs(horizontal_velocity) >= x_deceleration){
		horizontal_velocity = (abs(horizontal_velocity) - x_deceleration) * sign(horizontal_velocity);
	}
	else{
		horizontal_velocity = 0
	}
}

if (place_meeting(x + horizontal_velocity, y, obj_collision)) //if colliding with floor tile layer on Y
{ 
	while(abs(horizontal_velocity) > 0.1) 
	{
		horizontal_velocity *= 0.5; 
		if(!place_meeting(x + horizontal_velocity, y, obj_collision)) //use obj_collider too
		{ 
			x += horizontal_velocity;
		}
	}
	
	horizontal_velocity = 0;
}

	
if (abs(horizontal_velocity) >= max_velocity){
	horizontal_velocity = max_velocity * sign(horizontal_velocity);
}

x += horizontal_velocity;//now we move
/*
		var key_fly = keyboard_check(vk_up) || keyboard_check(ord("Z"));
		
		var _drop_f = 0.5;
		
		//always apply
		vertical_velocity = _drop_f;
		//if key pressed
		if (key_fly){
			vertical_velocity = fly_force;
		}
		//if it hits the wall
		if (y - fly_force < 0){
			vertical_velocity = _drop_f;
		}
		
		
		// states only for animation playing
		if (pre_fly){
			sprite_index = spr_kirby_inflate;
			image_xscale = _dir;
			if (image_index == image_number){
				pre_fly = false;
				sprite_index = spr_kirby_fly_idle;
				image_xscale = _dir;
			}
		}
		//if already in float
		if (!pre_fly){
			//if pressed up
			if (key_fly){
				sprite_index = spr_kirby_fly_up;
				image_xscale = _dir;
			}
			
			
			//if press x
			if (keyboard_check_pressed(ord("X"))){
				show_debug_message(1);
				sprite_index = spr_kirby_deflate;
				image_xscale = _dir;
				gamestate = GameState.Idle;
				//if end animation
				if (image_index == image_number){
					sprite_index = spr_kirby_idle;
					image_xscale = _dir;
					gamestate = GameState.Idle;
				}
			}
			
			
			sprite_index = spr_kirby_fly_idle;
			image_xscale = _dir;

		}
		
		//land on the ground properly
		if (place_meeting(x, y + vertical_velocity, obj_collision) && !key_fly) //if colliding with floor tile layer on Y
		{ 
	
			while(abs(vertical_velocity) > 0.1) 
			{
				vertical_velocity *= 0.5; 
				if(!place_meeting(x,y + vertical_velocity, obj_collision)) //use obj_collider too
				{ 
					y += vertical_velocity;
				}
			}
	
			vertical_velocity = 0;
		}
	
		y += vertical_velocity;
*/