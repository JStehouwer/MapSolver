require_relative 'settings'
require_relative 'tests'
require_relative 'map'
require_relative 'human_player'
require_relative 'ai_left_player'
require_relative 'ai_up_player'
require_relative 'ai_diag_player'
require_relative 'ai_dist_player'

class Main
  def self.move_player(map, player, movement)
    desired_location_type = map[player.get_my_location[0]+movement[0]][player.get_my_location[1]+movement[1]]
    if player.valid_move(type: desired_location_type, move: movement)
      player.move(type: desired_location_type, movement: movement)
      map.place_player(player.get_my_location)
    end
  end

  def self.game_loop
    while(true)
      if @goal_location == @player.get_my_location
        puts "The player won.\n#{@player.get_steps} steps were required."
        exit
      end
      @map.render_revealed(revealed: @player.get_revealed)
      @player.render_before_move
      move = @player.ask_for_move(map: @map.multiply_each(@map, @player.get_revealed))
      if move != -1
        Main.move_player(@map, @player, move)
      else
        puts "Quitting the game"
        exit
      end
    end
  end

  def self.run
    # Initialize the settings
    return unless Settings.new.parse(ARGV)
    ARGV.clear

    # If in test mode, quit
    if Settings.test_mode
      puts "In test mode.  Not running Main.\n\n"
      Tests.new.run_tests
      exit
    end

    puts "Started Main\n" if Settings.debug_mode

    # The size of the map
    @map = Map.new(horizontal: Settings.get_horizontal_size,
                  vertical: Settings.get_vertical_size,
                  default: -1)
    @map.generate

    # Place set map locations
    @goal_location = [0,0]
    @player_location = [Settings.get_horizontal_size-1, Settings.get_vertical_size-1]
    @map.place_goal(@goal_location)
    @map.place_player(@player_location)

    # Render the map if in debug mode
    @map.render_all if Settings.debug_mode

    # Create the player
    @player = nil
    case Settings.get_player_file
    when "human"
      @player = HumanPlayer.new(goal_location: @goal_location,
                                my_location: @player_location,
                                map: @map,
                                wall_break: 1)
    when "ai_up"
      @player = AIUpPlayer.new(goal_location: @goal_location,
                               my_location: @player_location,
                               map: @map,
                               wall_break: 1)
    when "ai_left"
      @player = AILeftPlayer.new(goal_location: @goal_location,
                                 my_location: @player_location,
                                 map: @map,
                                 wall_break: 1)
    when "ai_diag"
      @player = AIDiagPlayer.new(goal_location: @goal_location,
                                 my_location: @player_location,
                                 map: @map,
                                 wall_break: 1)
    when "ai_dist"
      @player = AIDistPlayer.new(goal_location: @goal_location,
                                 my_location: @player_location,
                                 map: @map,
                                 wall_break: 1)
    end

    # Begin the game
    puts "Hit <Enter> to begin the game..."
    gets

    Main.game_loop

    puts "Finished Main\n" if Settings.debug_mode
  end

  self.run
end
