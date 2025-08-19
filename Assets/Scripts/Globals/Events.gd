extends Node

@warning_ignore_start("unused_signal")
signal on_ball_stopped
signal on_player_scored(score_value: int)

# Referee signals
signal on_player_congratulated
signal on_player_aced
signal on_ref_hit

# Game States
signal on_game_timer_ended
signal on_game_started

# Power Ups
signal on_power_up_gathered(power_up: ResPowerUp)
signal on_power_up_activated(power_up: ResPowerUp)
signal on_power_up_expired(type: ResPowerUp.PowerUpEnum)

signal on_machine_repaired(machine: Machine)

signal on_shot_released(strength: float)

signal on_game_state_advanced(state: int)

signal on_tutorial_progressed(state: int)

signal on_max_fire_reached

#shot
signal on_perfect_shot
signal on_normal_shot

signal on_game_timer_last_seconds_reached
