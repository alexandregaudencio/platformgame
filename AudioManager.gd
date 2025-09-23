extends Node

# Sinais
signal music_changed(new_stream: AudioStream)
signal sfx_played(stream: AudioStream)

# Configuráveis
@export_group("Buses")
@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"

@export_group("Pool")
@export var sfx_pool_size: int = 16
@export var max_sfx_per_frame: int = 4 # limit to avoid spikes

# Estado interno
var _music_players: Array[AudioStreamPlayer] = []
var _current_music_idx: int = 0
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_pool_next: int = 0
var _pending_sfx_this_frame: int = 0

# Persistência simples
const SAVE_FILE := "user://audio_settings.cfg"
var _music_volume_db: float = 0.0
var _sfx_volume_db: float = 0.0

func _ready() -> void:
	_init_buses()
	_create_music_players()
	_create_sfx_pool()
	_load_settings()

func _process(_delta: float) -> void:
	# reset per-frame limiter
	_pending_sfx_this_frame = 0

func _init_buses() -> void:
	# checar se os buses existem (robusto)
	var music_idx := AudioServer.get_bus_index(music_bus_name)
	if music_idx < 0:
		push_warning("Bus '%s' not found. Música será enviada ao bus master." % music_bus_name)
	var sfx_idx := AudioServer.get_bus_index(sfx_bus_name)
	if sfx_idx < 0:
		push_warning("Bus '%s' not found. SFX será enviada ao bus master." % sfx_bus_name)

func _create_music_players() -> void:
	# Dois players para crossfade
	for i in sfx_pool_size:
		var p := AudioStreamPlayer.new()
		p.bus = music_bus_name if AudioServer.get_bus_index(music_bus_name) >= 0 else "Master"
		p.stream_paused = true
		add_child(p)
		_music_players.append(p)
	_current_music_idx = 0

func _create_sfx_pool() -> void:
	for i in sfx_pool_size:
		var p := AudioStreamPlayer.new()
		p.bus = sfx_bus_name if AudioServer.get_bus_index(sfx_bus_name) >= 0 else "Master"
		p.stream = null
		p.autoplay = false
		p.volume_db = 0.0
		add_child(p)
		_sfx_pool.append(p)
	_sfx_pool_next = 0

func play_Music(stream: AudioStream, loop: bool = true, crossfade_time: float = 0.6) -> void:
	# Tenta não reiniciar se for a mesma música
	if stream == null:
		push_warning("play_music: stream é null")
		return
	var cur := _music_players[_current_music_idx]
	if cur.stream == stream and cur.playing:
		return # já tocando

	# prepara o outro player (o alvo)
	var next_idx := (_current_music_idx + 1) % 2
	var next_p := _music_players[next_idx]
	next_p.stream = stream
	#next_p.loop_mode = loop
	next_p.volume_db = -80.0 # começar silenciado
	next_p.stream_paused = false
	next_p.play()
	emit_signal("music_changed", stream)

	# crossfade com create_tween()
	var tween := create_tween()
	tween.tween_property(next_p, "volume_db", _music_volume_db, crossfade_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_music_players[_current_music_idx], "volume_db", -80.0, crossfade_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_crossfade_finished").bind(_current_music_idx, next_idx))

	# atualizar índice (será atualizado no callback também)
	_current_music_idx = next_idx

func _on_crossfade_finished(old_idx: int, new_idx: int) -> void:
	# parada e limpeza do antigo
	var old_p := _music_players[old_idx]
	if old_p.playing:
		old_p.stop()
		old_p.stream = null

func stop_music(fade_time: float = 0.4) -> void:
	var cur := _music_players[_current_music_idx]
	if cur.stream == null or not cur.playing:
		return
	var tween := create_tween()
	tween.tween_property(cur, "volume_db", -80.0, fade_time).connect("finished", Callable(self, "_on_stop_music_finished").bind(cur))

func _on_stop_music_finished(player: AudioStreamPlayer) -> void:
	if player.playing:
		player.stop()
	player.stream = null

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if stream == null:
		push_warning("play_sfx: stream é null")
		return
	# limit per frame to avoid audio floods
	if _pending_sfx_this_frame >= max_sfx_per_frame:
		return
	_pending_sfx_this_frame += 1

	var p := _sfx_pool[_sfx_pool_next]
	_sfx_pool_next = (_sfx_pool_next + 1) % _sfx_pool.size()
	p.stop()
	p.stream = stream
	p.pitch_scale = pitch_scale
	p.volume_db = volume_db + _sfx_volume_db
	p.stream_paused = false
	p.play()
	emit_signal("sfx_played", stream)

func set_music_volume_db(db: float) -> void:
	_music_volume_db = db
	var idx := AudioServer.get_bus_index(music_bus_name)
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)
	# atualiza players ativos (para manter coerência durante crossfade)
	for p in _music_players:
		p.volume_db = db

func set_sfx_volume_db(db: float) -> void:
	_sfx_volume_db = db
	var idx := AudioServer.get_bus_index(sfx_bus_name)
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)

func get_music_volume_db() -> float:
	return _music_volume_db

func get_sfx_volume_db() -> float:
	return _sfx_volume_db

func _save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music_db", _music_volume_db)
	cfg.set_value("audio", "sfx_db", _sfx_volume_db)
	var err := cfg.save(SAVE_FILE)
	if err != OK:
		push_warning("Falha ao salvar configurações de áudio: %s" % err)

func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_FILE) == OK:
		_music_volume_db = float(cfg.get_value("audio", "music_db", _music_volume_db))
		_sfx_volume_db = float(cfg.get_value("audio", "sfx_db", _sfx_volume_db))
		set_music_volume_db(_music_volume_db)
		set_sfx_volume_db(_sfx_volume_db)

func save_settings() -> void:
	_save_settings()

func is_music_playing() -> bool:
	return _music_players[_current_music_idx].playing and _music_players[_current_music_idx].stream != null
