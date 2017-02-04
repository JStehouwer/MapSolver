require_relative 'settings'

class Tests
  def run_tests
    puts "Running tests..."
    Settings.new().parse(["-r", "1", "-w", "5", "-l", "5", "-test"])
    map_generation
    place_goal
    place_player
    move_player
    reveal_around_player
    reveal_new_around_player
    break_wall
    no_wall_break
    puts "Passed all tests"
  end

  def map_generation
    # Test 1 - Map generation with goal and player
    puts "Map Generation..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    unless map.get_horizontal_size() == 5
      puts "Horizontal size should be 5\nValue was: #{map.get_horizontal_size()}"
      exit
    end
    unless map.get_vertical_size() == 5
      puts "Vertical size should be 5\nValue was: #{map.get_vertical_size()}"
      exit
    end
    map.get_map().each do |column|
      column.each do |cell|
        unless cell == -1
          puts "Value should be -1\nValue was: #{cell}"
          exit
        end
      end
    end
    puts "\tPassed Map Generation"
  end

  def place_goal
    # Test 2 - Placing the goal on the map
    puts "Place Goal..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    map.place_goal(goal)
    unless map[goal[0]][goal[1]] == 3
      puts "Goal should be #{goal}, but wasn't"
      exit
    end
    puts "\tPassed Place Goal"
  end

  def place_player
    # Test 3 - Placing the player on the map
    puts "Place Player..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    player_loc = [4,4]
    map.place_player(player_loc)
    unless map[4][4] == 4
      puts "Player should be #{player_loc}, but wasn't"
      exit
    end
    puts "\tPassed Place Player"
  end

  def move_player
    # Test 4 - Moving the player
    puts "Move Player..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    player_loc = [4,4]
    player = HumanPlayer.new(goal_location: goal, my_location: player_loc, map: map)
    Main.move_player(map, player, [0,-1])
    unless map[4][3] == 4
      map.render_all()
      puts "Player should be [4,3]\nValue was #{player.get_my_location()}"
      exit
    end
    puts "\tPassed Move Player"
  end

  def reveal_around_player
    # Test 5 - Reveal area around player
    puts "Reveal Around Player..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    player_loc = [3,3]
    player = HumanPlayer.new(goal_location: goal, my_location: player_loc, map: map)
    (0..map.get_horizontal_size()-1).each do |column|
      (0..map.get_vertical_size()-1).each do |row|
        if (goal == [column, row]) || player_loc == [column, row] || Map.adjacent([column, row], player.get_my_location())
          unless player.get_revealed[column][row] == 1
            puts "Location [#{column}, #{row}] is adjacent to player #{player.get_my_location()} but is not revealed"
            exit
          end
        else
          unless player.get_revealed[column][row] == 0
            puts "Location [#{column}, #{row}] is not adjacent to player #{player.get_my_location()} but is revealed"
            exit
          end
        end
      end
    end
    puts "\tPassed Reveal Around Player"
  end

  def reveal_new_around_player
    # Test 6 - Reveal new area around player when player moves
    puts "Reveal New Around Player..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    player_loc = [3,3]
    player = HumanPlayer.new(goal_location: goal, my_location: player_loc, map: map)
    player_old_location = player.get_my_location()
    player.get_revealed.render_all
    Main.move_player(map, player, [0,-1])
    (0..map.get_horizontal_size()-1).each do |column|
      (0..map.get_vertical_size()-1).each do |row|
        if (goal == [column, row]) || player_loc == [column, row] || Map.adjacent([column, row], player.get_my_location())
          unless player.get_revealed[column][row] == 1
            puts "Location [#{column}, #{row}] is adjacent to player #{player.get_my_location()} but is not revealed"
            exit
          end
        elsif Map.adjacent([column, row], player_old_location)
          unless player.get_revealed[column][row] == 1
            puts "Location [#{column}, #{row}] was already revealed and should remain so"
            exit
          end
        else
          unless player.get_revealed[column][row] == 0
            puts "Location [#{column}, #{row}] is not adjacent to player #{player.get_my_location()} but is revealed"
            exit
          end
        end
      end
    end
    puts "\tPassed Reveal New Around Player"
  end

  def break_wall
    # Test 7 - Breaking a wall uses a WallBreak
    puts "Wall Break..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    player_loc = [4,4]
    player = HumanPlayer.new(goal_location: goal, my_location: player_loc, map: map, wall_break: 1)
    map.place_object(2, [3,4])
    unless player.get_wall_break == 1
      puts "Player should have one wall break, but has #{player.get_wall_break}"
      exit
    end
    Main.move_player(map, player, [-1,0])
    unless player.get_wall_break == 0
      puts "Player should have no wall breaks, but has #{player.get_wall_break}"
      exit
    end
    unless map[3][4] == 4
      puts "Player should have moved to [3, 4], but is at #{player.get_my_location}"
      exit
    end
    puts "\tPassed Wall Break"
  end

  def no_wall_break
    # Test 8 - Unable to go through a wall if no wall break
    puts "No Wall Break..."
    map = Map.new(horizontal: 5, vertical: 5, default: -1)
    goal = [0,0]
    player_loc = [4,4]
    player = HumanPlayer.new(goal_location: goal, my_location: player_loc, map: map, wall_break: 0)
    map.place_object(2, [3,4])
    unless player.get_wall_break == 0
      puts "Player should have no wall breaks, but has #{player.get_wall_break}"
      exit
    end
    Main.move_player(map, player, [-1,0])
    unless player.get_my_location == [4,4]
      puts "Player should be at [4, 4], but is at #{player.get_my_location}"
      exit
    end
    unless player.get_wall_break == 0
      puts "Player should have no wall breaks, but has #{player.get_wall_break}"
      exit
    end
    unless map[3][4] == 2
      puts "Map should have a wall at [3, 4], but has #{map[3][4]}"
      exit
    end
    puts "\tPassed No Wall Break"
  end

end
