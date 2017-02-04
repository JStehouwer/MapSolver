require_relative 'settings'

# Description of map elements
# 0: Used for initialization or for representing a non-revealed location
# -1: Used to represent an uncrossable location
# 1: Used to represent a normal floor location
# 2: Used to represent a wall location
# 3: Used to represent the goal location
# 4: Used to represent Player location
class Map
  # Creates a new map object
  def initialize(horizontal: 5, vertical: 5, default: 0)
    puts "Initializing the Map\n" if Settings.debug_mode()
    @horizontal_size = horizontal
    @vertical_size = vertical
    @player_location = [horizontal-1, vertical-1]

    @map = Map.create_matrix(horiz: @horizontal_size, vert: @vertical_size, default: default)
  end

  # Creates the matrix that stores map data
  def self.create_matrix(horiz: 5, vert: 5, default: 0)
    map = Array.new(horiz, [])
    (0..horiz-1).each do |column|
      map[column] = Array.new(vert, default)
    end
    return map
  end

  # Renders the given map to the console
  def render(map, reveal: false)
    #unless Settings.test_mode
      output = "--------" * map.get_vertical_size() + "-\n"
      map.get_map().each do |column|
        output += "|  " + column.join("\t|  ") + "\t|\n"
        output += "--------" * map.get_vertical_size() + "-\n"
      end

      unless reveal
        # Convert numeric data to visually better map
        output = output.gsub("0", "XXX") # Convert unknown to ?
        output = output.gsub("1", " ") # Convert 1 to _
        output = output.gsub("2", "W") # Convert 2 to W
        output = output.gsub("3", "F") # Convert 3 to F
        output = output.gsub("4", '(")') # Convert 4 to <(")>
      end
      puts output
    #end
  end

  # Renders the entire map to the console
  def render_all
    render(self, reveal: false)
  end

  def reveal
    render(self, reveal: true)
  end

  # Renders the revealed locations of the map
  def render_revealed(revealed: Matrix.new(horiz: @horizontal_size, vert: @vertical_size, default: 0))
    to_render = multiply_each(self, revealed)
    render(to_render, reveal: false)
  end

  # Multiplies the elements of one matrix by the corresponding element in the other matrix
  def multiply_each(x, y)
    if (x.get_horizontal_size() == y.get_horizontal_size) && (x.get_vertical_size() == y.get_vertical_size())
      to_return = Map.new(horizontal: x.get_horizontal_size(),
                             vertical: x.get_vertical_size(),
                             default: 0)
      x_map = x.get_map()
      y_map = y.get_map()
      (0..x.get_horizontal_size()-1).each do |column|
        (0..x.get_vertical_size()-1).each do |row|
          val = x_map[column][row] * y_map[column][row]
          to_return[column][row] = val
        end
      end
      return to_return
    end
    puts "Invalid matrices to multiply each:\n#{x}\n#{y}" if Settings.debug_mode()
    return []
  end

  # Generates a random distribution of basic map elements
  def generate
    (0..@horizontal_size-1).each do |column|
      (0..@vertical_size-1).each do |row|
        val = Settings.get_random.rand(0..10)
        @map[column][row] = val > 3 ? 1 : 2
      end
    end
  end

  # Places the given value at the given location on the map
  def place_object(value, loc)
    @map[loc[0]][loc[1]] = value
  end

  # Places the goal at the given location
  def place_goal(loc)
    place_object(3, loc)
  end

  # Places the in memory player at the given location
  def place_player(loc)
    puts "Map thinks player was at #{@player_location}" if Settings.debug_mode()
    place_object(1, @player_location)
    place_object(4, loc)
    @player_location = loc
    puts "Map thinks player is now at #{@player_location}" if Settings.debug_mode()
  end

  def self.adjacent(loc, other)
    return ((loc[0]-other[0]).abs == 1 && (loc[1]-other[1] == 0)) || ((loc[0]-other[0] == 0) && (loc[1]-other[1]).abs == 1)
  end

  # Reveal around a location
  # If the location is already revealed, this simply does it again
  def see_surrounding(location: [0,0])
    if valid_location(location[0], location[1]-1)
      reveal_location(loc: [location[0], location[1]-1])
    end
    if valid_location(location[0], location[1]+1)
      reveal_location(loc: [location[0], location[1]+1])
    end
    if valid_location(location[0]-1, location[1])
      reveal_location(loc: [location[0]-1, location[1]])
    end
    if valid_location(location[0]+1, location[1])
      reveal_location(loc: [location[0]+1, location[1]])
    end
  end

  # Reveal the specified location on the map for this player
  def reveal_location(loc: [0,0])
    x = loc[0]
    y = loc[1]
    puts "Revealing location: [#{x}, #{y}]" if Settings.debug_mode
    puts "Revealed Map: #{@map}" if Settings.debug_mode
    @map[x][y] = 1
  end

  # Check that the location is a valid location in the map dimensions
  def valid_location(x, y)
    return (x >= 0) && (x < Settings.get_horizontal_size) && (y >= 0) && (y < Settings.get_vertical_size)
  end

  def get_map
    return @map
  end

  def get_horizontal_size
    return @horizontal_size
  end

  def get_vertical_size
    return @vertical_size
  end

  def [](x)
    return @map[x]
  end

end
