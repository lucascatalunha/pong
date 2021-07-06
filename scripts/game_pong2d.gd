extends Node2D

const BALL_SPEED = 200
const PLAYER_SPEED = 150
var screen_size
var ball_position
var ball_direction
var ball_speed = BALL_SPEED
var player_size
var player_left_goal = 0
var player_right_goal = 0

func _ready():
	print("Welcome to back Pong.")
	screen_size = get_viewport_rect().size
	player_size = $PlayerLeftSprite.texture.get_size()
	$BallSprite.position = screen_size * 0.5
	$HUDNode/PlayerLeftGoalLabel.text = str(player_left_goal)
	$HUDNode/PlayerRightGoalLabel.text = str(player_right_goal)
	ball_position = $BallSprite.position
	ball_direction = Vector2(1,-1)
	randomize()
	
func _process(delta):
	ball_position = ball_position + ball_direction * ball_speed * delta
	
	if ball_position.x < 17:
		player_right_goal = player_right_goal + 1
		$HUDNode/PlayerRightGoalLabel.text = str(player_right_goal)
	if ball_position.x > screen_size.x-17:
		player_left_goal = player_left_goal + 1
		$HUDNode/PlayerLeftGoalLabel.text = str(player_left_goal)
	
	#rebater a bola no topo e base
	if (ball_position.y < 17 or ball_position.y > screen_size.y-17):
		ball_direction.y = -1 * ball_direction.y
	
	#rebater a bola na esqueda e na direita
	if (ball_position.x < 17 or ball_position.x > screen_size.x-17):
		ball_position = screen_size * 0.5
		ball_direction = Vector2(randf()*2.0-1.0,0).normalized()
		ball_speed = BALL_SPEED
	
	#movimentar player left
	var player_left_position = $PlayerLeftSprite.position
	if Input.is_action_pressed("ui_w") and player_left_position.y > 65:
		player_left_position.y = player_left_position.y - PLAYER_SPEED * delta
	if Input.is_action_pressed("ui_s") and player_left_position.y < screen_size.y - 65:
		player_left_position.y = player_left_position.y + PLAYER_SPEED * delta
	$PlayerLeftSprite.position = player_left_position
	
	#movimentar player right
	var player_right_position = $PlayerRightSprite.position
	if Input.is_action_pressed("ui_up") and player_right_position.y > 65 :
		player_right_position.y = player_right_position.y - PLAYER_SPEED * delta
	if Input.is_action_pressed("ui_down") and player_right_position.y < screen_size.y - 65:
		player_right_position.y = player_right_position.y + PLAYER_SPEED * delta
	$PlayerRightSprite.position = player_right_position
	
	var player_left_rect2 = Rect2($PlayerLeftSprite.position-player_size/2,player_size)
	var player_right_rect2 = Rect2($PlayerRightSprite.position-player_size/2,player_size)
	
	if player_left_rect2.has_point(ball_position):
		ball_direction.x = -1 * ball_direction.x
		ball_direction.y = randf()*2.0-1.0
		ball_direction = ball_direction.normalized()
		ball_speed = ball_speed * 1.10
	if player_right_rect2.has_point(ball_position):
		ball_direction.x = -1 * ball_direction.x
		ball_direction.y = randf()*2.0-1.0
		ball_direction = ball_direction.normalized()
		ball_speed = ball_speed * 1.10
		
	$BallSprite.position = ball_position
	
