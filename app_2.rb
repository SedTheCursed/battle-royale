require 'bundler'
Bundler.require

require_relative 'lib/game'
require_relative 'lib/player'

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

# Demande le nom du PJ au joueur avant de le créer
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

# Retire du jeu les PNJ morts
def living_npcs(characters)
  characters.delete_if {|character| character.health_points <= 0 }
end

# Crée le menu de choix du PJ
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

# Fait agir le PJ selon son choix
def pc_action(choice, pc, npcs)
  if choice.match(/a/i)
    pc.search_weapon
  elsif choice.match(/s/i)
    pc.search_health_pack
  # s'assure que le choix est un nombre correspondant à un PNJ
  elsif choice.match(/^\d+$/) && choice.to_i < npcs.length
    pc.attacks(npcs[choice.to_i])
  # si aucun choix valide est donné, le PJ perd son tour
  else
    puts "Tu es incapable d'agir."
  end
  puts "\n\n"
  gets.chomp
end

# A moins qu'il ne reste plus qu'un seul PNJ, qui vient de mourir,
# les PNJ attaquent
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

# Fonction-centrale qui gère le coeur du jeu, forçant les combats à continuer
# tant qu'il reste des PNJ et que le PJ est vivant, avant d'afficher le message
# de fin de partie.
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
