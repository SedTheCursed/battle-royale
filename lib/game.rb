class Game
  # Tableau de noms aléatoires pour les PNJ
  @@foes = ['Uriel', 'Gabriel', 'Raphaël', 'Michel', 'Oengus', 'Seamus', 'Liam', 'Donatien', 'Alphonse', 'François', 'Jules', 'Georges', 'Herbert', 'Tim', 'William', 'Bruce', 'Tony', 'Richard', 'Arthur', 'Melchior', 'Gaspard', 'Hannibal', 'César', 'Marius', 'Roméo', 'Arnaud', 'Esteban', 'Napoléon', 'Louis', 'Henri', 'Charles', 'Felix', 'Kokoro', 'Noël', 'Antoine', 'Marc', 'Friedrich', 'Dieter', 'Wolfgang', 'Ludwig', 'Johan', 'Sébastien', 'John', 'Lucifer', 'Samael', 'Belial', 'Kobal', 'Baal', 'Malphas', 'Haagenti']

  # Les propriétés de Game n'ayant pas besoin d'être accessible en dehors d'une
  # instance, elles ne nécéssite pas d'attr

  def initialize(name)
    @players_left = 10
    @human_player = HumanPlayer.new(name)
    @enemies_in_sight = []
    4.times { @enemies_in_sight << Player.new(random_foe_name) }
  end

  # Methode faisant tourner le coeur de l'application
  def play
    @enemies_in_sight.each { |enemy| new_foe_incoming(enemy) }
    puts "\n"
    pause
    while is_still_ongoing?
      new_players_in_sight
      show_players
      menu_choice(menu)
      enemies_attack
    end
    game_over
  end

  # La majorité des méthodes sont privées, car elles ne sont nécessaire qu'au
  # bon fonctionnement de la méthode play.
  private

  def kill_player(enemy)
    @enemies_in_sight.delete(enemy)
  end

  # Le jeu doit continuer tant que le PJ est vivant et qu'il reste des
  # adversaires, qu'ils soient en vue ou attendant de s'engager dans le combat
  def is_still_ongoing?
    (@players_left.positive? || !@enemies_in_sight.empty?) && @human_player.health_points.positive?
  end

  def random_foe_name
    @@foes[rand(0...@@foes.length)]
  end

  def show_players
    puts border
    puts @human_player.show_state
    puts "Il reste #{@enemies_in_sight.length} ennemi#{'s' if @enemies_in_sight.length > 1} contre toi."
    puts border + "\n\n"
    pause
  end

  def border
    '-' * 50
  end

  def pause
    puts 'Tape "entrée" pour continuer'
    gets.chomp
  end

  def menu
    puts "Quelle action veux-tu effectuer ?\n\n"
    puts 'a - chercher une meilleure arme'
    puts 's - chercher à se soigner'
    puts "\n"
    puts 'attaquer un joueur en vue :'
    @enemies_in_sight.length.times do |index|
      puts "#{index} - #{@enemies_in_sight[index].show_state}"
    end
    puts "\n"
    print '> '
    gets.chomp
  end

  def menu_choice(choice)
    if choice.match(/a/i)
      @human_player.search_weapon
    elsif choice.match(/s/i)
      @human_player.search_health_pack
    elsif choice.match(/^\d+$/) && choice.to_i < @enemies_in_sight.length
      enemy = @enemies_in_sight[choice.to_i]
      @human_player.attacks(enemy)
      kill_player(enemy) if enemy.health_points <= 0
    else
      puts 'Tu es incapable d\'agir.'
    end
    puts "\n\n"
    pause
  end

  def enemies_attack
    return if @enemies_in_sight.empty?

    puts border
    puts "Les autres joueurs t'attaquent !\n"
    puts border + "\n"
    @enemies_in_sight.each do |enemy|
      enemy.attacks(@human_player)
      break if @human_player.health_points <= 0
    end
    puts border
    puts "\n\n"
    pause
  end

  def game_over
    puts 'Cela fut un beau combat !'
    if @human_player.health_points.positive?
      puts "Et #{@human_player.name} en a emergé vainqueur ! Felicitations à lui !"
    else
      puts "Hélas, #{@human_player.name} a été vaincu et son corps va rejoindre la fosse commune."
    end
  end

  def new_foe_incoming(foe)
    puts "#{foe.name} arrive sur le champ de bataille."
  end

  def add_new_foe
    new_foe = Player.new(random_foe_name)
    @enemies_in_sight << new_foe
    @players_left -= 1
    new_foe_incoming(new_foe)
  end

  # Détermine si de nouveaux assaillants se joignent au combat
  # au debut de chaque tour
  def new_players_in_sight
    if @players_left.positive?
      random_encounter = rand(1..6)
      if random_encounter == 1
        puts 'Tout est calme. Pas de nouvel adversaire en vue.'
      # Ajoute un nouvel adversaire si le resultat est compris entre 2 et 4,
      # ou s'il ne reste plus qu'un seul à pouvoir entrer en jeu.
      elsif random_encounter < 5 || @players_left == 1
        add_new_foe
      else
        2.times { add_new_foe }
      end
    else
      puts 'Tous les joueurs sont déjà en vue'
    end
    pause
  end
end
