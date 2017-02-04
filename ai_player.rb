require_relative 'settings'
require_relative 'matrix'
require_relative 'player'

class AIPlayer < Player
  #Creates a new ai player
  def initialize(goal_location: [0,0], my_location: [4,4], map: nil, wall_break: 0)
    super(goal_location: goal_location,
          my_location: my_location,
          map: map,
          wall_break: wall_break)
  end
  
  # Returns an array specifying the players next move.
  # Returns -1 to forfeit the game
  def ask_for_move(map:)
    puts "AI deciding its next move, hit <enter> to continue"
    gets.chomp
    frontier = generate_frontier(map: map)
    choose_move_from_frontier(frontier: frontier)
  end

  def generate_frontier(map:)
    known_walls = []
    frontier = Map.new(horizontal: Settings.get_horizontal_size, vertical: Settings.get_vertical_size)
    # Find the known walls
    (0..Settings.get_horizontal_size-1).each do |x|
      (0..Settings.get_vertical_size-1).each do |y|
        if map[x][y] == 2
          known_walls << [x,y]
        end
      end
    end
    # For each location, calculate the frontier value
    (0..Settings.get_horizontal_size-1).each do |x|
      (0..Settings.get_vertical_size-1).each do |y|
        # Heuristic including distance from goal and map element type
        frontier[x][y] = calculate_individual_cell(loc: [x,y], map_value: map[x][y], known_walls: known_walls) + (x-@goal_location[0]).abs + (y-@goal_location[1]).abs
      end
    end
    frontier.reveal if Settings.debug_mode
    return frontier
  end

  def calculate_individual_cell(loc:, map_value:, known_walls:)
    # If we know the map element
    if loc == @my_location
      return 10 # Me
    elsif map_value == 3
      return 0 # Goal
    elsif map_value == 2 # Wall
      if @wall_break == 0
        return 10 # Wall and no wall break
      else
        return 2 # Wall and wall break
      end
    elsif map_value == 1
      return 1 # Floor
    else
      unless known_walls.empty?
        (known_walls).each do |wall|
          if Map.adjacent(wall, loc)
            return 1.5
          end # Adjacent to wall
        end
        return 1.33 # Not adjacent to any known wall
      else
        return 1.33 # Return this if nothing else
      end
    end
  end
end
