require_relative 'settings'

class Matrix
  def initialize(horiz: 5, vert: 5, default: 0)
    @horizontal_size = horiz
    @vertical_size = vert
    @map = Array.new(horiz, [])
    (0..horiz-1).each do |column|
      @map[column] = Array.new(vert, default)
    end
  end

  def self.multiply_each(x: [], y: [])
    return false
  end

  def self.add_arrays(x, y)
    if (x.length == y.length)
      result = Array.new(x.length, 0)
      (0..result.length-1).each do |i|
        result[i] = x[i] + y[i]
      end
    else
      puts "Invalid arrays being added"
      exit
    end
    return result
  end
end
