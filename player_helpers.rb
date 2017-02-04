require_relative 'settings'

class PlayerHelpers

  def calculate_frontier(map:)
    (0..Settings.get_greater_dimension-1).each do |dim|
      (0..dim).each do |i|
        if @map.valid_location(i, dim-i)
          map[i][dim-i] = calculate_cell(map: map, cell: [i,dim-i])
        end
      end
    end
    count = 0
    (1..Settings.get_horizontal_size-1).each do |dim|
      (Settings.get_vertical_size-1).downto(dim) do |i|
        if @map.valid_location(dim+count, i)
          map[dim+count][i] = calculate_cell(map: map, cell: [dim+count,i])
        end
        count += 1
      end
      count = 0
    end
    map.reveal
    return map
  end

  def calculate_cell(map:, cell:)
    return shortest_path(map: map, src: cell, dest: @goal_location) + cost_of_cell(map[cell[0]][cell[1]])
  end

  def cost_of_cell(type)
    if type == 2
      if @wall_break > 0
        return 2
      else
        return 1000000
      end
    end
    return 1
  end

  def shortest_path(map:, src:, dest:)
    north = map[src[0]-1][src[1]] if map.valid_location(src[0]-1, src[1])
    west = map[src[0]][src[1]-1] if map.valid_location(src[0], src[1]-1)
    #east = map[src[0]][src[1]+1] if map.valid_location(src[0], src[1]+1)
    #south = map[src[0]+1][src[1]] if map.valid_location(src[0]+1, src[1])
    #up = shortest_path(map: map, src: [src[0]-1,src[1]], dest: dest) + 1 if src[0] > 0
    #left = shortest_path(map: map, src: [src[0],src[1]-1], dest: dest) + 1 if src[1] > 0
    values = [north, west]#, south, east]
    values.delete(nil)
    return values.min + 1
  end

end
