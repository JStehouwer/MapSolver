require_relative 'ai_player'

class AIDiagPlayer < AIPlayer
  # Given the frontier, calculate the best move
  # This will default Up, Left, Right, Down
  def choose_move_from_frontier(frontier:)
    moves = []
    if @last_move == [0,-1]
      moves = [[-1,0],[0,-1],[0,1],[1,0]]
    else
      moves = [[0,-1],[-1,0],[0,1],[1,0]]
    end
    very_large_number = 100000000
    values = [very_large_number, very_large_number, very_large_number, very_large_number]
    count = 0
    moves.each do |direction|
      loc = Matrix.add_arrays(@my_location, direction)
      if frontier.valid_location(loc[0], loc[1])
        values[count] = frontier[loc[0]][loc[1]]
      end
      count += 1
    end
    return moves[values.find_index(values.min)]
  end
end
