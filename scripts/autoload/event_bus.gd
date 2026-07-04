extends Node

@warning_ignore("unused_signal")
signal player_score_added(scoreToAdd: int)

@warning_ignore("unused_signal")
signal player_life_lost(lifeToLose: int)

@warning_ignore("unused_signal")
signal player_life_gained(lifeToGain: int)

@warning_ignore("unused_signal")
signal game_is_over()

# signal tourist_has_been_hit(tourist: Tourist)