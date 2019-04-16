class Game
  attr_reader :human_player, :enemies

  def initialize(name)
    @human_player = HumanPlayer.new(name)
    @enemies = []
    ["le nabot","le gobelin", "le squelette", "le zombie"].each {|enemy| @enemies << Player.new(enemy) }
  end

  def play
    while is_still_ongoing?
      show_players
      menu_choice(menu)
      enemies_attack
    end
    game_over
  end

  private
  def kill_player(enemy)
    @enemies.delete(enemy)
  end

  def is_still_ongoing?
    !@enemies.empty? && @human_player.health_points > 0
  end

  def show_players
    puts border
    puts @human_player.show_state
    puts "Il reste #{@enemies.length} ennemi#{'s' if enemies.length > 1} contre toi."
    puts border + "\n\n"
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
    @enemies.length.times { |index| puts "#{index} - #{@enemies[index].show_state}"}
    puts "\n"
    print '> '
    gets.chomp
  end

  def menu_choice(choice)
    if choice.match(/a/i)
      @human_player.search_weapon
    elsif choice.match(/s/i)
      @human_player.search_health_pack
    elsif choice.match(/^\d+$/) && choice.to_i < @enemies.length
      enemy = @enemies[choice.to_i]
      @human_player.attacks(enemy)
      kill_player(enemy) if enemy.health_points <= 0
    else
      puts "Tu es incapable d'agir."
    end
    puts "\n\n"
    pause
  end

  def enemies_attack
    unless @enemies.empty?
      puts border
      puts "Les autres joueurs t'attaquent !\n"
      puts border + "\n"
      @enemies.each do |enemy|
        enemy.attacks(@human_player)
      end
      puts border
      puts "\n\n"
      pause
    end
  end

  def game_over
    puts "Cela fut un beau combat !"
    puts @human_player.health_points > 0 ? "Et #{@human_player.name} en a emergé vainqueur ! Felicitations à lui !" : "Hélas, #{human_player.name} a été vaincu et son corps va rejoindre la fosse commune."
  end
end
