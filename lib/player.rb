class Player
  #attr_reader a été choisi plutôt que accessor, car les propriétés n'ont pas besoin d'être changé en dehors de l'objet.
  attr_reader :name, :health_points 

  def initialize(name)
    @name = name
    @health_points = 10
  end

  def show_state
    @health_points > 0 ? "#{@name.capitalize} a #{@health_points} points de vie." : "#{@name} est mort."
  end

  def gets_damage(damage)
    @health_points -= damage
    puts "#{@name.capitalize} a été tué !" if @health_points <= 0
  end

  def attacks(foe)
    puts "\n#{@name.capitalize} attaque #{foe.name}"
    damage = compute_damage
    puts "Il lui inflige #{damage} point de dégats."
    foe.gets_damage(damage)
  end

  private
  def compute_damage
    return rand(1..6)
  end
end

class HumanPlayer < Player
  attr_reader :weapon_level
  def initialize(name)
    super(name)
    
    @health_points = 100
    @weapon_level = 1
  end

  def show_state
    puts @health_points > 0 ? "Tu as #{@health_points} points de vie et une arme de niveau #{@weapon_level}." : "Tu es mort."
  end

  def search_weapon
    level = rand(1..6)
    puts "\nTu as trouvé une arme de niveau #{level}"
    if level > @weapon_level
      puts "Comme elle est meilleure que la tienne, tu la gardes."
      @weapon_level = level
    else
      puts "Mais comme elle est rouillée, elle conserve ton arme actuelle."
    end
  end

  def search_health_pack
    result = rand(1..6)
    case result
    when 1
      puts "\nTu n'as rien trouvé"
    when 6
      puts "\nTu as trouvé une potion majeure de vie."
      @health_points = @health_points + 80 > 100 ? 100 : @health_points + 80
    else
      puts "\nTu as trouvé une potion mineure de vie."
      @health_points = @health_points + 50 > 100 ? 100 : @health_points + 50
    end
  end

  private
  def compute_damage
    rand(1..6) * @weapon_level
  end
end