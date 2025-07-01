extends Node

##################################################
# 총알이 추가될 부모 노드
@onready var bullets_node: Node2D = get_tree().root.get_node("Main/Bullets")

# 총알 프리팹
const BULLET_SCENE: PackedScene = preload("res://scenes/bullet/bullet.tscn")
# 최초 미리 생성할 총알 개수
const INITIAL_BULLET_POOL_SIZE: int = 10
# 일정 주기마다 풀을 줄일 시간 간격
const SHRINK_CHECK_INTERVAL: float = 0.1

# 현재 생성된 총알 목록
var bullet_pool: Array[Area2D] = []
# 마지막 총알 사용 이후 얼마나 지났는지
var time_since_last_bullet_use: float = 0.0

##################################################
func _ready() -> void:
	_init_bullet_pool()

##################################################
func _process(delta: float) -> void:
	time_since_last_bullet_use += delta
	
	if time_since_last_bullet_use >= SHRINK_CHECK_INTERVAL:
		time_since_last_bullet_use = 0.0
		_shrink_bullet_pool()	# 일정 시간이 지나면 풀 축소

##################################################
func _init_bullet_pool() -> void:
	for i in range(INITIAL_BULLET_POOL_SIZE):
		var bullet: Area2D = BULLET_SCENE.instantiate()
		bullet.set_using_bullet(false)	# 비활성화 상태로 시작
		
		bullet_pool.append(bullet)		# 풀에 추가
		bullets_node.add_child(bullet)	# 씬 트리에 등록

##################################################
func _shrink_bullet_pool() -> void:
	# 풀 뒤에서부터 순회하며 비사용 총알 제거
	for i in range(bullet_pool.size() - 1, -1, -1):
		# 최소 풀 크기보다 작아지지 않도록 함
		if bullet_pool.size() <= INITIAL_BULLET_POOL_SIZE:
			break
		
		var bullet: Area2D = bullet_pool[i]
		if not bullet.get_using_bullet():
			bullet_pool.remove_at(i)	# 풀 리스트에서도 제거
			bullet.queue_free()		# 씬 트리에서 제거 및 메모리 해제

##################################################
func get_bullet_pool_size() -> int:
	return bullet_pool.size()

##################################################
func get_bullet() -> Area2D:
	# 비활성화된 총알이 있으면 그것을 반환
	for bullet in bullet_pool:
		if not bullet.get_using_bullet():
			bullet.set_using_bullet(true)	# 총알 활성화
			time_since_last_bullet_use = 0.0	# 마지막 사용 시간 초기화
			
			return bullet
	
	# 모두 사용 중이라면 새 총알 인스턴스 생성
	var new_bullet_instance = BULLET_SCENE.instantiate()
	new_bullet_instance.set_using_bullet(true)	# 바로 사용 상태로 설정
	bullet_pool.append(new_bullet_instance)		# 풀에 추가
	bullets_node.add_child(new_bullet_instance)	# 씬 트리에 추가
	time_since_last_bullet_use = 0.0				# 마지막 사용 시간 초기화
	
	return new_bullet_instance
