class Game
  @@foes = ["Uriel", "Gabriel", "Raphaël", "Michel", "Oengus", "Seamus", "Liam", "Donatien", "Alphonse", "François", "Jules", "Georges", "Herbert", "Tim", "William", "Bruce", "Tony", "Richard", "Arthur", "Melchior", "Gaspard", "Hannibal", "César", "Marius", "Roméo", "Arnaud",  "Esteban", "Napoléon", "Louis", "Henri", "Charles", "Felix", "Kokoro", "Noël", "Antoine", "Marc", "Friedrich", "Dieter", "Wolfgang", "Ludwig", "Johan", "Sébastien", "John", "Lucifer", "Samael", "Belial", "Kobal", "Baal", "Malphas", "Haagenti"]

  def initialize(name)
    @players_left = 10
    @human_player = HumanPlayer.new(name)
    @enemies_in_sight = []
    4.times { @enemies_in_sight << Player.new(random_foe_name) }
  end

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

  private
  def kill_player(enemy)
    @enemies_in_sight.delete(enemy)
  end

  def is_still_ongoing?
    (@players_left > 0 || !@enemies_in_sight.empty?) && @human_player.health_points > 0
  end

  def random_foe_name
    @@foes[rand(0..@@foes.length)]
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
    puts "Tape \"entrée\" pour continuer"
    gets.chomp
  end

  def menu
    puts "Quelle action veux-tu effectuer ?\n\n"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner" 
    puts "\n"
    puts "attaquer un joueur en vue :"
    @enemies_in_sight.length.times { |index| puts "#{index} - #{@enemies_in_sight[index].show_state}"}
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
      puts "Tu es incapable d'agir."
    end
    puts "\n\n"
    pause
  end

  def enemies_attack
    unless @enemies_in_sight.empty?
      puts border
      puts "Les autres joueurs t'attaquent !\n"
      puts border + "\n"
      @enemies_in_sight.each do |enemy|
        enemy.attacks(@human_player)
      end
      puts border
      puts "\n\n"
      pause
    end
  end

  def game_over
    puts "Cela fut un beau combat !"
    puts @human_player.health_points > 0 ? "Et #{@human_player.name} en a emergé vainqueur ! Felicitations à lui !" : "Hélas, #{@human_player.name} a été vaincu et son corps va rejoindre la fosse commune."
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

  def new_players_in_sight
    if @players_left > 0
      random_encounter = rand(1..6)
      if random_encounter == 1
        puts "Tout est calme. Pas de nouvel adversaire en vue."
      elsif random_encounter < 5 || @players_left == 1
        add_new_foe
      else
        2.times {add_new_foe}
      end
    else
      puts "Tous les joueurs sont déjà en vue"
    end
    pause
  end

=begin
        Si le dé vaut entre 2 et 4 inclus, un nouvel adversaire arrive en vue. Il faut alors créer un Player avec un nom aléatoire du genre "joueur_1234" ou "joueur_6938" ou ce que tu veux. Affiche un message informant l'utilisateur de ce qui se passe.
        Si le dé vaut 5 ou 6, cette fois c'est 2 nouveaux adversaires qui arrivent en vue. De même qu'au-dessus, il faut les créer et les rajouter au jeu. Rajoute toujours un message informant l'utilisateur.
    Et maintenant, il faut que cette méthode new_players_in_sight soit appelée dans ton app_3.rb juste avant l'affichage du menu à l'utilisateur. Cela permet d'ajouter, petit à petit, des adversaires en vue !

Voilà, une fois que tu auras fait ça, tu pourras essayer de sortir vivant d'un combat contre 10, 20 voire 100 adversaires ! N'hésite pas à pimper l'affichage pour l'utilisateur et à joueur sur les paramètres (la vie de chaque adversaire, ta vie, la taille de pack de vie qu'on peut trouver, etc.) pour trouver ceux qui sont les plus fun !
=end
end
