require_relative 'settings'
require_relative 'player'

class HumanPlayer < Player
  # Creates a new human player
  def initialize(goal_location: [0,0], my_location: [4,4], map: nil, wall_break: 0)
    super(goal_location: goal_location,
          my_location: my_location,
          map: map,
          wall_break: wall_break)
  end

  # Returns an array specifying the players next move.
  # Returns -1 to forfeit the game
  def ask_for_move(map:)
    command = gets.chomp
    case command
    when "a"
      return [0,-1]
    when "d"
      return [0,1]
    when "w"
      return [-1,0]
    when "s"
      return [1,0]
    when "quit"
      return -1
    end
  end
end
