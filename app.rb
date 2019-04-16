require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

player1 = Player.new("Josiane")
player2 = Player.new("José")

while player1.health_points > 0 && player2.health_points > 0
  puts "\nVoici l'etat de chaque joueuer :"
  puts player1.show_state
  puts player2.show_state

  puts "\nPassons à la phase d'attaque"
  player1.attacks(player2) if player1.health_points > 0
  puts "\n"
  player2.attacks(player1) if player2.health_points > 0
  puts '-' * 30 + "\n"
end

winner = player1.health_points > player2.health_points ? player1 : player2
puts "\n#{winner.name} est le vainqueur !"
