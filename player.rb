require_relative 'settings'
require_relative 'matrix'

# This is a super class for the other types of players
class Player

  def initialize(goal_location: [0,0], my_location: [4,4], map: nil, wall_break: 0)
    @steps = 0
    @wall_break = wall_break
    @since_last_wall_break_receive = 0
    @goal_location = goal_location
    @my_location = my_location
    @last_move = [0,0]
    @map = map
    @revealed = Map.new(horizontal: Settings.get_horizontal_size,
                        vertical: Settings.get_vertical_size,
                        default: 0)
    @revealed.see_surrounding(location: @my_location)
    @revealed.reveal_location(loc: goal_location)
    @revealed.reveal_location(loc: my_location)
    @map.render_revealed(revealed: @revealed)
  end

  # Checks if the move is valid
  def valid_move(type: -1, move: [0,0])
    x = @my_location[0] + move[0]
    y = @my_location[1] + move[1]
    puts "Location [#{x},#{y}] is valid? #{@revealed.valid_location(x, y)}" if Settings.debug_mode
    if @revealed.valid_location(x, y)
      if type == 2 # Need to use a WallBreak
        return @wall_break > 0
      end
      return true
    end
  end

  # Moves the player in given direction
  def move(type: -1, movement: [0,0])
    new_loc = [@my_location[0]+movement[0], @my_location[1]+movement[1]]
    puts "Moving player to #{new_loc}" if Settings.debug_mode

    @my_location = new_loc
    @steps += 1

    # If this place is a wall, ues a WallBreak
    if type == 2
      @wall_break -= 1
    else
      if @wall_break < 3 && @since_last_wall_break_receive > 6
        @wall_break += 1
        @since_last_wall_break_receive = 0
      else
        @since_last_wall_break_receive += 1
      end
    end
    @revealed.see_surrounding(location: @my_location)
    @last_move = movement
  end

  def render_before_move
    if @wall_break == 1
      puts "Player has 1 wall break"
    else
      puts "Player has #{@wall_break} wall breaks"
    end
  end

  def get_revealed
    return @revealed
  end

  def get_my_location
    return @my_location
  end

  def get_steps
    return @steps
  end

  def get_wall_break
    return @wall_break
  end
end
