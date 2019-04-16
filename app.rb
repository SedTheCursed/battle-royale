require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

# Creation des PNJ
player1 = Player.new('Josiane')
player2 = Player.new('José')

# Tant que les deux combattant sont debouts, on montre leur etat
# et il s'affrontent.
while player1.health_points.positive? && player2.health_points.positive?
  puts "\nVoici l'etat de chaque joueuer :"
  puts player1.show_state
  puts player2.show_state

  puts "\nPassons à la phase d'attaque"
  player1.attacks(player2) if player1.health_points.positive?
  puts "\n"
  player2.attacks(player1) if player2.health_points.positive?
  puts '-' * 30 + "\n"
end

# Determination du vainquer et affichage de son nom.
winner = player1.health_points.positive? ? player1 : player2
puts "\n#{winner.name} est le vainqueur !"
