require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/game'

# Créé une ligne verticale
def border
  '-' * 50
end

# Créé une ligne du cartouche avec le texte centré 
def line(message = '')
  '| ' + message.center(46) + ' |'
end

# Crée le cartouche de titre
def header
  puts border
  puts line
  puts line('LET\'S GET READY TO RUMBLE!')
  puts line('It\'s time for...')
  puts line('BATTLE ROYALE!!!!')
  puts line
  puts border
end

# Demande le nom du PJ au joueur qui servira à initialiser une instance de Game
def create_player_character
  puts "\n\nQuel est le nom de l\'apprenti héros ?"
  print '> '
  hero = gets.chomp.capitalize
  puts "\n\n"
  hero
end

def process
  header
  pc = create_player_character
  Game.new(pc).play
end

process
