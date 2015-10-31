class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if @en_vie
    	return @nom + "  (#{@points_de_vie}/100 PV)"
    else
    	return @nom + "  (vaincu)"
    end
  end

  def attaque(personne)
    puts "#{@nom} attaque #{personne.nom}"
    if @nom == "Jean-Michel Paladin"
    	puts "#{@nom} a un bonus de #{@degats_bonus} point(s) d'attaque"
    end
    personne.subit_attaque(degats)
  end

  def subit_attaque(degats_recus)
    @points_de_vie -= degats_recus
    puts "#{@nom} se voit infliger #{degats_recus} points de dégât"
    @en_vie = false unless @points_de_vie > 0
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    @degats_bonus = 0
    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    degats = rand(10..35) + @degats_bonus
  end

  def soin
    soin = rand(1..50)
    soin = 100 - (@points_de_vie) if soin > (100 - @points_de_vie)
    @points_de_vie += soin
    puts "#{nom} a gagné #{soin}PV supplémentaires"
  end

  def ameliorer_degats
    point_bonus = rand(1..15)
    @degats_bonus += point_bonus
    puts "#{nom} a gagné un bonus de #{point_bonus} en attaque"
  end
end

class Ennemi < Personne
  def degats
    degats = rand(1..10)
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"
    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    i = 0
    monde.ennemis.each do |ennemi|
    	i += 1 unless ennemi.en_vie
    end
    return true if joueur.en_vie == false || i == 3
    return false
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
	  ennemis_en_vie = []
	  @ennemis.each do |ennemi|
	    ennemis_en_vie << ennemi if ennemi.en_vie
	  end
	  return ennemis_en_vie
	end
end

##############


monde = Monde.new

monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

joueur = Joueur.new("Jean-Michel Paladin")

puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

quitter = false
tour_reel = 0

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour - tour_reel} ------------------"

  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  choix = gets.chomp.to_i
  erreur = false

  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    quitter = true
    break
  elsif choix == 2 || choix == 3 || choix == 4
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  else
  	erreur = true
  	puts "Vous avez fait un choix qui n'exite pas,"
		puts "Faites en un parmi ceux de la liste."
		tour_reel += 1
  end

	if erreur == false
	  puts "\nLES ENNEMIS RIPOSTENT !"
	  monde.ennemis_en_vie.each do |ennemi|
	    ennemi.attaque(joueur)
	  end
	  puts "\nEtat du héro: #{joueur.info}\n"
	end

  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n\n"

if quitter == false && Jeu.est_fini(joueur, monde)
	print "-------- RESULTAT DE LA PARTIE --------"
	puts "\nEtat du héro: "
	puts "#{joueur.info}\n"
	puts "\nEtat des ennemis: "
	monde.ennemis.each do |ennemi|
		puts "#{ennemi.info}\n"
	end
	puts "---------------------------------------\n\n"

	if joueur.en_vie
	  puts "Vous avez gagné !\n\n"
	else
	  puts "Vous avez perdu !\n\n"
	end
end