float(vector delta, vector dir, float proj_speed) aim_mod =
{
	float a = dotproduct(dir, dir) - proj_speed * proj_speed;
	float b = 2 * dotproduct(dir, delta);
	float c = dotproduct(delta, delta);

	float desc = b * b - 4 * a * c;

	if (desc > 0.0)
		return (2 * c) / (sqrt(desc) - b);
	
	return -1;
}

float (float proj_speed, float grav, float distance, float height) max_dist = 
{
	float m = height / distance;
	float spd2 = proj_speed * proj_speed;
	return (spd2 * sqrt( m * m + 1) - m * spd2) / grav;
}

float (vector dir, float proj_speed, float grav_mult) proj_launch_pitch_mod =
{

	float grav = cvar("sv_gravity") * grav_mult;

	float spd2 = proj_speed * proj_speed;
	float pitch;
	float distance = vlen(dir);
	float height = dir[2];

	float maxd = max_dist(proj_speed, grav, distance, height);

	if (vlen(dir) > maxd)
	{
		pitch = atan(spd2 / (grav * maxd));
	}
	else
	{	
		float spd4 = spd2 * spd2;
		float root = sqrt(spd4 - grav * ( grav * distance * distance + 2 * dir[2] * spd2));
		pitch = atan( (spd2 - root ) / (grav * distance));
	}

	return -pitch * 180 / 3.14159265359 ;
}

vector(float proj_speed) calculate_dir_to_moving_target =
{
	vector dir;
	vector delta;
	float deltatime;
	float dodge_mult;


	if (!visible(self.enemy))
	{
		dir = normalize(self.spam_point - self.origin);
		return dir;
	}

	dir = self.enemy.origin - self.origin;
	delta = self.enemy.velocity - self.velocity;

	deltatime = aim_mod(dir, delta, proj_speed);

	traceline(self.origin, self.enemy.origin + self.enemy.velocity * deltatime, TRUE, self);

	dodge_mult = (self.enemy.dodge_time > time ? random(0.25, 0.75) : 1);

	if (trace_fraction == 1)
		dir = normalize((self.enemy.origin + self.enemy.velocity * deltatime * dodge_mult) - self.origin);
	else
		dir = normalize(dir);


	return dir;
	
}