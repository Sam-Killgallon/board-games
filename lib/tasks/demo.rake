# frozen_string_literal: true

namespace :demo do # rubocop:disable Metrics/BlockLength
  desc 'Generate some data for the application'
  task generate_data: ['demo:generate_games', 'demo:generate_users', 'demo:generate_game_sessions']

  desc 'Generate some demo games for the application'
  task generate_games: :environment do
    raise 'Cannot be run in production!' if Rails.env.production?

    puts 'This game data was generated randomly and does not reflect the attributes of the actual game'

    total = demo_game_data.size
    demo_game_data.each_with_index do |game_data, index|
      print "Creating game #{index + 1} / #{total}\r"
      game = Game.create(game_data)
      GenerateTextBoxImagePreview.call(game) if game # Skip this for performance if the game already exists
    end
    puts ''
  end

  desc 'Generate some demo game sessions for the application'
  task generate_game_sessions: :environment do
    raise 'Cannot be run in production!' if Rails.env.production?

    total = demo_game_session_data.size
    demo_game_session_data.each_with_index do |game_session_data, index|
      print "Creating game session #{index + 1} / #{total}\r"
      users = User.order('RANDOM()').limit(rand(2..10)).to_a
      game_session = CreateGameSession.call(creator: users.pop)
      game_session.update!(**game_session_data, users: users)
    end
    puts ''

    total = Invitation.count
    Invitation.all.each_with_index do |invitation, index|
      print "Updating game session responses #{index + 1} / #{total}\r"
      case rand(3)
      when 0 then invitation.attending!
      when 1 then invitation.declined!
      when 2 then invitation.not_responded!
      end
    end
    puts ''
  end

  desc 'Generate some demo users for the application'
  task generate_users: :environment do
    raise 'Cannot be run in production!' if Rails.env.production?

    total = demo_user_data.size
    demo_user_data.each_with_index do |user_data, index|
      print "Creating user #{index + 1} / #{total}\r"
      password = 'password'
      # Workaround default_scope with 'unscoped'
      games = Game.order('RANDOM()').limit(rand(40))
      User.create(**user_data, password: password, password_confirmation: password, games: games)
    end
    puts ''
  end
end

def demo_user_data # rubocop:disable Metrics/MethodLength
  [
    { email: 'admin@test.com', role: :admin },
    { email: 'admin-foo@test.com', role: :admin },
    { email: 'admin-bar@test.com', role: :admin },
    { email: 'foo@test.com' },
    { email: 'bar@test.com' },
    { email: 'baz@test.com' },
    { email: 'foobar@test.com' },
    { email: 'foobaz@test.com' },
    { email: 'barfoo@test.com' },
    { email: 'barbaz@test.com' },
    { email: 'jim@test.com' },
    { email: 'fred@test.com' },
    { email: 'frank@test.com' },
    { email: 'bob@test.com' },
    { email: 'sam@test.com' },
    { email: 'bill@test.com' },
    { email: 'sally@test.com' },
    { email: 'jean@test.com' },
    { email: 'lucy@test.com' },
    { email: 'carrie@test.com' },
    { email: 'jenni@test.com' },
    { email: 'holly@test.com' },
    { email: 'argus-von-beardy-mcboatface@test.com' },
    { email: 'henry@test.com' },
    { email: 'megan@test.com' }
  ]
end

def demo_game_session_data # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  [
    { scheduled_at: Time.current },
    { scheduled_at: 1.hour.from_now },
    { scheduled_at: 7.5.hours.from_now },
    { scheduled_at: 11.3.hours.from_now },
    { scheduled_at: 15.hours.from_now },
    { scheduled_at: 3.days.from_now },
    { scheduled_at: 6.5.days.from_now },
    { scheduled_at: 2.weeks.from_now },
    { scheduled_at: 4.days.from_now },
    { scheduled_at: 11.3.days.from_now },
    { scheduled_at: 6.weeks.from_now },
    { scheduled_at: 2.4.hours.ago },
    { scheduled_at: 15.3.hours.ago },
    { scheduled_at: 2.days.ago },
    { scheduled_at: 5.days.ago },
    { scheduled_at: 4.weeks.ago },
    { scheduled_at: 6.months.ago },
    { scheduled_at: 1.year.ago },
    { scheduled_at: 5.years.ago },
    { scheduled_at: nil },
    { scheduled_at: nil },
    { scheduled_at: nil }
  ].cycle(2)
