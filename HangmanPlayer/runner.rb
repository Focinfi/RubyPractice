require_relative './lib/hangman_player.rb'
require_relative './config/settings.rb'

HangManPlayer.new(Settings.player_id).play

