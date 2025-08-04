extends Node

@warning_ignore_start("unused_signal")
signal on_ball_stopped
signal on_player_scored(score_value: int)
signal on_game_timer_ended

# Power Ups
signal on_power_up_gathered(power_up: ResPowerUp)
signal on_power_up_activated(power_up: ResPowerUp)
signal on_power_up_expired(power_up: ResPowerUp)

signal on_machine_repaired(machine: Machine)
