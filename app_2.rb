require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

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
  hero = HumanPlayer.new(gets.chomp.capitalize)
  puts "\n\n"
  hero
end

def create_non_player_character
  [Player.new('José'), Player.new('Josiane')]
end

def living_npcs(characters)
  characters.delete_if {|character| character.health_points <= 0 }
end

def menu(npcs)
  puts "Quelle action veux-tu effectuer ?\n\n"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner" 
  puts "\n"
  puts "attaquer un joueur en vue :"
  npcs.length.times { |index| puts "#{index} - #{npcs[index].show_state}"}
  puts "\n"
  print '> '
  gets.chomp
end

def pc_action(choice, pc, npcs)
  if choice.match(/a/i)
    pc.search_weapon
  elsif choice.match(/s/i)
    pc.search_health_pack
  elsif choice.match(/^\d+$/) && choice.to_i < npcs.length
    pc.attacks(npcs[choice.to_i])
  else
    puts "Tu es incapable d'agir."
  end
  puts "\n\n"
  gets.chomp
end

def npcs_action(pc, npcs)
  unless npcs.length == 1 && npcs[0].health_points < 0
    puts border
    puts "Les autres joueurs t'attaquent !\n"
    puts border + "\n"
    npcs.each do |npc|
      if npc.health_points > 0
        npc.attacks(pc)
        puts "\n"
      end
    end
    puts border
    puts "\n\n"
    gets.chomp

  end
end

def main_game(pc, npcs)
  while !living_npcs(npcs).empty? && pc.health_points > 0
    puts border
    pc.show_state
    puts border + "\n\n"
    choice = menu(npcs)
    pc_action(choice, pc, npcs)
    npcs_action(pc, npcs)
  end

  puts "Cela fut un beau combat !"
  puts pc.health_points > 0 ? "Et #{pc.name} en a emergé vainqueur ! Felicitations à lui !" : "Hélas, #{pc.name} a été vaincu et son corps va rejoindre la fosse commune."
end

header
pc = create_player_character
npcs = create_non_player_character
main_game(pc, npcs)