end

def demo_game_data # rubocop:disable Metrics/MethodLength
  [
    { title: '18XX', min_players: 1, max_players: 15 },
    { title: '221B Baker Street', min_players: 5, max_players: 13 },
    { title: '30 Seconds', min_players: 4, max_players: 10 },
    { title: 'About Time', min_players: 5, max_players: 15 },
    { title: 'Acquire', min_players: 3, max_players: 9 },
    { title: 'Acronymble', min_players: 5, max_players: 6 },
    { title: 'Adel Verpflichtet', min_players: 2, max_players: 15 },
    { title: 'Afrikan tähti', min_players: 4, max_players: 7 },
    { title: 'Agricola', min_players: 5, max_players: 14 },
    { title: 'Air Charter', min_players: 3, max_players: 12 },
    { title: 'Aksharit', min_players: 4, max_players: 8 },
    { title: "Aladdin's Dragons", min_players: 1, max_players: 11 },
    { title: 'Alhambra', min_players: 2, max_players: 3 },
    { title: 'Alias', min_players: 2, max_players: 2 },
    { title: 'Amun-Re', min_players: 4, max_players: 14 },
    { title: 'Arkham Horror', min_players: 2, max_players: 5 },
    { title: 'Articulate!', min_players: 5, max_players: 10 },
    { title: 'Ashta Chamma', min_players: 5, max_players: 6 },
    { title: 'Auf Achse', min_players: 1, max_players: 11 },
    { title: 'Australia', min_players: 3, max_players: 15 },
    { title: 'Azul', min_players: 3, max_players: 3 },
    { title: 'Bailout! The Game', min_players: 2, max_players: 4 },
    { title: 'Balderdash', min_players: 2, max_players: 14 },
    { title: 'Barbarossa', min_players: 3, max_players: 6 },
    { title: 'Battlestar Galactica', min_players: 4, max_players: 5 },
    { title: 'Bezzerwizzer', min_players: 2, max_players: 11 },
    { title: 'Blankety Blank', min_players: 5, max_players: 5 },
    { title: 'Blokus', min_players: 5, max_players: 5 },
    { title: '(This Game Is) Bonkers!', min_players: 5, max_players: 15 },
    { title: 'Brain Chain', min_players: 4, max_players: 13 },
    { title: 'Brainstorm', min_players: 3, max_players: 13 },
    { title: 'Break the Safe', min_players: 4, max_players: 14 },
    { title: 'Buccaneer', min_players: 2, max_players: 13 },
    { title: 'Clue', min_players: 3, max_players: 8 },
    { title: 'Camel Up', min_players: 3, max_players: 14 },
    { title: 'Candy Land', min_players: 1, max_players: 9 },
    { title: "Can't Stop", min_players: 2, max_players: 3 },
    { title: 'Capitol', min_players: 3, max_players: 6 },
    { title: 'Carcassonne', min_players: 4, max_players: 6 },
    { title: 'Careers', min_players: 5, max_players: 10 },
    { title: 'Caribbean', min_players: 2, max_players: 15 },
    { title: 'Cartagena', min_players: 3, max_players: 3 },
    { title: 'Caylus', min_players: 1, max_players: 10 },
    { title: 'Chinese Chequers', min_players: 5, max_players: 5 },
    { title: 'Chromino', min_players: 2, max_players: 8 },
    { title: 'CirKis', min_players: 1, max_players: 14 },
    { title: 'Civilization', min_players: 1, max_players: 11 },
    { title: 'Clans', min_players: 5, max_players: 12 },
    { title: 'Clue/Cluedo', min_players: 5, max_players: 10 },
    { title: 'Codenames', min_players: 2, max_players: 2 },
    { title: 'Coin Hopping—Washington D.C.', min_players: 1, max_players: 2 },
    { title: 'Colt Express', min_players: 4, max_players: 14 },
    { title: 'Concept', min_players: 5, max_players: 6 },
    { title: 'Conspiracy', min_players: 1, max_players: 11 },
    { title: 'Cosmic Encounter', min_players: 2, max_players: 2 },
    { title: 'Cranium', min_players: 2, max_players: 13 },
    { title: 'Crosstrack', min_players: 1, max_players: 11 },
    { title: 'Dark Tower', min_players: 5, max_players: 6 },
    { title: 'Dead of Winter: A Cross Roads Game', min_players: 5, max_players: 7 },
    { title: 'Diamant', min_players: 3, max_players: 8 },
    { title: 'Dixit', min_players: 4, max_players: 11 },
    { title: 'Domaine', min_players: 1, max_players: 7 },
    { title: 'Dominion', min_players: 2, max_players: 9 },
    { title: "Don't Miss the Boat", min_players: 1, max_players: 14 },
    { title: "Don't Quote Me", min_players: 5, max_players: 11 },
    { title: 'Dorn', min_players: 2, max_players: 9 },
    { title: 'Drunter und Drüber', min_players: 5, max_players: 10 },
    { title: 'Dune', min_players: 1, max_players: 9 },
    { title: 'Dungeons & Dragons', min_players: 3, max_players: 11 },
    { title: 'El Grande', min_players: 5, max_players: 14 },
    { title: 'Elfenland', min_players: 5, max_players: 7 },
    { title: 'Enchanted Forest', min_players: 4, max_players: 14 },
    { title: 'Entdecker', min_players: 3, max_players: 4 },
    { title: 'Escape from Atlantis', min_players: 5, max_players: 15 },
    { title: 'Farlander', min_players: 5, max_players: 13 },
    { title: 'Fictionary', min_players: 3, max_players: 13 },
    { title: 'Figure It Out', min_players: 1, max_players: 8 },
    { title: 'Fireball Island', min_players: 5, max_players: 14 },
    { title: 'Focus', min_players: 2, max_players: 5 },
    { title: 'Fresco', min_players: 1, max_players: 13 },
    { title: 'Game For Fame', min_players: 4, max_players: 11 },
    { title: 'The Game of Life', min_players: 5, max_players: 10 },
    { title: 'GiftTRAP', min_players: 1, max_players: 15 },
    { title: 'Giganten', min_players: 4, max_players: 14 },
    { title: 'Girl Talk', min_players: 4, max_players: 5 },
    { title: 'Glasnost The Game', min_players: 2, max_players: 5 },
    { title: 'Go', min_players: 1, max_players: 15 },
    { title: 'Great Train Robbery', min_players: 2, max_players: 10 },
    { title: 'GridIron Master', min_players: 1, max_players: 13 },
    { title: 'Halma', min_players: 4, max_players: 6 },
    { title: 'History of the World', min_players: 2, max_players: 11 },
    { title: 'Hooop!', min_players: 3, max_players: 10 },
    { title: 'Husker Du?', min_players: 4, max_players: 6 },
    { title: "I'm the Boss!", min_players: 2, max_players: 12 },
    { title: 'Imperial', min_players: 3, max_players: 13 },
    { title: 'Indigo', min_players: 5, max_players: 5 },
    { title: 'Ingenious', min_players: 2, max_players: 4 },
    { title: 'Inkan aarre', min_players: 3, max_players: 7 },
    { title: 'Java', min_players: 2, max_players: 3 },
    { title: 'Journey through Europe', min_players: 1, max_players: 10 },
    { title: 'Junta', min_players: 1, max_players: 13 },
    { title: 'Keltis', min_players: 2, max_players: 5 },
    { title: 'Kill Doctor Lucky', min_players: 1, max_players: 14 },
    { title: 'Kingdoms', min_players: 3, max_players: 9 },
    { title: 'Landslide', min_players: 5, max_players: 10 },
    { title: 'Las Vegas', min_players: 3, max_players: 8 },
    { title: 'Le Havre', min_players: 2, max_players: 12 },
    { title: 'Logo Board Game', min_players: 3, max_players: 15 },
    { title: 'The London Game', min_players: 5, max_players: 8 },
    { title: 'Lords of Waterdeep', min_players: 5, max_players: 13 },
    { title: 'Löwenherz', min_players: 2, max_players: 12 },
    { title: 'Luck of the Draw', min_players: 5, max_players: 11 },
    { title: 'Die Macher', min_players: 5, max_players: 15 },
    { title: 'The Mad Magazine Game', min_players: 1, max_players: 2 },
    { title: 'The Magic Labyrinth', min_players: 4, max_players: 7 },
    { title: 'Mahjong', min_players: 4, max_players: 12 },
    { title: 'Malefiz', min_players: 4, max_players: 13 },
    { title: 'Mall Madness', min_players: 1, max_players: 14 },
    { title: 'Manhattan', min_players: 2, max_players: 9 },
    { title: 'Master Labyrinth', min_players: 2, max_players: 4 },
    { title: 'Masterpiece', min_players: 3, max_players: 4 },
    { title: 'Medici', min_players: 4, max_players: 12 },
    { title: 'Medina', min_players: 4, max_players: 4 },
    { title: 'Mensch ärgere dich nicht', min_players: 2, max_players: 2 },
    { title: 'Merchant of Venus', min_players: 5, max_players: 10 },
    { title: 'Mexica', min_players: 5, max_players: 7 },
    { title: 'Mine a million', min_players: 5, max_players: 8 },
    { title: 'Modern Art', min_players: 1, max_players: 13 },
    { title: 'Mutant Meeples', min_players: 2, max_players: 9 },
    { title: 'Near and Far', min_players: 1, max_players: 2 },
    { title: 'Niagara', min_players: 5, max_players: 7 },
    { title: 'Okey', min_players: 2, max_players: 2 },
    { title: 'Omega Virus', min_players: 2, max_players: 10 },
    { title: 'Ouija', min_players: 5, max_players: 5 },
    { title: 'Outrage!', min_players: 4, max_players: 6 },
    { title: 'Pack & Stack', min_players: 1, max_players: 3 },
    { title: 'Pandemic', min_players: 5, max_players: 9 },
    { title: 'Parcheesi', min_players: 4, max_players: 4 },
    { title: 'Parqués', min_players: 4, max_players: 14 },
    { title: 'Pay Day', min_players: 2, max_players: 8 },
    { title: 'Personal Preference', min_players: 1, max_players: 10 },
    { title: 'Pictionary', min_players: 1, max_players: 13 },
    { title: "Pirate's Cove", min_players: 5, max_players: 7 },
    { title: 'Power Grid', min_players: 4, max_players: 7 },
    { title: 'Primordial Soup', min_players: 1, max_players: 6 },
    { title: 'Princes of Florence', min_players: 5, max_players: 6 },
    { title: 'Puerto Rico', min_players: 2, max_players: 11 },
    { title: 'Puzzle', min_players: 3, max_players: 7 },
    { title: 'Qin', min_players: 4, max_players: 13 },
    { title: "The Quest of the Philosopher's Stone", min_players: 1, max_players: 9 },
    { title: 'Quoridor', min_players: 2, max_players: 12 },
    { title: 'Qwirkle', min_players: 2, max_players: 4 },
    { title: 'Ra', min_players: 2, max_players: 7 },
    { title: 'Rail Baron', min_players: 2, max_players: 12 },
    { title: 'Rappakalja', min_players: 5, max_players: 10 },
    { title: 'Razzia', min_players: 1, max_players: 15 },
    { title: 'The Really Nasty Horse Racing Game', min_players: 1, max_players: 8 },
    { title: 'Ricochet Robots', min_players: 5, max_players: 8 },
    { title: 'Rivers, Roads & Rails', min_players: 3, max_players: 15 },
    { title: 'RoboRally', min_players: 1, max_players: 12 },
    { title: 'Roulette', min_players: 1, max_players: 7 },
    { title: 'Rummikub', min_players: 3, max_players: 8 },
    { title: 'Rummoli', min_players: 5, max_players: 5 },
    { title: 'Saint Petersburg', min_players: 2, max_players: 13 },
    { title: 'Samurai', min_players: 2, max_players: 7 },
    { title: 'San Marco', min_players: 3, max_players: 5 },
    { title: 'Scattergories', min_players: 1, max_players: 10 },
    { title: 'Scene It', min_players: 3, max_players: 12 },
    { title: 'Scotland Yard', min_players: 2, max_players: 14 },
    { title: 'Scoundrels of Skullport', min_players: 1, max_players: 12 },
    { title: 'Scrabble', min_players: 5, max_players: 15 },
    { title: 'Sequence', min_players: 5, max_players: 10 },
    { title: 'The Settlers of Catan', min_players: 3, max_players: 15 },
    { title: 'Shadows over Camelot', min_players: 4, max_players: 7 },
    { title: 'Sherlock Holmes: Consulting Detective', min_players: 1, max_players: 14 },
    { title: 'Skirrid', min_players: 3, max_players: 8 },
    { title: 'Small World', min_players: 4, max_players: 12 },
    { title: 'Snakes and Ladders', min_players: 1, max_players: 7 },
    { title: 'Sorry!', min_players: 4, max_players: 15 },
    { title: 'Splendor', min_players: 2, max_players: 9 },
    { title: 'Squatter', min_players: 4, max_players: 10 },
    { title: 'Stock Ticker', min_players: 2, max_players: 15 },
    { title: 'Taj Mahal', min_players: 3, max_players: 3 },
    { title: 'Take It Easy', min_players: 2, max_players: 5 },
    { title: 'Take Off!', min_players: 2, max_players: 4 },
    { title: 'Take the Galaxy', min_players: 1, max_players: 2 },
    { title: 'Terra Mystica', min_players: 5, max_players: 7 },
    { title: 'Through the Desert', min_players: 4, max_players: 5 },
    { title: 'Thurn and Taxis', min_players: 2, max_players: 10 },
    { title: 'Ticket to Ride', min_players: 5, max_players: 8 },
    { title: 'Tigris and Euphrates', min_players: 2, max_players: 9 },
    { title: 'Tikal', min_players: 4, max_players: 10 },
    { title: 'Timberland', min_players: 3, max_players: 15 },
    { title: "Time's Up!", min_players: 2, max_players: 4 },
    { title: 'Top Secret Spies', min_players: 4, max_players: 7 },
    { title: 'Torres', min_players: 4, max_players: 12 },
    { title: 'Totopoly', min_players: 1, max_players: 7 },
    { title: 'Tracks to Telluride', min_players: 5, max_players: 8 },
    { title: 'TransAmerica', min_players: 1, max_players: 8 },
    { title: 'Trivia Crack', min_players: 4, max_players: 14 },
    { title: 'Trivial Pursuit', min_players: 1, max_players: 2 },
    { title: 'Trouble', min_players: 5, max_players: 13 },
    { title: 'Twilight Imperium', min_players: 1, max_players: 10 },
    { title: 'Twin Tin Bots', min_players: 3, max_players: 3 },
    { title: 'Ubongo', min_players: 1, max_players: 11 },
    { title: 'Upwords', min_players: 1, max_players: 7 },
    { title: 'Vanished Planet', min_players: 4, max_players: 12 },
    { title: 'Vinci', min_players: 4, max_players: 4 },
    { title: 'Yahtzee', min_players: 1, max_players: 1 },
    { title: 'Yut', min_players: 5, max_players: 7 },
    { title: 'Zombies!!!', min_players: 3, max_players: 12 },
    { title: 'Zoophoria', min_players: 1, max_players: 4 },
    { title: 'Betrayal at House on the Hill', min_players: 4, max_players: 9 },
    { title: 'Castle Panic', min_players: 3, max_players: 9 },
    { title: 'Flash Point', min_players: 5, max_players: 11 },
    { title: 'Forbidden Island', min_players: 2, max_players: 5 },
    { title: 'Freedom: The Underground Railroad', min_players: 3, max_players: 9 },
    { title: 'Hanabi', min_players: 1, max_players: 10 },
    { title: 'Lord of the Rings', min_players: 1, max_players: 8 },
    { title: 'Sentinels of the Multiverse', min_players: 2, max_players: 6 },
    { title: 'Space Alert', min_players: 5, max_players: 10 },
    { title: 'Spirit Island', min_players: 2, max_players: 15 },
    { title: 'X-COM', min_players: 5, max_players: 13 },
    { title: 'Fuse', min_players: 5, max_players: 5 }
  ]
end
