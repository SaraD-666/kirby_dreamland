//if target is player
if (target  != noone)
{
		x_cam = target.x;
		y_cam = target.y;
}

//camera smoothing, change division # if you want to change the ease - higher = faster
x += (x_cam - x)/25;
y += (y_cam - y)/25;

//camera now goes to our camera object
camera_set_view_pos(view_camera[0],x-(cam_width*.5),y - (cam_height*.5));
