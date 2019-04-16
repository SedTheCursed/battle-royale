require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/game'

def border
  '-' * 50
end

def line(message = '')
  '| ' + message.center(46) + ' |'
end

def header
  puts border
  puts line
  puts line('LET\'S GET READY TO RUMBLE!')
  puts line('It\'s time for...')
  puts line('BATTLE ROYALE!!!!')
  puts line
  puts border
end

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
  my_game = Game.new(pc)
  my_game.play
end

process
