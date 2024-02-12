enum GameState{
	Idle,
	Walk,
	Jump,
	PreFly,
	Fly,
	Drop,
	Attack
}

gamestate = GameState.Idle;

//player variables
grv = 0.1;
horizontal_velocity = 0;
vertical_velocity = 0;

in_air = false;

x_acc = 0.1;
x_deceleration = 0.05;
max_velocity = 1;

is_jumping = false;
jump_timer = 0;
jump_speed = -1.6;
y_deceleration = 0.8;
is_grounded = 0;

prefly = false;
is_drop = false;
fly_timer = 0;
fly_force = -1.1;

_dir = 1;

move1 = false;
move2 = false;

hp = 100;
