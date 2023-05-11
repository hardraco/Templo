extends KinematicBody2D

const SPEED = 600
const GRAVITY = 18
const JUMP_POWER = -750
const FLOOR = Vector2(0, -1) 

const ARROW  = preload("res://Proyectil/Roca.tscn")
var velocity = Vector2()

var on_ground = false

var is_shooting = false

var is_dead = false

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		if is_shooting == false || is_on_floor() == false:
			velocity.x = SPEED
			if is_shooting == false:
				$AnimatedSprite.play("Run")
				$AnimatedSprite.flip_h = false
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("left"):
		if is_shooting == false || is_on_floor() == false:
			velocity.x = -SPEED
			if is_shooting == false:
				$AnimatedSprite.play("Run")
				$AnimatedSprite.flip_h = true
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x = 0
		if on_ground == true && is_shooting == false:
			$AnimatedSprite.play("Idle")
	
	if Input.is_action_pressed("up"):
		if is_shooting == false:
			if on_ground == true:
				velocity.y = JUMP_POWER
				on_ground = false
				get_tree().get_nodes_in_group("sfx")[0].get_node("3").play()
	
	if Input.is_action_just_pressed("shoot") && is_shooting == false:
		if is_on_floor():
			velocity.x = 0
		is_shooting = true
		$AnimatedSprite.play("Shoot")
		var arrow = ARROW.instance()
		if sign($Position2D.position.x) == 1:
			arrow.set_arrow_direction(1)
		else:
			arrow.set_arrow_direction(-1)
		get_parent().add_child(arrow)
		arrow.position = $Position2D.global_position
		get_tree().get_nodes_in_group("sfx")[0].get_node("1").play()
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		if on_ground == false:
			is_shooting = false
		on_ground = true
	else:
		if is_shooting == false:
			on_ground = false
			if velocity.y <0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Idle")
	velocity = move_and_slide(velocity, FLOOR)
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				dead()
	
	if velocity.y > 3000:
			dead()  
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("Dead")
	$CollisionShape2D.disabled = true
	get_tree().get_nodes_in_group("sfx")[0].get_node("4").play()
	$Timer.start()

func _on_AnimatedSprite_animation_finished():
	is_shooting = false


func _on_Timer_timeout():
	get_tree().change_scene("res://TitleScreen.tscn")
